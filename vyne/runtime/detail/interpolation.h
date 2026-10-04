// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Tuncay Gafarli
//
// This file is part of the Vyne runtime library, distributed under the
// MIT License. See LICENSE-MIT at the repository root for the full text.

#pragma once
#include "modules.h"
// ============================================================================
// INTERPOLATED STRING
// ============================================================================

static inline VyneValue vyne_interpolate(const char* parts[], int part_count, VyneValue* values) {
    size_t total_len = 1;
    for (int i = 0; i < part_count; i++) {
        if (i % 2 == 0) {
            total_len += strlen(parts[i]);
        } else {
            VyneValue str = vyne_to_string(values[i / 2]);
            total_len += strlen(str.as.str);
        }
    }

    char* result = (char*)arena_alloc(total_len);
    size_t pos = 0;
    for (int i = 0; i < part_count; i++) {
        if (i % 2 == 0) {
            const char* s = parts[i];
            size_t len = strlen(s);
            memcpy(result + pos, s, len);
            pos += len;
        } else {
            VyneValue str = vyne_to_string(values[i / 2]);
            size_t len = strlen(str.as.str);
            memcpy(result + pos, str.as.str, len);
            pos += len;
        }
    }
    result[pos] = '\0';
    return vyne_string(result);
}
