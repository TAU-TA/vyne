#pragma once
#include "values.h"
// ============================================================================
// MAP OPERATIONS
// ============================================================================

static inline uint32_t _vyne_hash_str(const char* s) {
    uint32_t h = 2166136261u;   // FNV-1a
    while (*s) {
        h ^= (uint8_t)*s++;
        h *= 16777619u;
    }
    return h;
}

static inline VyneValue vyne_map_create(void) {
    VyneValue val = { .type = V_MAP };
    VyneMap* m = (VyneMap*)arena_alloc(sizeof(VyneMap));
    m->capacity   = 8;
    m->size       = 0;
    m->tombstones = 0;
    m->entries    = (VyneMapEntry*)arena_alloc(sizeof(VyneMapEntry) * m->capacity);
    for (int i = 0; i < m->capacity; i++) {
        m->entries[i].key = NULL;
    }
    val.as.map = m;
    return val;
}

static inline int _vyne_map_find(VyneMap* m, const char* key) {
    if (m->size == 0) return -1;
    uint32_t mask = (uint32_t)(m->capacity - 1);
    uint32_t i = _vyne_hash_str(key) & mask;

    for (int probes = 0; probes < m->capacity; ++probes) {
        const char* k = m->entries[i].key;
        if (k == NULL) return -1;
        if (k != VYNE_TOMBSTONE && strcmp(k, key) == 0) return (int)i;
        i = (i + 1) & mask;
    }
    return -1;
}

static void _vyne_map_rehash(VyneMap* m, int new_cap) {
    VyneMapEntry* old      = m->entries;
    int           old_cap  = m->capacity;

    m->entries    = (VyneMapEntry*)arena_alloc(sizeof(VyneMapEntry) * new_cap);
    m->capacity   = new_cap;
    m->size       = 0;
    m->tombstones = 0;
    for (int i = 0; i < new_cap; i++) m->entries[i].key = NULL;

    uint32_t mask = (uint32_t)(new_cap - 1);
    for (int i = 0; i < old_cap; i++) {
        const char* k = old[i].key;
        if (k == NULL || k == VYNE_TOMBSTONE) continue;
        uint32_t j = _vyne_hash_str(k) & mask;
        while (m->entries[j].key != NULL) j = (j + 1) & mask;
        m->entries[j].key   = k;
        m->entries[j].value = old[i].value;
        m->size++;
    }
}

static inline void vyne_map_set(VyneValue map_val, VyneValue key, VyneValue val) {
    if (map_val.type != V_MAP || key.type != V_STRING) return;
    VyneMap* m = map_val.as.map;

    // Grow or compact if load factor is getting high.
    if ((m->size + m->tombstones) * 4 >= m->capacity * 3) {
        int new_cap = (m->size * 2 > m->capacity) ? m->capacity * 2 : m->capacity;
        _vyne_map_rehash(m, new_cap);
    }

    uint32_t mask = (uint32_t)(m->capacity - 1);
    uint32_t i = _vyne_hash_str(key.as.str) & mask;
    int first_tomb = -1;

    for (;;) {
        const char* k = m->entries[i].key;
        if (k == NULL) {
            if (first_tomb >= 0) i = (uint32_t)first_tomb;
            else m->size++;
            m->entries[i].key   = key.as.str;
            m->entries[i].value = val;
            if (first_tomb >= 0) m->tombstones--;
            return;
        }
        if (k == VYNE_TOMBSTONE) {
            if (first_tomb < 0) first_tomb = (int)i;
        } else if (strcmp(k, key.as.str) == 0) {
            m->entries[i].value = val;
            return;
        }
        i = (i + 1) & mask;
    }
}

static inline VyneValue vyne_map_get(VyneValue map_val, VyneValue key) {
    if (map_val.type != V_MAP || key.type != V_STRING) return vyne_null();
    VyneMap* m = map_val.as.map;
    int idx = _vyne_map_find(m, key.as.str);
    if (idx >= 0) return m->entries[idx].value;
    return vyne_null();
}

static inline bool vyne_map_has(VyneValue map_val, VyneValue key) {
    if (map_val.type != V_MAP || key.type != V_STRING) return false;
    return _vyne_map_find(map_val.as.map, key.as.str) >= 0;
}

static inline void vyne_map_delete(VyneValue map_val, VyneValue key) {
    if (map_val.type != V_MAP || key.type != V_STRING) return;
    VyneMap* m = map_val.as.map;
    int idx = _vyne_map_find(m, key.as.str);
    if (idx < 0) return;
    m->entries[idx].key = VYNE_TOMBSTONE;
    m->size--;
    m->tombstones++;
}

static inline void vyne_map_clear(VyneValue map_val) {
    if (map_val.type != V_MAP) return;
    VyneMap* m = map_val.as.map;
    for (int i = 0; i < m->capacity; i++) m->entries[i].key = NULL;
    m->size       = 0;
    m->tombstones = 0;
}

static inline VyneValue vyne_map_keys(VyneValue map_val) {
    if (map_val.type != V_MAP) return vyne_array_create(0);
    VyneMap* m = map_val.as.map;
    VyneValue res = vyne_array_create(m->size);
    VyneValue* elems = res.as.arr->elements;
    int n = 0;
    for (int i = 0; i < m->capacity && n < m->size; i++) {
        const char* k = m->entries[i].key;
        if (k == NULL || k == VYNE_TOMBSTONE) continue;
        elems[n++] = vyne_string(k);
    }
    return res;
}

static inline VyneValue vyne_map_values(VyneValue map_val) {
    if (map_val.type != V_MAP) return vyne_array_create(0);
    VyneMap* m = map_val.as.map;
    VyneValue res = vyne_array_create(m->size);
    VyneValue* elems = res.as.arr->elements;
    int n = 0;
    for (int i = 0; i < m->capacity && n < m->size; i++) {
        const char* k = m->entries[i].key;
        if (k == NULL || k == VYNE_TOMBSTONE) continue;
        elems[n++] = m->entries[i].value;
    }
    return res;
}

static inline VyneValue vyne_index_get(VyneValue base, VyneValue index) {
    if (base.type == V_ARRAY) return vyne_array_get(base, index);
    if (base.type == V_MAP) return vyne_map_get(base, index);
    if (base.type == V_STRING && index.type == V_INT64) {
        const char* s = base.as.str;
        int len = (int)strlen(s);
        int idx = (int)index.as.i64;
        if (idx < 0 || idx >= len) return vyne_null();
        return vyne_char_at(s, idx);
    }
    return vyne_null();
}

static inline void vyne_index_set(VyneValue base, VyneValue index, VyneValue val) {
    if (base.type == V_ARRAY) { vyne_array_set(base, index, val); return; }
    if (base.type == V_MAP)   { vyne_map_set(base, index, val);   return; }
}

static inline void vyne_dismiss_module(const char* name) {
    (void)name;
}

