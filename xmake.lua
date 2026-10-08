-- ============================================================================
-- Vyne — xmake build script (cross-platform)
-- ============================================================================
set_project("vyne")
set_version("0.4.0")
set_encodings("utf-8")

-- ---------------------------------------------------------------------------
-- Platform detection
-- ---------------------------------------------------------------------------
local is_windows = is_plat("windows")
local is_linux   = is_plat("linux")
local is_macos   = is_plat("macosx")
local is_unix    = is_linux or is_macos

local EXE_SUFFIX = is_windows and ".exe" or ""
local ROOT       = os.scriptdir()

-- Windows: force MinGW (MSVC lacks the C++26 bits we rely on). Linux/macOS:
-- let xmake pick the system compiler.
if is_windows then
    set_toolchains("mingw")
end

add_rules("mode.debug", "mode.release")

-- ---------------------------------------------------------------------------
-- Third-party dependencies
-- ---------------------------------------------------------------------------
-- Raylib: prefer the vendored copy at vendor/raylib if it exists (Windows
-- default). On Unix without a vendored copy, fall back to the system package
-- discovered via pkg-config.
local RAYLIB_INC = path.join(ROOT, "vendor/raylib/include")
local RAYLIB_LIB = path.join(ROOT, "vendor/raylib/lib")
local HAVE_VENDORED_RAYLIB = os.isdir(RAYLIB_LIB) and os.isdir(RAYLIB_INC)

local USE_SYSTEM_RAYLIB = false
if not HAVE_VENDORED_RAYLIB and is_unix then
    local ok, _ = try { function ()
        os.execv("pkg-config", { "--exists", "raylib" })
    end, catch { function () end }
    if ok ~= nil then
        USE_SYSTEM_RAYLIB = true
    end
end

if not HAVE_VENDORED_RAYLIB and not USE_SYSTEM_RAYLIB then
    raise("raylib not found. Either vendor it at vendor/raylib/ or install "
       .. "the system package (apt: libraylib-dev, brew: raylib).")
end

-- OpenSSL: system package on Unix, MSYS2 UCRT64 on Windows.
-- We keep the hardcoded Windows paths only for the MinGW case, where
-- pkg-config is unreliable.
local OPENSSL_INC = is_windows and "C:/msys64/ucrt64/include" or nil
local OPENSSL_LIB = is_windows and "C:/msys64/ucrt64/lib"     or nil

-- ---------------------------------------------------------------------------
-- Defines
-- ---------------------------------------------------------------------------
local COMMON_DEFINES = {
    "CPPHTTPLIB_OPENSSL_SUPPORT",
}
if is_windows then
    table.join2(COMMON_DEFINES, {
        "_WIN32", "WIN32_LEAN_AND_MEAN", "NOGDI", "NOUSER",
    })
end

-- ---------------------------------------------------------------------------
-- Link libraries
-- ---------------------------------------------------------------------------
local COMMON_LINKS
if is_windows then
    COMMON_LINKS = {
        "ssl", "crypto",
        "raylib", "opengl32", "gdi32", "winmm",
        "shell32", "winpthread", "crypt32", "bcrypt", "ws2_32",
    }
else
    -- Linux/macOS: system OpenSSL via -lssl -lcrypto; raylib provides
    -- its own dependencies through pkg-config, but linking against the
    -- shared library by name works for the common distro packages.
    COMMON_LINKS = {
        "ssl", "crypto",
        "raylib",
        "pthread", "dl", "m",
    }
end

-- ---------------------------------------------------------------------------
-- Sources
-- ---------------------------------------------------------------------------
local VYNEC_SOURCES = {
    "*.cpp",
    "cli/*.cpp",
    "vyne/**.cpp",
    "editors/vscode/lsp/backend/src/*.cpp",
}

-- ---------------------------------------------------------------------------
-- vynec — the compiler binary
-- ---------------------------------------------------------------------------
target("vynec")
    set_kind("binary")
    set_filename("vynec" .. EXE_SUFFIX)
    set_targetdir(ROOT)

    add_files(VYNEC_SOURCES)

    add_includedirs(
        ".",
        "editors/vscode/lsp/backend/src",
        "editors/vscode/lsp/backend/include"
    )
    if HAVE_VENDORED_RAYLIB then
        add_includedirs(RAYLIB_INC)
    elseif USE_SYSTEM_RAYLIB then
        add_packages("raylib")
    end
    if is_windows then
        add_includedirs(OPENSSL_INC)
    end

    add_defines(COMMON_DEFINES)

    add_cxxflags("-std=c++26", { force = true })

    if is_windows then
        add_ldflags("-mconsole", { force = true })
        add_linkdirs(RAYLIB_LIB, OPENSSL_LIB)
    end
    add_ldflags("-pthread")
    add_links(COMMON_LINKS)

    if is_mode("release") then
        add_cxxflags("-O3", { force = true })
    elseif is_mode("debug") then
        add_cxxflags("-O0", "-g", { force = true })
    end
target_end()

-- ===========================================================================
-- Test infrastructure
-- ===========================================================================

local VYNEC_EXE = path.join(ROOT, "vynec" .. EXE_SUFFIX)

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
        catch { function () end },
    }
    return ok
