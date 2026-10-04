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

#pragma once
#include <atomic>

namespace VAudioDSP {
    inline float g_sample_rate = 48000.0f;
    inline std::atomic<float> g_analyzer_envelope{0.0f};
    inline std::atomic<float> g_envelope         {0.0f}; 
    inline std::atomic<float> g_out_envelope     {0.0f};
    inline std::atomic<float> g_current_gr_db    {0.0f};
    inline std::atomic<float> g_fft_bins[64];
    
    inline float g_rms_sq_state{0.0f};
}