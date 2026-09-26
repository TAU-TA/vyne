#pragma once
#include "strings.h"
// ============================================================================
// ARRAY OPERATIONS
// ============================================================================

static inline VyneValue vyne_array_get(VyneValue arr_val, VyneValue index_val) {
    if (arr_val.type != V_ARRAY || index_val.type != V_INT64) return vyne_null();
    VyneArray* arr = arr_val.as.arr;
    int idx = (int)index_val.as.i64;
    if (idx < 0 || idx >= arr->size) return vyne_null();
    return arr->elements[idx];
}

static inline void vyne_array_set(VyneValue arr_val, VyneValue index_val, VyneValue rhs) {
    if (arr_val.type != V_ARRAY || index_val.type != V_INT64) return;
    VyneArray* arr = arr_val.as.arr;
    int idx = (int)index_val.as.i64;
    if (idx >= 0 && idx < arr->size) {
        arr->elements[idx] = rhs;
    }
}

static inline void vyne_array_push(VyneValue arr_val, VyneValue val) {
    if (arr_val.type != V_ARRAY) return;
    VyneArray* arr = arr_val.as.arr;

    if (VYNE_UNLIKELY(arr->size >= arr->capacity)) {
        int new_cap = arr->capacity * 2;
        VyneValue* new_elems = (VyneValue*)arena_alloc(sizeof(VyneValue) * new_cap);
        memcpy(new_elems, arr->elements, sizeof(VyneValue) * arr->size);

        // If the old buffer was the last thing allocated, hand it back
        // to the arena. This turns an N-element build from ~2N slots
        // wasted to ~N (only the final buffer survives).
        arena_try_reclaim(arr->elements, sizeof(VyneValue) * arr->capacity);

        arr->elements = new_elems;
        arr->capacity = new_cap;
    }
    arr->elements[arr->size++] = val;
}

static inline VyneValue vyne_array_deepcopy(VyneValue arr) {
    if (arr.type != V_ARRAY) return arr;
    VyneValue result = vyne_array_create(0);
    VyneArray* src = arr.as.arr;
    for (int i = 0; i < src->size; i++) {
        VyneValue elem = src->elements[i];
        if (elem.type == V_ARRAY) elem = vyne_array_deepcopy(elem);
        else if (elem.type == V_MAP) elem = vyne_map_deepcopy(elem);
        vyne_array_push(result, elem);
    }
    return result;
}

static inline VyneValue vyne_map_deepcopy(VyneValue mp) {
    if (mp.type != V_MAP) return mp;
    VyneValue result = vyne_map_create();
    VyneMap* src = mp.as.map;

    int copied = 0;
    for (int i = 0; i < src->capacity && copied < src->size; i++) {
        const char* key = src->entries[i].key;
        if (key == NULL || key == VYNE_TOMBSTONE) continue;
        VyneValue elem = src->entries[i].value;
        if (elem.type == V_ARRAY) elem = vyne_array_deepcopy(elem);
        else if (elem.type == V_MAP) elem = vyne_map_deepcopy(elem);
        vyne_map_set(result, vyne_string(key), elem);
        copied++;
    }
    return result;
}

static inline VyneValue vyne_array_pop(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return vyne_null();
    VyneArray* arr = arr_val.as.arr;
    if (arr->size == 0) return vyne_null();
    return arr->elements[--arr->size];
}

static inline VyneValue vyne_array_reverse(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return arr_val;
    VyneArray* arr = arr_val.as.arr;
    if (arr->size <= 1) return arr_val;
    int start = 0, end = arr->size - 1;
    while (start < end) {
        VyneValue temp = arr->elements[start];
        arr->elements[start] = arr->elements[end];
        arr->elements[end] = temp;
        start++;
        end--;
    }
    return arr_val;
}

static inline bool vyne_array_contains(VyneValue arr_val, VyneValue target) {
    if (arr_val.type != V_ARRAY) return false;
    VyneArray* arr = arr_val.as.arr;
    for (int i = 0; i < arr->size; i++) {
        if (vyne_values_equal(arr->elements[i], target)) return true;
    }
    return false;
}

// ============================================================================
// EXTENDED ARRAY OPERATIONS
// ============================================================================

