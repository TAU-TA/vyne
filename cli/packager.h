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

#ifndef VYNE_PACKAGER_H
#define VYNE_PACKAGER_H

#include <string>
#include <iostream>
#include <filesystem>
#include <set>

class VynePackager {
public:
    explicit VynePackager(const std::string& scriptPath);

    void build();

private:
    std::string mainScript;

    void scanDependencies(const std::string& filePath, const std::string& outDir, std::set<std::string>& processed);
    
    void copyFileWithStructure(const std::string& path, const std::string& outDir);
};

#endif