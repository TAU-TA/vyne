#pragma once
#include "interpolation.h"

// ============================================================================
// EXCEPTION HANDLING (try / catch / finally / throw)
// ----------------------------------------------------------------------------
// A small stack of jmp_buf frames. Each `try` block pushes one; a `throw`
// pops the innermost frame and longjmp's into its setjmp point.
// ============================================================================

#include <setjmp.h>

#define VYNE_MAX_EXC_FRAMES 64

typedef struct {
    jmp_buf buf;
} VyneExcFrame;

static VyneExcFrame g_exc_stack[VYNE_MAX_EXC_FRAMES];
static int g_exc_top = 0;
static VyneValue g_exc_value;

static inline int vyne_try_push(void) {
    if (g_exc_top >= VYNE_MAX_EXC_FRAMES) {
        fprintf(stderr, "Runtime error: try/catch nested too deep (>%d)\n",
                VYNE_MAX_EXC_FRAMES);
        exit(1);
    }
    return g_exc_top++;
}

static inline void vyne_try_pop(void) {
    if (g_exc_top > 0) g_exc_top--;
}

static inline void vyne_throw(VyneValue val) {
    if (g_exc_top == 0) {
        fprintf(stderr, "Uncaught exception: ");
        _vyne_print_internal(val);
        fprintf(stderr, "\n");
        exit(1);
    }
    g_exc_value = val;
    g_exc_top--;
    longjmp(g_exc_stack[g_exc_top].buf, 1);
}