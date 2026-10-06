-- ============================================================================
-- Vyne — xmake build script
-- ============================================================================
set_project("vyne")
set_version("0.4.0")
set_encodings("utf-8")

-- Force MinGW toolchain. Xmake defaults to MSVC on Windows; this project
-- is built with g++/gcc from MSYS2 UCRT64.
set_toolchains("mingw")
-- Uncomment and adjust if xmake cannot auto-detect your MinGW install:
-- set_config("mingw", "C:/msys64/ucrt64")

add_rules("mode.debug", "mode.release")

-- ---------------------------------------------------------------------------
-- Paths
-- ---------------------------------------------------------------------------
local root = os.scriptdir()

local RAYLIB_INC = path.join(root, "vendor/raylib/include")
local RAYLIB_LIB = path.join(root, "vendor/raylib/lib")

local URAGE_INC = {
    path.join(root, "vendor/urage/core/include"),
    path.join(root, "vendor/urage/core/src"),
}

local OPENSSL_INC = "C:/msys64/ucrt64/include"
local OPENSSL_LIB = "C:/msys64/ucrt64/lib"

local COMMON_DEFINES = {
    "CPPHTTPLIB_OPENSSL_SUPPORT",
    "_WIN32", "WIN32_LEAN_AND_MEAN", "NOGDI", "NOUSER",
}

local COMMON_LINKS = {
    "ssl", "crypto",
    "raylib", "opengl32", "gdi32", "winmm",
    "shell32", "winpthread", "crypt32", "bcrypt", "ws2_32",
}

local VYNEC_SOURCES = {
    "*.cpp",
    "cli/*.cpp",
    "vyne/**.cpp",
    "editors/vscode/lsp/backend/src/*.cpp",
}

-- ---------------------------------------------------------------------------
-- urage shared library
-- ---------------------------------------------------------------------------
target("urage")
    set_kind("shared")
    set_filename("urage.dll")
    set_targetdir(root)
    set_languages("c11")

    add_files("vendor/urage/core/src/*.c")
    add_includedirs(URAGE_INC)
    add_defines("URAGE_BUILD_SHARED")
target_end()

-- ---------------------------------------------------------------------------
-- vynec — the compiler binary
-- ---------------------------------------------------------------------------
target("vynec")
    set_kind("binary")
    set_filename("vynec.exe")
    set_targetdir(root)

    add_files(VYNEC_SOURCES)

    add_includedirs(
        ".",
        RAYLIB_INC,
        "lsp/backend/src",
        "lsp/backend/include",
        OPENSSL_INC
    )
    add_defines(COMMON_DEFINES)

    add_cxxflags("-std=c++26", { force = true })

    add_ldflags("-mconsole", "-pthread", { force = true })
    add_linkdirs(RAYLIB_LIB, OPENSSL_LIB)
    add_links(COMMON_LINKS)

    if is_mode("release") then
        add_cxxflags("-O3", { force = true })
    elseif is_mode("debug") then
        add_cxxflags("-O0", "-g", { force = true })
    end

    add_deps("urage")
target_end()

-- ===========================================================================
-- Test infrastructure
-- ===========================================================================

local VYNEC_EXE = path.join(root, "vynec.exe")

local SKIP_TESTS = {
    "tests/graphics/game_test.vy",
    "tests/graphics/drone_fpv.vy",
    "tests/graphics/sector_shift.vy",
    "tests/graphics/vcas.vy",
    "tests/graphics/vdec_minigame.vy",
    "tests/graphics/vterm.vy",
    "tests/network/vserv/server.vy",
    "tests/dsp/room_spatializer.vy",
    "tests/dsp/v_studio.vy",
}

local function _is_skipped(f)
    local abs = path.absolute(f)
    for _, s in ipairs(SKIP_TESTS) do
        if path.absolute(s) == abs then return true end
    end
    return false
end

local function _collect(patterns)
    local out = {}
    for _, p in ipairs(patterns) do
        for _, f in ipairs(os.files(p) or {}) do
            table.insert(out, f)
        end
    end
    table.sort(out)
    return out
