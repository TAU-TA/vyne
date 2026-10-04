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

#include "vglib_common.h"

namespace VGLibNative {

Value native_is_key_down(std::vector<Value>& args) {
    if (args.empty()) return Value(false);
    int key = (int)args[0].asInt();
    return Value(IsKeyDown(key));
}

Value native_is_key_pressed(std::vector<Value>& args) {
    if (args.empty()) return Value(false);
    int key = (int)args[0].asInt();
    return Value(IsKeyPressed(key));
}

// --- ADD NEW NATIVE INPUT BINDINGS ---
Value native_get_char_pressed(std::vector<Value>& args) {
    int key = GetCharPressed();
    if (key == 0) return Value("");

    int byteSize = 0;
    const char* utf8Char = CodepointToUTF8(key, &byteSize);
    return Value(std::string(utf8Char, byteSize));
}

Value native_get_key_pressed(std::vector<Value>& args) {
    int key = GetKeyPressed();
    return Value(static_cast<int64_t>(key));
}

Value native_is_mouse_button_down(std::vector<Value>& args) {
    if (args.empty()) return Value(false);
    int button = (int)args[0].asInt();
    return Value(IsMouseButtonDown(button));
}

Value native_disable_cursor(std::vector<Value>& args) {
    DisableCursor();
    return Value();
}

Value native_enable_cursor(std::vector<Value>& args) {
    EnableCursor();
    return Value();
}

Value native_get_mouse_pos(std::vector<Value>& args) {
    Vector2 m = GetMousePosition();
    return Value(std::vector<Value>{ Value(m.x), Value(m.y) });
}

Value native_get_mouse_delta(std::vector<Value>& args) {
    Vector2 d = GetMouseDelta();
    return Value(std::vector<Value>{ Value(d.x), Value(d.y) });
}

Value get_mouse_wheel(std::vector<Value>& args) {
    return Value((double)GetMouseWheelMove());
}

} // namespace VGLibNative