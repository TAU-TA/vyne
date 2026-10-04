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
#include <ctime>
#include <random>
#include <iostream>
#include <thread>
#include <chrono>
#include <cstring>
#include <cmath>

#include "../../../compiler/ast/ast.h"
#include "../../../compiler/ast/value.h"
#include "../../../runtime/diagnostics.h"

void setupVCV(SymbolContainer& env, StringPool& pool);