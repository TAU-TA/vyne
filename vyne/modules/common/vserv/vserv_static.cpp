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

#include "vserv_common.h"
#include <fstream>

namespace VServNative {

Value native_serve_file(std::vector<Value>& args) {
    if (args.empty()) throw std::runtime_error("serve_file() requires path");
    
    std::string path = args[0].asString();
    std::ifstream file(path, std::ios::binary);
    
    if (!file.is_open()) {
        throw std::runtime_error("File not found: " + path);
    }
    
    std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    
    std::unordered_map<uint32_t, Value> response;
    response[StringPool::intern("status")] = Value((int64_t)200);
    response[StringPool::intern("body")] = Value(content);
    
    // Set Content-Type based on extension
    std::string ext = get_file_extension(path);
    std::string content_type = get_mime_type(ext);
    std::unordered_map<uint32_t, Value> headers;
    headers[StringPool::intern("Content-Type")] = Value(content_type);
    response[StringPool::intern("headers")] = Value(headers);
    
    return Value(response);
}

} // namespace VServNative