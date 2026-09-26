#pragma once

// Public codegen dependency surface. AST node emission is implemented across
// the feature-specific .cpp files in this directory, not in this header.
#include <algorithm>
#include <filesystem>
#include <cstdio>
#include <cctype>
#include <charconv>

#include "../ast/ast.h"
#include "../parser/parser.h"
#include "ctype.h"
