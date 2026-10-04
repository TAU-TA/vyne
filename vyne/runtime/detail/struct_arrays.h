// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Tuncay Gafarli
//
// This file is part of the Vyne runtime library, distributed under the
// MIT License. See LICENSE-MIT at the repository root for the full text.

#pragma once
#include "typed_arrays.h"

// ============================================================================
// STRUCT ARRAYS — typed containers for user-defined struct elements
// ----------------------------------------------------------------------------
// Mirrors VyneArray_f64 / VyneArray_i64 for POD struct elements. The
// element type (vyne_Atom, vyne_Bond, ...) is a user-declared interface
// typedef emitted by the compiler into the globals stream, so the
// container cannot be pre-declared in the runtime. The compiler emits
// one VYNE_DEFINE_STRUCT_ARRAY instantiation per C-eligible interface,
// immediately after the interface's typedef.
//
// Contract for the expansion:
//   - Container : a bare identifier; the macro pastes _create, _push,
//                 _get, _set, _slice, _deepcopy onto it.
//   - Elem      : a POD C struct type. All fields must be primitive;
//                 no pointers, no nested boxed values. This is enforced
//                 compiler-side by interfaces.cpp:interfaceIsCEligible.
//
// The generated functions have internal linkage to the single emitted
// translation unit. They are static inline, so no symbol collisions
// occur even when the same header is included by multiple runtime
// modules in the same build.
//
// Deepcopy is a shallow struct-copy (memcpy of Elem bytes). This is
// correct only while Elem is POD; the eligibility predicate guarantees
// that. If a future extension allows pointer fields inside Elem, this
// macro's _deepcopy must change to call a per-field clone.
// ============================================================================

#define VYNE_DEFINE_STRUCT_ARRAY(Container, Elem)                             \
    typedef struct {                                                          \
        Elem*   data;                                                         \
        int64_t size;                                                         \
        int64_t cap;                                                          \
    } Container;                                                              \
                                                                              \
    static inline Container Container##_create(int64_t n) {                   \
        Container a;                                                          \
        a.size = n;                                                           \
        a.cap  = _vyne_next_pow2(n);                                          \
        a.data = (Elem*)arena_alloc(sizeof(Elem) * (size_t)a.cap);            \
        memset(a.data, 0, sizeof(Elem) * (size_t)n);                          \
        return a;                                                             \
    }                                                                         \
                                                                              \
    static inline void Container##_push(Container* a, Elem v) {               \
        if (VYNE_UNLIKELY(a->size >= a->cap)) {                               \
            int64_t new_cap  = a->cap * 2;                                    \
            Elem*   old_data = a->data;                                       \
            arena_try_reclaim(old_data, sizeof(Elem) * (size_t)a->cap);       \
            Elem* new_data = (Elem*)arena_alloc(                              \
                sizeof(Elem) * (size_t)new_cap);                              \
            if (new_data != old_data) {                                       \
                memcpy(new_data, old_data,                                    \
                       sizeof(Elem) * (size_t)a->size);                       \
            }                                                                 \
            a->data = new_data;                                               \
            a->cap  = new_cap;                                                \
        }                                                                     \
        a->data[a->size++] = v;                                               \
    }                                                                         \
                                                                              \
    static inline Elem Container##_get(const Container* a, int64_t i) {       \
        if (i < 0 || i >= a->size) {                                          \
            Elem zero;                                                        \
            memset(&zero, 0, sizeof(Elem));                                   \
            return zero;                                                      \
        }                                                                     \
        return a->data[i];                                                    \
    }                                                                         \
                                                                              \
    static inline void Container##_set(Container* a, int64_t i, Elem v) {    \
        if (i >= 0 && i < a->size) a->data[i] = v;                            \
    }                                                                         \
                                                                              \
    static inline Container Container##_slice(const Container* a,             \
                                              int64_t lo, int64_t hi) {       \
        if (lo < 0) lo = 0;                                                   \
        if (lo > a->size) lo = a->size;                                       \
        if (hi < 0) hi = 0;                                                   \
        if (hi > a->size) hi = a->size;                                       \
        if (lo >= hi) return Container##_create(0);                           \
        int64_t n = hi - lo;                                                  \
        Container r = Container##_create(n);                                  \
        memcpy(r.data, a->data + lo, sizeof(Elem) * (size_t)n);               \
        return r;                                                             \
    }                                                                         \
                                                                              \
    static inline Container Container##_deepcopy(const Container* a) {        \
        Container r = Container##_create(a->size);                            \
        memcpy(r.data, a->data, sizeof(Elem) * (size_t)a->size);              \
        return r;                                                             \
    }