end

local function _run_one(f)
    local ok = false
    try {
        function ()
            os.execv(VYNEC_EXE, { f }, {
                stdout = os.nuldev(),
                stderr = os.nuldev(),
            })
            ok = true
        end,
        catch {
            function () end,
        }
    }
    return ok
end

local function _run_group(name, patterns)
    if not os.isfile(VYNEC_EXE) then
        raise("vynec.exe not found — run `xmake` first")
    end

    local files = _collect(patterns)
    local total, passed, failed, skipped = 0, 0, 0, 0

    print(("%s tests:"):format(name))
    for _, f in ipairs(files) do
        total = total + 1
        if _is_skipped(f) then
            skipped = skipped + 1
            print("  SKIP: " .. path.basename(f))
        elseif _run_one(f) then
            passed = passed + 1
            print("  PASS: " .. path.basename(f))
        else
            failed = failed + 1
            print("  FAIL: " .. path.basename(f))
        end
    end
    print(("%s: %d total, %d passed, %d failed, %d skipped"):format(
        name, total, passed, failed, skipped))
    print()
    return failed
end

local PATTERNS = {
    compiler = { "tests/compiler/*.vy", "tests/*.vy" },
    dsp      = { "tests/dsp/*.vy" },
    graphics = { "tests/graphics/*.vy" },
    network  = { "tests/network/*.vy" },
    training = { "tests/training/*.vy" },
    vserv    = { "tests/network/vserv/*.vy" },
}

-- ---------------------------------------------------------------------------
-- Individual test tasks
-- ---------------------------------------------------------------------------

task("test-compiler")
    set_category("test")
    set_menu { description = "Run compiler tests" }
    on_run(function ()
        if _run_group("Compiler", PATTERNS.compiler) > 0 then
            raise("Compiler tests failed")
        end
    end)
task_end()

task("test-dsp")
    set_category("test")
    set_menu { description = "Run DSP tests" }
    on_run(function ()
        if _run_group("DSP", PATTERNS.dsp) > 0 then
            raise("DSP tests failed")
        end
    end)
task_end()

task("test-graphics")
    set_category("test")
    set_menu { description = "Run graphics tests" }
    on_run(function ()
        if _run_group("Graphics", PATTERNS.graphics) > 0 then
            raise("Graphics tests failed")
        end
    end)
task_end()

task("test-network")
    set_category("test")
    set_menu { description = "Run network tests" }
    on_run(function ()
        if _run_group("Network", PATTERNS.network) > 0 then
            raise("Network tests failed")
        end
    end)
task_end()

task("test-training")
    set_category("test")
    set_menu { description = "Run training tests" }
    on_run(function ()
        if _run_group("Training", PATTERNS.training) > 0 then
            raise("Training tests failed")
        end
    end)
task_end()

task("test-vserv")
    set_category("test")
    set_menu { description = "Run VServ tests" }
    on_run(function ()
        if _run_group("VServ", PATTERNS.vserv) > 0 then
            raise("VServ tests failed")
        end
    end)
task_end()

task("test-codegen")
    set_category("test")
    set_menu { description = "Run codegen golden tests" }
    on_run(function ()
        if not os.isfile(path.join(root, "scripts/test_codegen.sh")) then
            raise("scripts/test_codegen.sh not found")
        end
        os.execv("bash", { "scripts/test_codegen.sh" }, {
            curdir = root,
            envs = { VYNEC = "./vynec.exe" },
        })
    end)
task_end()

-- ---------------------------------------------------------------------------
-- Aggregate tasks
-- ---------------------------------------------------------------------------

task("test")
    set_category("test")
    set_menu { description = "Run core test suite (compiler, dsp, network, training)" }
    on_run(function ()
        local failed = 0
        failed = failed + _run_group("Compiler", PATTERNS.compiler)
        failed = failed + _run_group("DSP",      PATTERNS.dsp)
        failed = failed + _run_group("Network",  PATTERNS.network)
        failed = failed + _run_group("Training", PATTERNS.training)
        if failed > 0 then raise("Some test groups failed") end
    end)
