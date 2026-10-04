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

#include "file_handler.h"
#include "../vyne/utils/sha256.h"
#include <map>

// ---------------------------------------------------------------------------
// Integrity check (unchanged)
// ---------------------------------------------------------------------------
bool verifyIntegrity(const std::string& scriptPath) {
    namespace fs = std::filesystem;
    fs::path filePath(scriptPath);
    fs::path baseDir = filePath.parent_path();
    fs::path manifestPath = baseDir.empty() ? "checksums.dat" : baseDir / "checksums.dat";

    if (!fs::exists(manifestPath)) return true;

    std::ifstream manifest(manifestPath);
    if (!manifest.is_open()) return true;

    std::string relPath, expectedHash;
    std::map<std::string, std::string> expectedHashes;
    while (manifest >> relPath >> expectedHash) {
        expectedHashes[relPath] = expectedHash;
    }

    std::string fileKey = filePath.filename().string();
    auto it = expectedHashes.find(fileKey);
    if (it == expectedHashes.end()) return true;

    std::string currentHash = SHA256::hashFile(scriptPath);
    if (currentHash != it->second) {
        std::cerr << RED << "[SECURITY ERROR] Integrity check failed for "
                  << scriptPath << "! File modified or corrupted." << RESET << "\n";
        return false;
    }
    return true;
}

// ---------------------------------------------------------------------------
// Local helpers
// ---------------------------------------------------------------------------
namespace {

std::string outputBase(const std::string& filename, const BuildOptions& opts) {
    if (!opts.outputName.empty()) return opts.outputName;
    size_t dotPos = filename.find_last_of(".");
    return (dotPos == std::string::npos) ? filename : filename.substr(0, dotPos);
}

std::string humanSize(uintmax_t bytes) {
    if (bytes < 1024)          return std::to_string(bytes) + " B";
    if (bytes < 1024 * 1024)   return std::to_string(bytes / 1024) + " KB";
    return std::to_string(bytes / (1024 * 1024)) + " MB";
}

void sectionOpen(const char* label) {
    std::cout << "\n";
    std::cout << CYAN << "  >> " << label << RESET << "\n";
    std::cout << CYAN << "  " << std::string(42, '-') << RESET << "\n\n";
}
void sectionClose() {
    std::cout << "\n";
    std::cout << CYAN << "  " << std::string(42, '-') << RESET << "\n\n";
}

} // namespace

