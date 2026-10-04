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

Value native_tensor(std::vector<Value>& args) {
    if (args.size() < 2) throw std::runtime_error("tensor() requires rows and cols");
    
    int rows = (int)args[0].asInt();
    int cols = (int)args[1].asInt();
    bool requires_grad = (args.size() > 2) ? args[2].isTruthy() : false;
    
    Tensor* t = new Tensor(rows, cols, requires_grad);
    return Value(reinterpret_cast<int64_t>(t));
}

Value native_tensor_zeros(std::vector<Value>& args) {
    if (args.size() < 2) throw std::runtime_error("zeros() requires rows and cols");
    
    int rows = (int)args[0].asInt();
    int cols = (int)args[1].asInt();
    Tensor* t = new Tensor(rows, cols);
    t->fill(0.0);
    return Value(reinterpret_cast<int64_t>(t));
}

Value native_tensor_ones(std::vector<Value>& args) {
    if (args.size() < 2) throw std::runtime_error("ones() requires rows and cols");
    
    int rows = (int)args[0].asInt();
    int cols = (int)args[1].asInt();
    Tensor* t = new Tensor(rows, cols);
    t->fill(1.0);
    return Value(reinterpret_cast<int64_t>(t));
}

Value native_tensor_random(std::vector<Value>& args) {
    if (args.size() < 2) throw std::runtime_error("random() requires rows and cols");
    
    int rows = (int)args[0].asInt();
    int cols = (int)args[1].asInt();
    double min = (args.size() > 2) ? args[2].asFloat() : -1.0;
    double max = (args.size() > 3) ? args[3].asFloat() : 1.0;
    Tensor* t = new Tensor(rows, cols);
    t->randomize(min, max);
    return Value(reinterpret_cast<int64_t>(t));
}

Value native_tensor_eye(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("eye() requires size");
    
    int size = (int)args[0].asInt();
    Tensor* t = new Tensor(size, size);
    for (int i = 0; i < size; i++) t->data[i][i] = 1.0;
    return Value(reinterpret_cast<int64_t>(t));
}

} // namespace VMLNative