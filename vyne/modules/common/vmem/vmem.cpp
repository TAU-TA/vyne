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

#include "vmem.h"

/**
 * vmem Native Method Implementations
 */

namespace VMemNative {
    static SymbolContainer* g_env = nullptr;
    static size_t memory_limit = 0;

    void setEnv(SymbolContainer& env) {
        g_env = &env;
    }

    Value peek(std::vector<Value>& args) {
        if (args.empty()) throw std::runtime_error("vmem.peek requires an address");

        uintptr_t addr = static_cast<uintptr_t>(args[0].asInt());
        
        Value* target = reinterpret_cast<Value*>(addr);

        return *target; 
    }

    Value poke(std::vector<Value>& args) {
        if (args.size() < 2) throw std::runtime_error("vmem.poke requires address and value");

        uintptr_t addr = static_cast<uintptr_t>(args[0].asInt());
        Value* target = reinterpret_cast<Value*>(addr);

        *target = args[1]; 

        return Value(true);
    }

    size_t calculateCurrentUsage() {
        size_t totalBytes = 0;
        if (!g_env) return 0;
        
        for (auto const& [groupId, table] : *g_env) {
            totalBytes += StringPool::instance().get(groupId).capacity();
            totalBytes += sizeof(table);
            for (auto const& [id, val] : table) {
                totalBytes += StringPool::instance().get(id).capacity();
                totalBytes += sizeof(Value);
                totalBytes += val.getDeepBytes();
            }
        }
        return totalBytes;
    }

    Value usage(std::vector<Value>& args){
        size_t totalBytes = 0;

        if(args.size() > 1) throw std::runtime_error("Argument Error : vmem.usage() takes 1 or non-argument, but got " + std::to_string(args.size()));

        if (!g_env) return Value(0.0);

        if(args.empty()){
            return Value(static_cast<double>(calculateCurrentUsage()));
        } else {
            return Value(args[0].getDeepBytes());
        }
    }
}

void setupVMem(SymbolContainer& env, StringPool& pool) {
    VMemNative::setEnv(env);
    const std::string& path = "vmem";
    
    if (env.find(path) == env.end()) {
        env[path] = SymbolTable();
    }

    auto& vmem = env[path];

    Vyne::globalUsageFetcher = VMemNative::calculateCurrentUsage;

    // vmem methods
    vmem[pool.intern("usage")]     = Value(VMemNative::usage);
    vmem[pool.intern("peek")]      = Value(VMemNative::peek);
    vmem[pool.intern("poke")]      = Value(VMemNative::poke);

    // vmem properties
}