task_end()

task("test-all")
    set_category("test")
    set_menu { description = "Run every test suite" }
    on_run(function ()
        local failed = 0
        failed = failed + _run_group("Compiler", PATTERNS.compiler)
        failed = failed + _run_group("DSP",      PATTERNS.dsp)
        failed = failed + _run_group("Graphics", PATTERNS.graphics)
        failed = failed + _run_group("Network",  PATTERNS.network)
        failed = failed + _run_group("Training", PATTERNS.training)
        failed = failed + _run_group("VServ",    PATTERNS.vserv)
        if failed > 0 then raise("Some test groups failed") end
    end)
task_end()

task("quick-test")
    set_category("test")
    set_menu { description = "Run fast smoke tests" }
    on_run(function ()
        local tests = {
            "array_test.vy", "for_test.vy", "function_test.vy", "enum_test.vy",
            "interface_test.vy", "map_test.vy", "string_test.vy", "pipeline_test.vy",
        }
        local failed = 0
        for _, name in ipairs(tests) do
            local f = path.join(root, "tests", name)
            if _run_one(f) then
                print("  PASS: " .. name)
            else
                print("  FAIL: " .. name)
                failed = failed + 1
            end
        end
        if failed > 0 then raise("Some quick tests failed") end
    end)
task_end()

task("benchmark")
    set_category("test")
    set_menu { description = "Run performance benchmarks" }
    on_run(function ()
        for _, name in ipairs({ "fib_test.vy", "factorial_test.vy", "bubble_sort_test.vy" }) do
            os.execv(VYNEC_EXE, { "--benchmark", path.join(root, "tests", name) })
        end
    end)
task_end()

task("check-copies")
    set_category("action")
    set_menu { description = "Scan for copy/move warnings" }
    on_run(function ()
        local warn_file = path.join(root, "warning.txt")
        io.writefile(warn_file, "")

        local sources = _collect(VYNEC_SOURCES)
        local base_args = {
            "-std=c++26",
            "-I.", "-I" .. RAYLIB_INC, "-I" .. OPENSSL_INC,
            "-Wpessimizing-move", "-Wredundant-move",
            "-fsyntax-only",
        }

        for _, src in ipairs(sources) do
            print("Checking " .. src .. "...")
            local args = table.clone(base_args)
            table.insert(args, src)
            try {
                function ()
                    os.execv("g++", args, {
                        stdout = warn_file,
                        stderr = warn_file,
                        appendout = true,
                        appenderr = true,
                    })
                end,
                catch { function () end },
            }
        end
        print("Scan complete. Results written to warning.txt")
    end)
task_end()

task("check-leaks")
    set_category("action")
    set_menu { description = "Build with ASan/LSan and run a network test" }
    on_run(function ()
        local sources = _collect(VYNEC_SOURCES)
        local out_exe = path.join(root, "vyne_leak_test.exe")

        local args = {
            "-std=c++26", "-O1", "-g",
            "-fsanitize=address,leak",
            "-I.", "-I" .. RAYLIB_INC, "-I" .. OPENSSL_INC,
            "-DCPPHTTPLIB_OPENSSL_SUPPORT", "-D_WIN32",
            "-DWIN32_LEAN_AND_MEAN", "-DNOGDI", "-DNOUSER",
        }
        for _, s in ipairs(sources) do table.insert(args, s) end
        table.insert(args, "-o");          table.insert(args, out_exe)
        table.insert(args, "-L" .. RAYLIB_LIB)
        table.insert(args, "-L" .. OPENSSL_LIB)
        for _, l in ipairs(COMMON_LINKS) do
            table.insert(args, "-l" .. l)
        end
        table.insert(args, "-mconsole")
        table.insert(args, "-pthread")

        print("Building vyne_leak_test.exe...")
        os.execv("g++", args)

        print("Running vyne_leak_test.exe tests/network/socket.vy ...")
        os.execv(out_exe, { "tests/network/socket.vy" })
    end)
task_end()