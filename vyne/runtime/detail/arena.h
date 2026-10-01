#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <time.h>
#include <ctype.h>

#if defined(_MSC_VER)
    #define VYNE_NOINLINE __declspec(noinline)
#elif defined(__GNUC__) || defined(__clang__)
    #define VYNE_NOINLINE __attribute__((noinline))
#else
    #define VYNE_NOINLINE
#endif

#if defined(__GNUC__) || defined(__clang__)
    #define VYNE_LIKELY(x)   __builtin_expect(!!(x), 1)
    #define VYNE_UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
    #define VYNE_LIKELY(x)   (x)
    #define VYNE_UNLIKELY(x) (x)
#endif

#define VYNE_ARENA_BLOCK_SIZE (8 * 1024 * 1024)
// Method dispatch table size. 256 was too small the moment a program
// imported more than two or three `use external` modules. Every group
// function AND every interface method registers an entry. 4096 entries
// × ~32 B = ~128 KB of .bss, which is nothing against the arena.
#define VYNE_MAX_METHODS 4096
#define VYNE_MAX_FRAME_SIZE 1024

// ============================================================================
// ARENA ALLOCATOR
// ============================================================================

typedef struct ArenaBlock {
    uint8_t* data;
    size_t used;
    size_t capacity;
    struct ArenaBlock* next;
} ArenaBlock;

typedef struct {
    ArenaBlock* head;
    size_t total_allocated;
} VyneArena;

static VyneArena g_arena = { NULL, 0 };

// Fast-path bump pointers. Kept in sync with g_arena.head at all times.
// g_arena_cur is the next free byte; g_arena_end is one-past-the-end.
static uint8_t* g_arena_cur = NULL;
static uint8_t* g_arena_end = NULL;

// ============================================================================
// COMMIT ARENA — survives region rewinds
// ----------------------------------------------------------------------------
// A second bump arena, parallel to g_arena. `region.commit(x)` deep-clones x
// into this arena; region rewinds do not touch it, so the committed value
// stays valid after the region closes.
//
// Lifetime: committed values live until program exit. This is a deliberate
// trade-off for the v0 implementation — A2 (escape analysis) will eventually
// let us prove when a committed value can be freed earlier. Until then, a
// commit inside a hot loop grows this arena linearly with iterations.
//
// Freed by arena_free_all() alongside the main arena.
// ============================================================================
static VyneArena g_commit_arena = { NULL, 0 };
static uint8_t* g_commit_cur    = NULL;
static uint8_t* g_commit_end    = NULL;

static inline void* arena_alloc(size_t size) {
    size = (size + 7) & ~(size_t)7;

    uint8_t* p = g_arena_cur;
    if (VYNE_UNLIKELY(p == NULL || (size_t)(g_arena_end - p) < size)) {
        size_t cap = size > VYNE_ARENA_BLOCK_SIZE ? size : VYNE_ARENA_BLOCK_SIZE;
        ArenaBlock* b = (ArenaBlock*)malloc(sizeof(ArenaBlock));
        if (!b) { fprintf(stderr, "vyne: out of memory\n"); exit(1); }
        b->data = (uint8_t*)malloc(cap);
        if (!b->data) { fprintf(stderr, "vyne: out of memory\n"); exit(1); }
        b->used     = size;
        b->capacity = cap;
        b->next     = g_arena.head;
        g_arena.head = b;

        g_arena_cur = b->data + size;
        g_arena_end = b->data + cap;
        g_arena.total_allocated += size;
        return b->data;
    }

    g_arena_cur = p + size;
    g_arena.total_allocated += size;
    return p;
}

// Reclaim the most-recent allocation iff it is still the arena tail.
// Returns 1 on success, 0 if the allocation is not the tail.
static inline int arena_try_reclaim(void* ptr, size_t size) {
    if (ptr == NULL) return 0;
    size = (size + 7) & ~(size_t)7;
    uint8_t* p = (uint8_t*)ptr;
    if (p + size != g_arena_cur) return 0;
    g_arena_cur = p;
    g_arena.total_allocated -= size;
    return 1;
}

static inline void arena_free_all(void) {
    ArenaBlock* block = g_arena.head;
    while (block) {
        ArenaBlock* next = block->next;
        free(block->data);
        free(block);
        block = next;
    }
    g_arena.head            = NULL;
    g_arena_cur             = NULL;
    g_arena_end             = NULL;
    g_arena.total_allocated = 0;

    // also free the commit arena if exists ( see the region part )
    ArenaBlock* cblock = g_commit_arena.head;
    while (cblock) {
        ArenaBlock* next = cblock->next;
        free(cblock->data);
        free(cblock);
        cblock = next;
    }
    g_commit_arena.head            = NULL;
    g_commit_cur                   = NULL;
    g_commit_end                   = NULL;
    g_commit_arena.total_allocated = 0;
}

// ============================================================================
// ARENA CHECKPOINT / REWIND
// ----------------------------------------------------------------------------
// Save a position in the arena, then rewind to it later. Rewind frees every
// block allocated since the checkpoint and resets the bump pointer inside
// the checkpoint's block. The checkpoint itself lives on the C stack.
//
// Constraints:
//   - Any pointer whose target was allocated after the checkpoint is
//     invalidated by rewind. Do not rewind while such pointers are live.
//   - Later checkpoints are invalidated when an earlier one is used.
// ============================================================================

typedef struct {
    ArenaBlock* block;          // the block we were bumping in at checkpoint time
    size_t      offset;         // bytes used within that block
    size_t      total_allocated;// for accounting
} ArenaCheckpoint;

static inline ArenaCheckpoint arena_checkpoint(void) {
    ArenaCheckpoint cp;
    cp.block = g_arena.head;
    cp.offset = (g_arena_cur != NULL && g_arena.head != NULL)
              ? (size_t)(g_arena_cur - g_arena.head->data)
              : 0;
    cp.total_allocated = g_arena.total_allocated;
    return cp;
}

static inline void arena_rewind(ArenaCheckpoint cp) {
    // Drop every block that was created after the checkpoint.
    while (g_arena.head != cp.block && g_arena.head != NULL) {
        ArenaBlock* next = g_arena.head->next;
        free(g_arena.head->data);
        free(g_arena.head);
        g_arena.head = next;
    }
    // Reset the bump pointer inside the surviving block.
    if (cp.block != NULL) {
        g_arena_cur = cp.block->data + cp.offset;
        g_arena_end = cp.block->data + cp.block->capacity;
    } else {
        g_arena_cur = NULL;
        g_arena_end = NULL;
    }
    g_arena.total_allocated = cp.total_allocated;
}