end

local function _run_group(name, patterns)
    if not os.isfile(VYNEC_EXE) then
        raise("vynec" .. EXE_SUFFIX .. " not found — run `xmake` first")
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
        local script = path.join(ROOT, "scripts/test_codegen.sh")
        if not os.isfile(script) then
            raise("scripts/test_codegen.sh not found")
        end
        -- bash is present on Git-for-Windows, MSYS2, Linux, and macOS.
        os.execv("bash", { script }, {
            curdir = ROOT,
            envs = { VYNEC = "./vynec" .. EXE_SUFFIX },
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
            local f = path.join(ROOT, "tests", name)
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
            os.execv(VYNEC_EXE, { "--benchmark", path.join(ROOT, "tests", name) })
        end
    end)
task_end()

task("check-copies")
    set_category("action")
    set_menu { description = "Scan for copy/move warnings" }
    on_run(function ()
        local warn_file = path.join(ROOT, "warning.txt")
        io.writefile(warn_file, "")

        local sources = _collect(VYNEC_SOURCES)
        local base_args = {
            "-std=c++26",
            "-I.", "-I" .. OPENSSL_INC,
            "-Wpessimizing-move", "-Wredundant-move",
            "-fsyntax-only",
        }
        if HAVE_VENDORED_RAYLIB then
            table.insert(base_args, "-I" .. RAYLIB_INC)
        end
        if is_windows then
            table.insert(base_args, "-D_WIN32")
        end

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
        -- LeakSanitizer is bundled into ASan on Linux/macOS. On Windows
        -- MinGW, LSan is not available; ASan alone is still useful for
        -- use-after-free, so keep the task working but skip the leak
        -- portion there.
        local sanitizer = is_windows
            and "-fsanitize=address"
            or  "-fsanitize=address,undefined"

        local sources = _collect(VYNEC_SOURCES)
        local out_exe = path.join(ROOT, "vyne_leak_test" .. EXE_SUFFIX)

        local args = { "-std=c++26", "-O1", "-g", sanitizer }
        table.insert(args, "-I.")
        table.insert(args, "-I" .. OPENSSL_INC)
        if HAVE_VENDORED_RAYLIB then
            table.insert(args, "-I" .. RAYLIB_INC)
        end
        for _, d in ipairs(COMMON_DEFINES) do
            table.insert(args, "-D" .. d)
        end

        for _, s in ipairs(sources) do table.insert(args, s) end

        table.insert(args, "-o"); table.insert(args, out_exe)

        if is_windows then
            table.insert(args, "-L" .. RAYLIB_LIB)
            table.insert(args, "-L" .. OPENSSL_LIB)
        end
        for _, l in ipairs(COMMON_LINKS) do
            table.insert(args, "-l" .. l)
        end
        if is_windows then
            table.insert(args, "-mconsole")
        end
        table.insert(args, "-pthread")

        print("Building vyne_leak_test" .. EXE_SUFFIX .. "...")
        os.execv("g++", args)

        print("Running vyne_leak_test" .. EXE_SUFFIX .. " tests/network/socket.vy ...")
        os.execv(out_exe, { "tests/network/socket.vy" })
    end)
task_end()