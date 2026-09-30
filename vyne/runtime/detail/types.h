#pragma once
#include "arena.h"
// ============================================================================
// VALUE TYPES
// ============================================================================

typedef struct VyneValue VyneValue;
struct VyneArray;
struct VyneArray_f64;
struct VyneArray_i64;
struct VyneStruct;

typedef VyneValue (*VyneMethodFn)(int argc, VyneValue* args);

typedef enum {
    V_NULL = 0,
    V_FLOAT64 = 1,
    V_INT64 = 2,
    V_STRING = 3,
    V_ARRAY = 4,
    V_BOOL = 5,
    V_STRUCT = 6,
    V_FUNCTION = 7,
    V_MODULE = 8,
    V_REFERENCE = 9,
    V_MAP = 10,
    V_F64_ARRAY = 11,   // NEW: .as.arr_f64 — raw double* data, O(1) box/unbox
    V_I64_ARRAY = 12    // NEW: .as.arr_i64 — raw int64_t* data, O(1) box/unbox
} VyneType;

struct VyneValue {
    VyneType type;
    uint32_t  _reserved;
    union {
        double f64;
        int64_t i64;
        char* str;
        struct VyneArray* arr;
        struct VyneArray_f64* arr_f64;
        struct VyneArray_i64* arr_i64;
        struct VyneStruct* strct;
        struct VyneFunction* fn;
        struct VyneMap* map;
        void* ptr;
    } as;
};

// ============================================================================
// ARRAY
// ============================================================================

typedef struct VyneArray {
    VyneValue* elements;
    int size;
    int capacity;
} VyneArray;

typedef struct VyneArray_f64 {   // named so the union can forward-reference it
    double*  data;
    int64_t  size;
    int64_t  cap;
} VyneArray_f64;

typedef struct VyneArray_i64 {   // named so the union can forward-reference it
    int64_t* data;
    int64_t  size;
    int64_t  cap;
} VyneArray_i64;

// ============================================================================
// MAP
// ============================================================================
typedef struct VyneMapEntry {
    const char* key;    // NULL = empty, TOMBSTONE = deleted
    VyneValue value;
} VyneMapEntry;

#define VYNE_TOMBSTONE ((const char*)1)

typedef struct VyneMap {
    VyneMapEntry* entries;   // 2^n slots
    int size;                // occupied (not counting tombstones)
    int capacity;            // == number of slots, always power of 2
    int tombstones;
} VyneMap;

// TODO IMPLEMENT TOMBSTONES

// ============================================================================
// STRUCT
// ============================================================================

typedef struct VyneField {
    uint32_t id;
    const char* name;
    VyneValue value;
} VyneField;

typedef struct VyneStruct {
    const char* type_name;
    VyneField* fields;
    int field_count;
    struct VyneMethodEntry** methods;
    int method_count;
} VyneStruct;

static inline bool vyne_values_equal(VyneValue a, VyneValue b);
static inline VyneValue vyne_to_string(VyneValue v);

static inline VyneValue vyne_array_get(VyneValue arr_val, VyneValue index_val);
static inline void vyne_array_set(VyneValue arr_val, VyneValue index_val, VyneValue rhs);
static inline void vyne_array_push(VyneValue arr_val, VyneValue val);
static inline VyneValue vyne_map_deepcopy(VyneValue mp);

// ============================================================================
// FUNCTION
// ============================================================================

typedef struct VyneFunction {
    int arity;
    int param_count;
    const char** param_names;
    VyneType* param_types;
    bool* is_reference;
    VyneValue* constants;
    uint8_t* bytecode;
    size_t bytecode_size;
    VyneMethodFn native_fn;
    bool is_native;
    const char* name;
    int frame_size;
    const char* expected_return_type;
} VyneFunction;

// ============================================================================
// METHOD TABLE
// ============================================================================

typedef struct VyneMethodEntry {
    const char* type_name;
    const char* method_name;
    VyneMethodFn fn;
} VyneMethodEntry;

static VyneMethodEntry g_method_table[VYNE_MAX_METHODS];
static int g_method_count = 0;

