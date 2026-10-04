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

#include "vglib.h"
#include <cstring>
#include <cmath>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdexcept>

struct PersistentInstance {
    Vector3 position;
    float scale;
};

extern std::map<std::string, std::vector<PersistentInstance>> persistent_groups;

// helper functions for raw Raylib quad rendering
void DrawCubeTexture(Texture2D texture, Vector3 position, float width, float height, float length, Color color);
void DrawPlaneTexture(Texture2D texture, Vector3 centerPos, Vector2 size, Color color);
void DrawBillboardVyne(Camera3D camera, Texture2D texture, Vector3 position, float size, Color color);