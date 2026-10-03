#pragma once
#include "conversions.h"

// ============================================================================
// STRING BUILDER — runtime implementation
// ----------------------------------------------------------------------------
// Three separate concerns live here:
//
//   1. _vyne_sb_init / _vyne_sb_grow  — internal buffer management.
//   2. vyne_sb_*                      — C API used by module wrappers and
//                                       by any future runtime feature that
//                                       needs to accumulate a string.
//   3. Handle encoding                — a builder pointer is handed to Vyne
//                                       source as an Int64. On every platform
//                                       Vyne targets, intptr_t is <= 64 bits,
//                                       so the cast is lossless.
//
// Including conversions.h gets us both `vyne_string_own` (from values.h,
// transitively) and `vyne_to_string` (defined in conversions.h). No other
// runtime header is needed; the arena and the VyneValue type come in
// through the same chain.
//
// Nothing here mutates existing runtime state. The only globals touched
// are g_arena_cur / g_arena_end / g_arena.total_allocated / peak_allocated,
// and those are touched through arena_alloc, which already maintains them.
// ============================================================================

static inline void _vyne_sb_init(VyneStringBuilder* sb) {
    sb->data     = NULL;
    sb->size     = 0;
    sb->capacity = 0;
}

// Ensure capacity >= size + extra + 1. Doubling growth, so N appends cost
// O(N) total allocations and O(N) total memcpy, not O(N²). The old buffer
// becomes arena garbage — reclaimed at the enclosing region's rewind, or
// at program exit if the builder was created outside any region.
static inline void _vyne_sb_grow(VyneStringBuilder* sb, size_t extra) {
    size_t need = sb->size + extra + 1;
    if (need <= sb->capacity) return;

    size_t new_cap = sb->capacity ? sb->capacity : 64;
    while (new_cap < need) new_cap <<= 1;

    char* new_data = (char*)arena_alloc(new_cap);
    if (sb->data && sb->size > 0) {
        memcpy(new_data, sb->data, sb->size);
    }
    sb->data     = new_data;
    sb->capacity = new_cap;
}

static inline VyneStringBuilder* _vyne_sb_from_handle(int64_t h) {
    return (VyneStringBuilder*)(intptr_t)h;
}

// ---- public C API ------------------------------------------------------

static inline VyneValue vyne_sb_create(void) {
    VyneStringBuilder* sb =
        (VyneStringBuilder*)arena_alloc(sizeof(VyneStringBuilder));
    _vyne_sb_init(sb);
    return vyne_int((int64_t)(intptr_t)sb);
}

static inline void vyne_sb_append_cstr(VyneStringBuilder* sb,
                                       const char* s, size_t len) {
    // Guarantee null termination even on the empty-append case, so
    // build() of a freshly created builder returns "" rather than
    // dereferencing a NULL buffer.
    if (sb->data == NULL) {
        sb->data     = (char*)arena_alloc(1);
        sb->capacity = 1;
        sb->data[0]  = '\0';
    }
    if (len == 0) return;

    _vyne_sb_grow(sb, len);
    memcpy(sb->data + sb->size, s, len);
    sb->size += len;
    sb->data[sb->size] = '\0';
}

static inline void vyne_sb_append_char(VyneStringBuilder* sb, char c) {
    if (sb->data == NULL) {
        sb->data     = (char*)arena_alloc(1);
        sb->capacity = 1;
        sb->data[0]  = '\0';
    }
    _vyne_sb_grow(sb, 1);
    sb->data[sb->size++] = c;
    sb->data[sb->size]   = '\0';
}

// Append any VyneValue. Strings append directly (no intermediate copy);
// every other type routes through vyne_to_string, which is already the
// canonical representation used by `string(x)`, `out(x)`, and string `+`.
// Cost for a non-string is one vyne_to_string call plus one memcpy — the
// same cost the `+` operator already pays, minus the O(n) prefix copy
// that makes `+` quadratic in a loop.
static inline void vyne_sb_append_value(VyneStringBuilder* sb, VyneValue v) {
    if (v.type == V_STRING && v.as.str) {
        vyne_sb_append_cstr(sb, v.as.str, strlen(v.as.str));
        return;
    }
    VyneValue s = vyne_to_string(v);
    if (s.type == V_STRING && s.as.str) {
        vyne_sb_append_cstr(sb, s.as.str, strlen(s.as.str));
    }
}

// Finalize into an independent Vyne String. Copies exactly size+1 bytes
// out, so the returned string is not aliased to the builder's buffer and
// survives any later append or reset. The builder itself remains usable;
// call vyne_sb_reset first if you want to start over with its capacity
// intact.
static inline VyneValue vyne_sb_build(VyneStringBuilder* sb) {
    if (sb->size == 0) return vyne_string("");
    char* out = (char*)arena_alloc(sb->size + 1);
    memcpy(out, sb->data, sb->size);
    out[sb->size] = '\0';
    return vyne_string_own(out);
}

static inline void vyne_sb_reset(VyneStringBuilder* sb) {
    sb->size = 0;
    if (sb->data) sb->data[0] = '\0';
}