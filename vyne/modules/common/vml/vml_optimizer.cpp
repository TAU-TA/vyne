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

#include "vml_common.h"

namespace VMLNative {

Value native_sgd(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("sgd() requires learning_rate");
    
    double lr = args[0].asFloat();
    SGDOptimizer* opt = new SGDOptimizer(lr);
    return Value(reinterpret_cast<int64_t>(opt));
}

Value native_adam(std::vector<Value>& args) {
    double lr = (args.size() > 0) ? args[0].asFloat() : 0.001;
    double b1 = (args.size() > 1) ? args[1].asFloat() : 0.9;
    double b2 = (args.size() > 2) ? args[2].asFloat() : 0.999;
    double eps = (args.size() > 3) ? args[3].asFloat() : 1e-8;
    
    AdamOptimizer* opt = new AdamOptimizer(lr, b1, b2, eps);
    return Value(reinterpret_cast<int64_t>(opt));
}

Value native_rmsprop(std::vector<Value>& args) {
    // Simplified RMSprop placeholder
    double lr = (args.size() > 0) ? args[0].asFloat() : 0.001;
    SGDOptimizer* opt = new SGDOptimizer(lr);
    return Value(reinterpret_cast<int64_t>(opt));
}

} // namespace VMLNative