static inline VyneValue vyne_array_pop_front(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return vyne_null();
    VyneArray* arr = arr_val.as.arr;
    if (arr->size == 0) return vyne_null();
    VyneValue front = arr->elements[0];
    for (int i = 1; i < arr->size; i++) arr->elements[i - 1] = arr->elements[i];
    arr->size--;
    return front;
}

static inline VyneValue vyne_array_back(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return vyne_null();
    VyneArray* arr = arr_val.as.arr;
    if (arr->size == 0) return vyne_null();
    return arr->elements[arr->size - 1];
}

static inline bool vyne_array_delete(VyneValue arr_val, VyneValue target) {
    if (arr_val.type != V_ARRAY) return false;
    VyneArray* arr = arr_val.as.arr;
    for (int i = 0; i < arr->size; i++) {
        if (vyne_values_equal(arr->elements[i], target)) {
            for (int j = i + 1; j < arr->size; j++) arr->elements[j - 1] = arr->elements[j];
            arr->size--;
            return true;
        }
    }
    return false;
}

static inline VyneValue vyne_array_delete_at(VyneValue arr_val, int64_t idx) {
    if (arr_val.type != V_ARRAY) return vyne_null();
    VyneArray* arr = arr_val.as.arr;
    if (idx < 0 || idx >= arr->size) return vyne_null();
    VyneValue removed = arr->elements[idx];
    for (int i = (int)idx + 1; i < arr->size; i++) arr->elements[i - 1] = arr->elements[i];
    arr->size--;
    return removed;
}

static inline int _vyne_cmp_values(const void* a, const void* b) {
    VyneValue va = *(const VyneValue*)a;
    VyneValue vb = *(const VyneValue*)b;
    if ((va.type == V_INT64 || va.type == V_FLOAT64) &&
        (vb.type == V_INT64 || vb.type == V_FLOAT64)) {
        double da = (va.type == V_FLOAT64) ? va.as.f64 : (double)va.as.i64;
        double db = (vb.type == V_FLOAT64) ? vb.as.f64 : (double)vb.as.i64;
        if (da < db) return -1;
        if (da > db) return  1;
        return 0;
    }
    return 0;
}

static inline int _vyne_cmp_num(VyneValue a, VyneValue b) {
    double da = (a.type == V_FLOAT64) ? a.as.f64 : (double)a.as.i64;
    double db = (b.type == V_FLOAT64) ? b.as.f64 : (double)b.as.i64;
    return (da < db) ? -1 : (da > db) ? 1 : 0;
}

static inline void _vyne_insertion_sort(VyneValue* a, int n) {
    for (int i = 1; i < n; i++) {
        VyneValue k = a[i];
        int j = i - 1;
        while (j >= 0 && _vyne_cmp_num(a[j], k) > 0) {
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = k;
    }
}

static inline void vyne_array_sort(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return;
    VyneArray* arr = arr_val.as.arr;
    if (arr->size <= 1) return;

    // Everything numeric? Fine. Mixed? Bail out with the old no-op behavior.
    for (int i = 0; i < arr->size; i++) {
        if (arr->elements[i].type != V_INT64 &&
            arr->elements[i].type != V_FLOAT64) return;
    }

    // Insertion sort wins for small arrays (no function-pointer overhead).
    if (arr->size < 16) {
        _vyne_insertion_sort(arr->elements, arr->size);
        return;
    }

    qsort(arr->elements, arr->size, sizeof(VyneValue), _vyne_cmp_values);
}

static inline void vyne_array_clear(VyneValue arr_val) {
    if (arr_val.type != V_ARRAY) return;
    arr_val.as.arr->size = 0;
}

static inline void vyne_array_place_all(VyneValue arr_val, VyneValue val, int64_t count) {
    if (arr_val.type != V_ARRAY || count < 0) return;
    VyneArray* arr = arr_val.as.arr;
    if (count > arr->capacity) {
        int new_cap = count < 4 ? 4 : (int)count;
        VyneValue* new_elems = (VyneValue*)arena_alloc(sizeof(VyneValue) * new_cap);
        arr->elements = new_elems;
        arr->capacity = new_cap;
    }
    for (int64_t i = 0; i < count; i++) arr->elements[i] = val;
    arr->size = (int)count;
}