// ---------------------------------------------------------------------------
// Transpile + downstream phases
// ---------------------------------------------------------------------------
// Common path for --emit-c, --emit-asm, --compile, --run. The Vyne -> C step
// runs unconditionally; the mode decides where the driver stops.
// ---------------------------------------------------------------------------
static int runTranspile(const std::string& filename,
                        const std::string& content,
                        const BuildOptions& opts)
{
    auto tokens_for_count = tokenize(content);
    int tokenCount = (int)tokens_for_count.size();
    int lineCount  = (int)std::count(content.begin(), content.end(), '\n') + 1;

    std::cout << "\n";
    std::cout << BOLD << "  Compiling " << RESET << filename << "\n\n";

    // ---------------- Phase 1: Vyne source -> C source ----------------
    auto start_transpile = std::chrono::high_resolution_clock::now();

    VyneLinker linker;
    auto units = linker.link(filename);

    C_Emitter emitter;
    emitter.reset();
    emitter.setScratchBoundsEnabled(opts.scratchBounds);

    if (opts.blasEnabled) {
        emitter.setBlasEnabled(true);
        emitter.addSystemInclude("cblas.h");
    }

    for (const auto& unit : units) emitter.markImported(unit.canonicalPath);
    for (auto& unit : units) {
        emitter.setSourceDir(
            std::filesystem::path(unit.canonicalPath).parent_path().string());
        if (unit.alias.empty()) unit.ast->compile(emitter);
        else                    unit.ast->compileAliased(emitter, unit.alias);
    }

    std::string exeDir  = FileUtils::getExeDir();
    std::string runtime = exeDir + "/vyne/runtime/vyne_runtime.h";
    std::string cSource = emitter.finalize(runtime);

    std::string base    = outputBase(filename, opts);
    std::string cFile   = base + ".vy.c";
    std::string asmFile = base + ".vy.s";
    std::string exeName = base;
#ifdef _WIN32
    exeName += ".exe";
#endif

    {
        std::ofstream out(cFile);
        if (!out.is_open()) {
            std::cerr << RED << "  error" << RESET
                      << "  could not write " << cFile << "\n";
            return 1;
        }
        out << cSource;
    }

    auto end_transpile = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> transpile_ms = end_transpile - start_transpile;

    std::cout << GREEN << "  transpile" << RESET
              << "  " << lineCount << " lines  "
              << tokenCount << " tokens  "
              << std::fixed << std::setprecision(2) << transpile_ms.count() << "ms\n";

    // ---------------- Phase 2a: stop here for --emit-c ----------------
    if (opts.mode == RunMode::EmitC) {
        sectionOpen("emitted");
        std::cout << "    " << cFile << "  ("
                  << humanSize(std::filesystem::file_size(cFile)) << ")\n";
        sectionClose();

        vprintln("\n{}{}{}  >> summary {}", BOLD, YELLOW, "", RESET);
        vprintln("{} {} source      {} ({}) {}", YELLOW, "  -", GREEN, cFile, RESET);
        vprintln("     {}lines       {}", GREEN, lineCount);
        vprintln("     {}tokens      {}", GREEN, tokenCount);
        vprintln("     {}transpile   {:.2f}ms", GREEN, transpile_ms.count());
        vprintln("{} {} {}total       {:.2f}ms", YELLOW, "  -", BOLD, transpile_ms.count());

        Vyne::DiagnosticEngine::printSummary();
        return 0;
    }

    // Common gcc flags, extended per downstream mode.
    auto gccBase = [&]() {
        std::string cmd = "gcc \"" + cFile + "\"";
        cmd += " -I\"" + exeDir + "\" -O3 -w";
        if (opts.nativeIsa) cmd += " -march=native";
        if (opts.blasEnabled) {
            std::string obInclude = exeDir + "/vendor/openblas/include";
#ifdef _WIN32
            std::string obLib = exeDir + "/vendor/openblas/lib/libopenblas.dll.a";
#else
            std::string obLib = "-lopenblas";
#endif
            cmd += " -DVYNE_USE_OPENBLAS";
            cmd += " -I\"" + obInclude + "\"";
            cmd += " \"" + obLib + "\"";
        }
        return cmd;
    };

    // ---------------- Phase 2b: assemble for --emit-asm ----------------
    if (opts.mode == RunMode::EmitAsm) {
        std::string cmd = gccBase() + " -S -o \"" + asmFile + "\"";

        auto start_asm = std::chrono::high_resolution_clock::now();
        int rc = system(cmd.c_str());
        auto end_asm = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> asm_ms = end_asm - start_asm;

        if (rc != 0) {
            std::cerr << "\n" << RED << "  error" << RESET
                      << "  gcc -S failed — see above\n\n";
            return 1;
        }

        std::cout << GREEN << "  assemble " << RESET
                  << "  gcc -S" << (opts.nativeIsa ? " -march=native" : "")
                  << "  "
                  << std::fixed << std::setprecision(2) << asm_ms.count() << "ms\n";

        sectionOpen("emitted");
        std::cout << "    " << asmFile << "  ("
                  << humanSize(std::filesystem::file_size(asmFile)) << ")\n";
        std::cout << "    " << cFile   << "  ("
                  << humanSize(std::filesystem::file_size(cFile))
                  << ", intermediate)\n";
        sectionClose();

        double total_ms = transpile_ms.count() + asm_ms.count();
        vprintln("\n{}{}{}  >> summary {}", BOLD, YELLOW, "", RESET);
        vprintln("{} {} source      {} ({}) {}", YELLOW, "  -", GREEN, asmFile, RESET);
        vprintln("     {}transpile   {:.2f}ms", GREEN, transpile_ms.count());
        vprintln("     {}assemble    {:.2f}ms", GREEN, asm_ms.count());
        vprintln("{} {} {}total       {:.2f}ms", YELLOW, "  -", BOLD, total_ms);

        Vyne::DiagnosticEngine::printSummary();
        return 0;
    }

    // ---------------- Phase 2c: link for --compile / --run -------------
    std::string cmd = gccBase() + " -o \"" + exeName + "\"";
#ifdef _WIN32
    cmd += " -Wl,--stack,67108864";
#else
    cmd += " -Wl,-z,stacksize=67108864";
#endif

    auto start_compile = std::chrono::high_resolution_clock::now();
    int compile_result = system(cmd.c_str());
    auto end_compile   = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> compile_ms = end_compile - start_compile;

    if (compile_result != 0) {
        std::cerr << "\n" << RED << "  error" << RESET
                  << "  gcc failed — see above\n\n";
        return 1;
    }

#ifdef _WIN32
    if (opts.blasEnabled) {
        std::string obDll = exeDir + "/vendor/openblas/bin/libopenblas.dll";
        std::error_code ec;
        std::filesystem::copy_file(
            obDll,
            std::filesystem::path(exeName).parent_path() / "libopenblas.dll",
            std::filesystem::copy_options::overwrite_existing,
            ec);
        if (ec) {
            std::cerr << RED
                      << "  warning  could not copy libopenblas.dll: "
                      << ec.message() << RESET << "\n";
        }
    }
#endif

    std::string sizeStr = std::filesystem::exists(exeName)
        ? humanSize(std::filesystem::file_size(exeName))
        : "?";

    std::cout << GREEN << "  compile  " << RESET
              << "  gcc -O3" << (opts.nativeIsa ? " -march=native" : "")
              << "  "
              << std::fixed << std::setprecision(2) << compile_ms.count() << "ms\n";

    // ---------------- Phase 3: run for --run (default) ----------------
    if (opts.mode == RunMode::CompileRun) {
        sectionOpen("output");

        // cmd.exe on Windows treats '/' as a switch prefix and does not
        // resolve a bare relative path against the CWD when the first
        // token isn't the exe name. Normalise to backslashes and force
        // a `.\` prefix for relative paths. POSIX shells are happy with
        // what we already have.
#ifdef _WIN32
        std::string runExe = exeName;
        std::replace(runExe.begin(), runExe.end(), '/', '\\');
        bool isAbsolute =
            (runExe.size() >= 2 && runExe[1] == ':') ||
            (runExe.size() >= 2 && runExe[0] == '\\' && runExe[1] == '\\') ||
            (!runExe.empty()    && runExe[0] == '\\');
        if (!isAbsolute && runExe.rfind(".\\", 0) != 0) {
            runExe = ".\\" + runExe;
        }
        std::string runCmd = "\"" + runExe + "\"";
#else
        std::string runCmd = "\"" + exeName + "\"";
#endif

        auto start_exec = std::chrono::high_resolution_clock::now();
        int run_result = system(runCmd.c_str());
        auto end_exec = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double, std::milli> exec_ms = end_exec - start_exec;

        sectionClose();

        double total_ms = transpile_ms.count() + compile_ms.count() + exec_ms.count();

        vprintln("\n{}{}{}  >> summary {}", BOLD, YELLOW, "", RESET);
        vprintln("{} {} binary     {} ({}) {}", YELLOW, "  -", GREEN, exeName, CYAN, sizeStr, RESET);
        vprintln("     {}transpile {:.2f}ms", GREEN, transpile_ms.count());
        vprintln("     {}compile   {:.2f}ms", GREEN, compile_ms.count());
        vprintln("     {}execution {:.2f}ms", GREEN, exec_ms.count());
        vprintln("{} {} {}total      {:.2f}ms", YELLOW, "  -", BOLD, total_ms);

        if (run_result != 0)
            std::cout << RED << "  >> exited with code " << run_result << RESET << "\n\n";

        Vyne::DiagnosticEngine::printSummary();
        return 0;
    }

    // ---------------- --compile: stop after the .exe is built ----------------
    double total_ms = transpile_ms.count() + compile_ms.count();
    vprintln("\n{}{}{}  >> summary {}", BOLD, YELLOW, "", RESET);
    vprintln("{} {} binary     {} ({}) {}", YELLOW, "  -", GREEN, exeName, CYAN, sizeStr, RESET);
    vprintln("     {}transpile {:.2f}ms", GREEN, transpile_ms.count());
    vprintln("     {}compile   {:.2f}ms", GREEN, compile_ms.count());
    vprintln("{} {} {}total      {:.2f}ms", YELLOW, "  -", BOLD, total_ms);

    Vyne::DiagnosticEngine::printSummary();
    return 0;
}

