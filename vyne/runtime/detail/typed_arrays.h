#pragma once
#include "arrays.h"
// ============================================================================
// TYPED ARRAYS
// ============================================================================

static inline VyneArray_f64 vyne_array_f64_create(int64_t n) {
    VyneArray_f64 a;
    a.size = n;
    a.cap  = n > 0 ? n : 4;
    a.data = (double*)arena_alloc(sizeof(double) * (size_t)a.cap);
    for (int64_t i = 0; i < n; ++i) a.data[i] = 0.0;
    return a;
}

static inline VyneArray_i64 vyne_array_i64_create(int64_t n) {
    VyneArray_i64 a;
    a.size = n;
    a.cap  = n > 0 ? n : 4;
    a.data = (int64_t*)arena_alloc(sizeof(int64_t) * (size_t)a.cap);
    for (int64_t i = 0; i < n; ++i) a.data[i] = 0;
    return a;
}

static inline void vyne_array_f64_push(VyneArray_f64* a, double v) {
    if (VYNE_UNLIKELY(a->size >= a->cap)) {
        int64_t new_cap = a->cap * 2;
        double* new_data = (double*)arena_alloc(sizeof(double) * (size_t)new_cap);
        memcpy(new_data, a->data, sizeof(double) * (size_t)a->size);
        arena_try_reclaim(a->data, sizeof(double) * (size_t)a->cap);
        a->data = new_data;
        a->cap  = new_cap;
    }
    a->data[a->size++] = v;
}

static inline void vyne_array_i64_push(VyneArray_i64* a, int64_t v) {
    if (VYNE_UNLIKELY(a->size >= a->cap)) {
        int64_t new_cap = a->cap * 2;
        int64_t* new_data = (int64_t*)arena_alloc(sizeof(int64_t) * (size_t)new_cap);
        memcpy(new_data, a->data, sizeof(int64_t) * (size_t)a->size);
        arena_try_reclaim(a->data, sizeof(int64_t) * (size_t)a->cap);
        a->data = new_data;
        a->cap  = new_cap;
    }
    a->data[a->size++] = v;
}

static inline double vyne_array_f64_get(const VyneArray_f64* a, int64_t i) {
    return (i < 0 || i >= a->size) ? 0.0 : a->data[i];
}

static inline int64_t vyne_array_i64_get(const VyneArray_i64* a, int64_t i) {
    return (i < 0 || i >= a->size) ? 0 : a->data[i];
}

static inline void vyne_array_f64_set(VyneArray_f64* a, int64_t i, double v) {
    if (i >= 0 && i < a->size) a->data[i] = v;
}

static inline void vyne_array_i64_set(VyneArray_i64* a, int64_t i, int64_t v) {
    if (i >= 0 && i < a->size) a->data[i] = v;
}

// --- Boundary conversions -------------------------------------------------
// Boxing: allocate a boxed VyneArray and copy elements in.
static inline VyneValue vyne_array_f64_to_value(const VyneArray_f64* a) {
    VyneValue v = vyne_array_create((int)a->size);
    for (int64_t i = 0; i < a->size; ++i)
        v.as.arr->elements[i] = vyne_float(a->data[i]);
    return v;
}

static inline VyneValue vyne_array_i64_to_value(const VyneArray_i64* a) {
    VyneValue v = vyne_array_create((int)a->size);
    for (int64_t i = 0; i < a->size; ++i)
        v.as.arr->elements[i] = vyne_int(a->data[i]);
    return v;
}

// --- Slice: half-open [lo, hi), matches vyne_slice_get's memcpy count ---
static inline VyneArray_f64 vyne_array_f64_slice(const VyneArray_f64* a,
                                                 int64_t lo, int64_t hi) {
    if (lo < 0) lo = 0;
    if (lo > a->size) lo = a->size;
    if (hi < 0) hi = 0;
    if (hi > a->size) hi = a->size;
    if (lo >= hi) return vyne_array_f64_create(0);

    int64_t n = hi - lo;
    VyneArray_f64 r = vyne_array_f64_create(n);
    memcpy(r.data, a->data + lo, sizeof(double) * (size_t)n);
    return r;
}

static inline VyneArray_i64 vyne_array_i64_slice(const VyneArray_i64* a,
                                                 int64_t lo, int64_t hi) {
    if (lo < 0) lo = 0;
    if (lo > a->size) lo = a->size;
    if (hi < 0) hi = 0;
    if (hi > a->size) hi = a->size;
    if (lo >= hi) return vyne_array_i64_create(0);

    int64_t n = hi - lo;
    VyneArray_i64 r = vyne_array_i64_create(n);
    memcpy(r.data, a->data + lo, sizeof(int64_t) * (size_t)n);
    return r;
}

// --- Unbox: VyneValue -> typed array. Used when a value crosses INTO a
//     typed context (currently only for reassignment guards; kept here so
//     M5 can lift the function-parameter boundary without touching the
//     runtime again). Silent on mismatch, matching the "trust the type
//     annotation" rule.
static inline VyneArray_f64 vyne_value_to_array_f64(VyneValue v) {
    if (v.type != V_ARRAY) return vyne_array_f64_create(0);
    int64_t n = v.as.arr->size;
    VyneArray_f64 r = vyne_array_f64_create(n);
    for (int64_t i = 0; i < n; ++i) {
        VyneValue e = v.as.arr->elements[i];
        r.data[i] = (e.type == V_FLOAT64) ? e.as.f64 : (double)e.as.i64;
    }
    return r;
}

static inline VyneArray_i64 vyne_value_to_array_i64(VyneValue v) {
    if (v.type != V_ARRAY) return vyne_array_i64_create(0);
    int64_t n = v.as.arr->size;
    VyneArray_i64 r = vyne_array_i64_create(n);
    for (int64_t i = 0; i < n; ++i) {
        VyneValue e = v.as.arr->elements[i];
        r.data[i] = (e.type == V_INT64) ? e.as.i64 : (int64_t)e.as.f64;
    }
    return r;
}
