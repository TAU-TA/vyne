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

#ifndef LSP_SERVER_H
#define LSP_SERVER_H

#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <memory>
#include <optional>
#include "../include/nlohmann/json.hpp"
#include "../../../../../vyne/compiler/lexer/lexer.h"    // Path to your lexer
#include "../../../../../vyne/compiler/parser/parser.h"   // Path to your parser
#include "../../../../../vyne/compiler/ast/ast.h"      // Path to your ast

using json = nlohmann::json;

// Source location structure
struct SourceLocation {
    int startLine;
    int startCol;
    int endLine;
    int endCol;
    
    json toJson() const {
        return {
            {"start", {{"line", startLine}, {"character", startCol}}},
            {"end", {{"line", endLine}, {"character", endCol}}}
        };
    }
};

// Represents a single open document
class DocumentState {
public:
    std::string uri;
    std::string text;
    std::vector<Token> tokens;
    std::unique_ptr<ProgramNode> ast;
    std::vector<json> diagnostics;
    
    DocumentState(const std::string& u, const std::string& t) : uri(u), text(t) {}
    
    // Parse the document and generate diagnostics
    bool parse(SymbolContainer& env);
};

// Main LSP Server class
class LspServer {
private:
    std::map<std::string, std::unique_ptr<DocumentState>> documents;
    
    // Handler methods for LSP requests
    json handleInitialize(const json& params);
    json handleShutdown();
    void handleDidOpen(const json& params, SymbolContainer& env);
    void handleDidChange(const json& params, SymbolContainer& env);
    void handleDidClose(const json& params);
    json handleCompletion(const json& params);
    json handleDefinition(const json& params);
    json handleHover(const json& params);
    
    // Send diagnostics back to client
    void publishDiagnostics(const std::string& uri);
    
public:
    void run(SymbolContainer& env);
    json handleRequest(const json& req, SymbolContainer& env);
};

int runLspServer(SymbolContainer& env);

#endif