// ---------------------------------------------------------------------------
// Interpret path
// ---------------------------------------------------------------------------
static int runInterpret(const std::string& filename,
                        SymbolContainer& env,
                        const std::shared_ptr<ASTNode>& rootShared,
                        Parser& parser)
{
    auto start = std::chrono::high_resolution_clock::now();

    env.setSourceDir(filename);
    uint32_t globalId = StringPool::instance().intern("global");
    rootShared->evaluate(env, globalId);

    auto end = std::chrono::high_resolution_clock::now();
    parser.checkUnusedVariables(env);
    std::chrono::duration<double, std::milli> ms = end - start;

    std::cout << GREEN << "\nExecution finished in: " << ms.count() << "ms" << RESET;

    bool hasErrors = false;
    for (const auto& d : Vyne::DiagnosticEngine::getDiagnostics()) {
        if (d.severity == Vyne::Severity::Error ||
            d.severity == Vyne::Severity::Critical) hasErrors = true;
    }
    Vyne::DiagnosticEngine::printSummary();
    return hasErrors ? 1 : 0;
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------
int runFile(const std::string& filename, SymbolContainer& env,
            const BuildOptions& opts)
{
    if (opts.enforceIntegrity && !verifyIntegrity(filename)) return 1;

    size_t dotPos = filename.find_last_of(".");
    if (dotPos == std::string::npos) {
        std::cerr << RED << "Error: File must end in .vy ( .vyne )" << RESET << "\n";
        return 1;
    }
    std::string ext = filename.substr(dotPos + 1);
    if (ext != "vy" && ext != "vyne") {
        std::cerr << RED << "Error: File must end in .vy ( .vyne )" << RESET << "\n";
        return 1;
    }

    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << RED << "Could not open file: " << filename << RESET << "\n";
        return 1;
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    const std::string content = buffer.str();

    Vyne::DiagnosticEngine::setSourceText(content);
    Vyne::DiagnosticEngine::setCurrentFile(
        std::filesystem::path(filename).filename().string());

    try {
        auto tokens = tokenize(content);
        Parser parser(std::move(tokens));
        parser.setSourceDir(
            std::filesystem::weakly_canonical(std::filesystem::absolute(filename))
                .parent_path().string());
        auto programRoot = parser.parseProgram(env);
        std::shared_ptr<ASTNode> rootShared = std::move(programRoot);

        bool hasErrors = false;
        for (const auto& d : Vyne::DiagnosticEngine::getDiagnostics()) {
            if (d.severity == Vyne::Severity::Error ||
                d.severity == Vyne::Severity::Critical) hasErrors = true;
        }
        if (hasErrors) {
            std::cerr << RED << "Compilation failed due to errors" << RESET << "\n";
            return 1;
        }

        if (opts.mode == RunMode::Interpret)
            return runInterpret(filename, env, rootShared, parser);

        return runTranspile(filename, content, opts);

    } catch (const std::exception& e) {
        if (Vyne::DiagnosticEngine::getDiagnostics().empty()) {
            const std::string& f = Vyne::DiagnosticEngine::getCurrentFile();
            std::cerr << RED << "Error";
            if (!f.empty()) std::cerr << " in " << f;
            std::cerr << ": " << e.what() << RESET << "\n";
        }
        Vyne::DiagnosticEngine::printSummary();
        return 1;
    }
}