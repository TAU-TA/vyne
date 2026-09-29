#pragma once
// ============================================================================
// OpenBLAS bridge
// ----------------------------------------------------------------------------
// Two pieces live here:
//
//   1. The `#ifdef VYNE_USE_OPENBLAS` gate around <cblas.h>. Without the
//      define, this header is a no-op and the runtime builds with no BLAS
//      dependency at all.
//
//   2. `vyne_blas_matmul`, the single runtime function that any BLAS-
//      dispatched matmul call lowers to. The compiler emits a call to this
//      function; the function does the field extraction, calls cblas_dgemm,
//      and wraps the result in a fresh struct.
//
// Included at the end of vyne_runtime.h, after the entire runtime chain has
// been processed — so VyneStruct, VyneField, vyne_struct_get, and every
// other helper used below is already in scope. Do not reorder this include
// ahead of exceptions.h in vyne_runtime.h.
// ============================================================================

#ifdef VYNE_USE_OPENBLAS
  #include <cblas.h>

// Extract dimensions and data pointers from two structs with the given
// field IDs, run cblas_dgemm into a freshly allocated output buffer, and
// return a new struct with the same layout as the inputs.
//
// transpose_b = 0  →  C = A · B      ldb = N
// transpose_b = 1  →  C = A · Bᵀ     ldb = K
//
// Row-major throughout. The three field-name strings written into the
// result struct are cosmetic — `vyne_struct_get` searches by ID, and the
// result is always constructed fresh, so only the IDs have to match the
// caller's Matrix layout.
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

    VyneArray_f64 a_data = vyne_value_to_array_f64(vyne_struct_get(a, fid_data));
    VyneArray_f64 b_data = vyne_value_to_array_f64(vyne_struct_get(b, fid_data));
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

#endif // VYNE_USE_OPENBLAS