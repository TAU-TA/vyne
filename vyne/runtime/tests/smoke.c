// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Tuncay Gafarli
//
// This file is part of the Vyne runtime library, distributed under the
// MIT License. See LICENSE-MIT at the repository root for the full text.

#include "../vyne_runtime.h"
#include <assert.h>

int main(void) {
    VyneValue a = vyne_array_create(0);
    vyne_array_push(a, vyne_int(42));
    assert(vyne_array_get(a, vyne_int(0)).as.i64 == 42);
    VyneValue m = vyne_map_create();
    vyne_map_set(m, vyne_string("answer"), vyne_int(42));
    assert(vyne_map_get(m, vyne_string("answer")).as.i64 == 42);
    assert(vyne_values_equal(vyne_int(42), vyne_float(42.0)));
    assert(vyne_binop(vyne_int(2), vyne_int(3), VBOP_ADD).as.i64 == 5);
    ArenaCheckpoint cp = arena_checkpoint();
    (void)vyne_string("temporary");
    arena_rewind(cp);
    arena_free_all();
    return 0;
}
