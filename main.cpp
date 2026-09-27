#include "cli/repl.h"
#include "cli/file_handler.h"
#include "cli/packager.h"
#include "vyne/utils/file_utils.h"
#include "editors/vscode/lsp/backend/src/lsp_server.h"
#include <cstring>
#include <string>

int main(int argc, char* argv[]) {
    FileUtils::setExeDir(argv[0]);
    SymbolContainer env;

    uint32_t globalId = StringPool::instance().intern("global");
    env[globalId] = {};

    // --- Sub-command entry points (unchanged) ------------------------
    if (argc > 1 && strcmp(argv[1], "--lsp") == 0) {
        return runLspServer(env);
    }

    if (argc == 3 && strcmp(argv[1], "--build-game") == 0) {
        VynePackager packager(argv[2]);
        packager.build();
        return 0;
    }

    // --- Flag scan ----------------------------------------------------
    // Any order, any position, one filename. `--native` only affects
    // the "c" (transpile) path: it appends `-march=native` to the gcc
    // invocation that builds the emitted C. In "ast" (interpreter)
    // mode it is accepted and ignored, so `--verify --native file.vy`
    // doesn't error out on a meaningless combination.
    //
    // Unknown flags are ignored rather than rejected, matching the
    // old permissive behavior (which silently no-op'd on them).
    bool nativeIsa        = false;
    bool enforceIntegrity = false;
    std::string mode;
    std::string filename;

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];

        if (arg == "--native") {
            nativeIsa = true;
        } else if (arg == "--verify") {
            enforceIntegrity = true;
            mode = "ast";
        } else if (arg == "--ast") {
            mode = "ast";
        } else if (arg == "--c" || arg == "--compile") {
            mode = "c";
        } else if (!arg.empty() && arg[0] != '-') {
            if (filename.empty()) filename = arg;
        }
    }

    if (filename.empty()) {
        std::string input;
        init_REPL(input, env);
        return 0;
    }

    if (mode.empty()) mode = "ast";

    return runFile(filename, env, mode, enforceIntegrity, nativeIsa);
}