#include "cli/repl.h"
#include "cli/file_handler.h"
#include "cli/packager.h"
#include "vyne/utils/file_utils.h"
#include "editors/vscode/lsp/backend/src/lsp_server.h"
#include <cstring>
#include <string>

static void printHelp() {
    std::cout <<
R"(Vyne compiler and runtime — vynec

Usage:
  vynec <script.vy> [flags]           Compile and run (default)
  vynec --run <script.vy> [flags]     Same as above, explicit
  vynec --compile <script.vy> [flags] Compile to .exe, don't run
  vynec --emit-c <script.vy> [flags]  Emit .vy.c only
  vynec --emit-asm <script.vy> [flags] Emit .vy.s assembly only
  vynec --ast <script.vy> [flags]     Interpret, no C is emitted
  vynec --verify <script.vy> [flags]  Hash-check, then interpret
  vynec --build-game <script.vy>      Bundle a self-contained release
  vynec --lsp                         Start the language server
  vynec                               Start the REPL

Flags:
  --native              Compile with -march=native
  --no-scratch-bounds   Disable VNE-072 bounds checks in emitted C
  --blas                Route vlin.multiply through cblas_dgemm
  -o <name>             Override the output base name (default: script stem)
  -h, --help            Show this message
  -V, --version         Show version
)";
}

int main(int argc, char* argv[]) {
    FileUtils::setExeDir(argv[0]);
    SymbolContainer env;
    uint32_t globalId = StringPool::instance().intern("global");
    env[globalId] = {};

    // --- Sub-commands with a fixed argument shape --------------------
    if (argc > 1 && strcmp(argv[1], "--lsp") == 0)
        return runLspServer(env);

    if (argc == 3 && strcmp(argv[1], "--build-game") == 0) {
        VynePackager packager(argv[2]);
        packager.build();
        return 0;
    }

    // --- Flag scan ---------------------------------------------------
    // Modes are mutually exclusive; the last one wins. `-o name` overrides
    // the derived output base. Unknown flags are ignored so external build
    // tools can pass their own through unharmed.
    BuildOptions opts;
    bool haveMode = false;
    std::string filename;

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        auto setMode = [&](RunMode m) { opts.mode = m; haveMode = true; };

        if (arg == "-h" || arg == "--help")   { printHelp();    return 0; }
        if (arg == "-V" || arg == "--version"){ std::cout << "vynec 1.0\n"; return 0; }

        if      (arg == "--native")            opts.nativeIsa = true;
        else if (arg == "--no-scratch-bounds") opts.scratchBounds = false;
        else if (arg == "--blas")              opts.blasEnabled = true;
        else if (arg == "--verify") { opts.enforceIntegrity = true; setMode(RunMode::Interpret); }
        else if (arg == "--ast")    { setMode(RunMode::Interpret); }
        else if (arg == "--emit-c") { setMode(RunMode::EmitC); }
        else if (arg == "--emit-asm") { setMode(RunMode::EmitAsm); }
        else if (arg == "--compile")  { setMode(RunMode::CompileOnly); }
        else if (arg == "--run")      { setMode(RunMode::CompileRun); }
        else if (arg == "-o" && i + 1 < argc) opts.outputName = argv[++i];
        else if (arg.size() > 2 && arg[0] == '-' && arg[1] == 'o')
            opts.outputName = arg.substr(2);
        else if (!arg.empty() && arg[0] != '-') {
            if (filename.empty()) filename = arg;
        }
    }

    if (filename.empty()) {
        std::string input;
        init_REPL(input, env);
        return 0;
    }

    if (!haveMode) opts.mode = RunMode::CompileRun;

    return runFile(filename, env, opts);
}