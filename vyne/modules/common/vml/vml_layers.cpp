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

Value native_dense(std::vector<Value>& args) {
    if (args.size() < 2) throw std::runtime_error("dense() requires input_size and output_size");
    
    int input_size = (int)args[0].asInt();
    int output_size = (int)args[1].asInt();
    std::string activation = (args.size() > 2) ? args[2].asString() : "relu";
    std::string name = (args.size() > 3) ? args[3].asString() : "dense";
    
    DenseLayer* layer = new DenseLayer(input_size, output_size, activation, name);
    return Value(reinterpret_cast<int64_t>(layer));
}

Value native_activation(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("activation() requires activation type");
    
    std::string activation = args[0].asString();
    std::string name = (args.size() > 1) ? args[1].asString() : "activation";
    
    ActivationLayer* layer = new ActivationLayer(activation, name);
    return Value(reinterpret_cast<int64_t>(layer));
}

Value native_dropout(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("dropout() requires dropout rate");
    
    double rate = args[0].asFloat();
    std::string name = (args.size() > 1) ? args[1].asString() : "dropout";
    
    DropoutLayer* layer = new DropoutLayer(rate, name);
    return Value(reinterpret_cast<int64_t>(layer));
}

Value native_flatten(std::vector<Value>& args) {
    std::string name = (args.size() > 0) ? args[0].asString() : "flatten";
    
    // FlattenLayer is a special layer that reshapes input to 1D
    // Simplified: just returns a placeholder
    return Value(reinterpret_cast<int64_t>(new ActivationLayer("none", name)));
}

Value native_reshape_layer(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("reshape_layer() requires target_size");
    
    int target_size = (int)args[0].asInt();
    std::string name = (args.size() > 1) ? args[1].asString() : "reshape";
    
    // Simplified placeholder
    return Value(reinterpret_cast<int64_t>(new ActivationLayer("none", name)));
}

} // namespace VMLNative