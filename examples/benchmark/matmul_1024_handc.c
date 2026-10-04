// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (C) 2026 Tuncay Gafarli
//
// This file is part of the Vyne compiler.
//
// Vyne is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the
// Free Software Foundation, version 3.
//
// Vyne is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public
// License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Vyne. If not, see <https://www.gnu.org/licenses/>.

// matmul_1024_handc.c — hand-written C equivalent of Vyne config 2.
//
// Same algorithm as matmul_1024.vy's config 2:
//   - Transpose B once into B_T.
//   - Four independent accumulators, no reassociation.
//   - All four matrices on the C stack, matching Vyne's scratch class.
//
// The storage class is what distinguishes this file from config 3.
// Config 3 uses a boxed VyneValue Array (16 bytes/element) allocated
// once and reused; this file uses a native double array (8 bytes/element)
// on the C stack. That is exactly what Vyne's `scratch` construct emits,
// so peak RSS and wall clock should match config 2, not config 3.
//
// Same RNG too: an exact port of the PCG32 in vyne/runtime/modules/vmath.h,
// seeded with 42, filled in the same (r,c) interleaved order. This makes
// the checksum match Vyne's bit-for-bit, which is the correctness check
// that the comparison is apples-to-apples.
//
// Compile:
//   gcc -O3 -w "-Wl,--stack,67108864" matmul_1024_handc.c -o matmul_1024_handc.exe
//
// The stack flag matches what the Vyne driver passes. Without it, the
// four 8 MB stack arrays overflow the default 1 MB Windows stack.

#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define N     1024
#define ITERS 100

// ─── RNG: exact port of vmath.h's PCG32 ──────────────────────────────
static uint64_t _vmath_rng_state = 0;
static uint64_t _vmath_rng_inc   = 0;

static inline uint32_t _vmath_rng_next_u32(void) {
    if (_vmath_rng_state == 0) {
        _vmath_rng_state = (uint64_t)time(NULL)
                         ^ (uint64_t)(size_t)&_vmath_rng_state;
        _vmath_rng_inc   = 1442695040888963407ULL;
        _vmath_rng_state = _vmath_rng_state * 6364136223846793005ULL
                         + _vmath_rng_inc;
    }
    uint64_t old = _vmath_rng_state;
    _vmath_rng_state = old * 6364136223846793005ULL + _vmath_rng_inc;
    uint32_t xorshifted = (uint32_t)(((old >> 18u) ^ old) >> 27u);
    uint32_t rot        = (uint32_t)(old >> 59u);
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

static inline void vmath_seed(int64_t s) {
    _vmath_rng_state = (uint64_t)s;
    _vmath_rng_inc   = 1442695040888963407ULL;
}

static inline double vmath_random_float(double lo, double hi) {
    uint32_t r = _vmath_rng_next_u32();
    double unit = (double)r / 4294967296.0;
    return lo + unit * (hi - lo);
}

// ─── Main ────────────────────────────────────────────────────────────
int main(void) {
    // Stack-resident, matching Vyne's scratch storage class.
    // 4 arrays * 8 MB = 32 MB of stack.
    double A  [N * N];
    double B  [N * N];
    double B_T[N * N];
    double C  [N * N];

    // Seed matches the Vyne source: vmath.seed(42).
    vmath_seed(42);

    // Same fill order as config 3: interleaved A[r,c], B[r,c] per (r,c).
    // This is what makes the checksum match — the RNG advances once for
    // A[r,c] and once for B[r,c], in exactly the same order as the
    // nested `through r / through c` loops in the .vy source.
    for (int r = 0; r < N; ++r) {
        for (int c = 0; c < N; ++c) {
            A[r * N + c] = vmath_random_float(-1.0, 1.0);
            B[r * N + c] = vmath_random_float(-1.0, 1.0);
        }
    }

    // Transpose B once.
    for (int r = 0; r < N; ++r) {
        for (int c = 0; c < N; ++c) {
            B_T[c * N + r] = B[r * N + c];
        }
    }

    // Matmul. Hoisted C, four independent accumulators.
    for (int iter = 1; iter <= ITERS; ++iter) {
        for (int r = 0; r < N; ++r) {
            const double* Arow = &A[r * N];
            for (int c = 0; c < N; ++c) {
                const double* B_Trow = &B_T[c * N];
                double acc0 = 0.0, acc1 = 0.0, acc2 = 0.0, acc3 = 0.0;
                const int k4_end = N / 4;
                for (int k4 = 0; k4 < k4_end; ++k4) {
                    const int k0 = k4 * 4;
                    acc0 += Arow[k0 + 0] * B_Trow[k0 + 0];
                    acc1 += Arow[k0 + 1] * B_Trow[k0 + 1];
                    acc2 += Arow[k0 + 2] * B_Trow[k0 + 2];
                    acc3 += Arow[k0 + 3] * B_Trow[k0 + 3];
                }
                C[r * N + c] = (acc0 + acc1) + (acc2 + acc3);
            }
        }
        if (iter == ITERS) {
            printf("checksum: %g\n", C[0]);
        }
    }

    return 0;
}