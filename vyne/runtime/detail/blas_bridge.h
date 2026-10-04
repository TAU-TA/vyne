#pragma once
// ============================================================================
// OpenBLAS bridge
// ----------------------------------------------------------------------------
// Two pieces live here:
//
//   1. The `#ifdef VYNE_USE_OPENBLAS` gate around <cblas.h>. Without the
//      define, this header is a no-op for the matmul lowering but still
//      provides a no-op `vyne_blas_invalidate_cache` so that vmem.h's
//      rewind path links.
//
//   2. `vyne_blas_matmul`, the single runtime function that any BLAS-
//      dispatched matmul call lowers to.
// ============================================================================

// Unconditional declaration. vmem.h calls this from its rewind path
// regardless of whether BLAS is enabled, so the symbol has to exist
// in both builds.
static inline void vyne_blas_invalidate_cache(void);

#ifdef VYNE_USE_OPENBLAS
  #include <cblas.h>

// ============================================================================
// Unbox cache
// ----------------------------------------------------------------------------
// Every vlin op passes A.data and B.data as boxed VyneValues, and unboxing
// them copies 1M elements. In a hot loop the operands don't change, so we
// cache the unboxed result keyed on the boxed array's element pointer.
//
// Safety: the cache is valid only while the boxed operand's storage is
// alive. In general, a region rewind can free A's backing store and a
// subsequent allocation at the same address would false-hit. Call
// `vyne_blas_invalidate_cache()` from any rewind that could free an
// operand — vmem.h already does.
// ============================================================================
static const void*   _vyne_blas_a_key   = NULL;
static VyneArray_f64 _vyne_blas_a_cache;
static const void*   _vyne_blas_b_key   = NULL;
static VyneArray_f64 _vyne_blas_b_cache;

static inline void vyne_blas_invalidate_cache(void) {
    _vyne_blas_a_key = NULL;
    _vyne_blas_b_key = NULL;
}

static inline VyneArray_f64 _vyne_blas_unbox_cached(
    VyneValue v, const void** key, VyneArray_f64* cache)
{
    // V_F64_ARRAY unbox is already O(1): return the shared struct, no cache.
    if (v.type == V_F64_ARRAY) return *v.as.arr_f64;
    if (v.type != V_ARRAY) return vyne_array_f64_create(0);
    if (v.as.arr->elements == *key) return *cache;
    *key   = v.as.arr->elements;
    *cache = vyne_value_to_array_f64(v);
    return *cache;
}

// Extract dimensions and data pointers from two structs with the given
// field IDs, run cblas_dgemm into a freshly allocated output buffer, and
// return a new struct with the same layout as the inputs.
//
// transpose_b = 0  →  C = A · B      ldb = N
// transpose_b = 1  →  C = A · Bᵀ     ldb = K
static inline VyneValue vyne_blas_matmul(
    VyneValue a, VyneValue b,
    const char* type_name,
    uint32_t fid_row, uint32_t fid_col, uint32_t fid_data,
    int transpose_b)
{
    int64_t M = vyne_struct_get(a, fid_row).as.i64;
    int64_t K = vyne_struct_get(a, fid_col).as.i64;
    int64_t N = transpose_b
        ? vyne_struct_get(b, fid_row).as.i64
        : vyne_struct_get(b, fid_col).as.i64;

    VyneArray_f64 a_data = _vyne_blas_unbox_cached(
        vyne_struct_get(a, fid_data), &_vyne_blas_a_key, &_vyne_blas_a_cache);
    VyneArray_f64 b_data = _vyne_blas_unbox_cached(
        vyne_struct_get(b, fid_data), &_vyne_blas_b_key, &_vyne_blas_b_cache);
    VyneArray_f64 out    = vyne_array_f64_create(M * N);

    int64_t ldb = transpose_b ? K : N;

    cblas_dgemm(CblasRowMajor,
                CblasNoTrans,
                transpose_b ? CblasTrans : CblasNoTrans,
                (int)M, (int)N, (int)K,
                1.0, a_data.data, (int)K,
                     b_data.data, (int)ldb,
                0.0, out.data,    (int)N);

    VyneStruct* s = (VyneStruct*)arena_alloc(sizeof(VyneStruct));
    s->type_name = type_name;
    s->field_count = 3;
    s->fields = (VyneField*)arena_alloc(sizeof(VyneField) * 3);
    s->methods = NULL;
    s->method_count = 0;
    s->field_cache[0] = -1;
    s->field_cache[1] = -1;
    s->field_cache[2] = -1;
    s->field_cache[3] = -1;

    s->fields[0].id = fid_row;  s->fields[0].name = "row";
    s->fields[0].value = vyne_int(M);
    s->fields[1].id = fid_col;  s->fields[1].name = "col";
    s->fields[1].value = vyne_int(N);
    s->fields[2].id = fid_data; s->fields[2].name = "data";
    s->fields[2].value = vyne_array_f64_to_value(&out);

    VyneValue res;
    res.type = V_STRUCT;
    res.as.strct = s;
    return res;
}

#else

// BLAS not compiled in. The invalidate hook is a no-op so that vmem.h's
// rewind path links against any build. `vyne_blas_matmul` is not defined;
// the compiler-side dispatcher only emits calls to it under --blas, so no
// generated C needs the symbol when the flag is off.
static inline void vyne_blas_invalidate_cache(void) { }

#endif // VYNE_USE_OPENBLAS