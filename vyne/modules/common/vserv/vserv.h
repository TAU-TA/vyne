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

#include "../../../compiler/ast/ast.h"
#include "../../../compiler/ast/value.h"
#include <string>
#include <unordered_map>
#include <vector>
#include <functional>

struct Server {
    int port;
    int socket;
    bool running;
    std::vector<std::pair<std::string, std::pair<std::string, Value>>> routes;
    std::vector<Value> middlewares;
};

struct Request {
    std::string method;
    std::string path;
    std::unordered_map<std::string, std::string> headers;
    std::string body;
    std::unordered_map<uint32_t, Value> headers_map;
};

void setupVServ(SymbolContainer& env, StringPool& pool);