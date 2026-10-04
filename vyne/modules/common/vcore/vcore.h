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
#include <string>
#include <vector>
#include <ctime>
#include <chrono>
#include <thread>

// Platform-specific headers
#if defined(_WIN32) || defined(_WIN64)
    #define WIN32_LEAN_AND_MEAN
    #define NOMINMAX
    #define NOGDI
    #define NOUSER
    #include <process.h>
    #include <windows.h>
    #include <psapi.h>
    #define getpid _getpid
#elif defined(__linux__) || defined(__APPLE__)
    #include <unistd.h>
    #include <sys/resource.h>
#endif

class SymbolContainer;
class StringPool;

static inline const char* vcore_runtime_now() {
    static char buf[64];
    time_t t = time(NULL);
    struct tm *tm_info = localtime(&t);
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm_info);
    return buf;
}

static inline void vcore_runtime_sleep(long long ms) {
#ifdef _WIN32
    Sleep((DWORD)ms);
#else
    usleep(ms * 1000);
#endif
}

static inline double vcore_get_mem() {
#ifdef _WIN32
    PROCESS_MEMORY_COUNTERS pmc;
    if (GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc)))
        return (double)pmc.WorkingSetSize;
#else
    FILE* fp = fopen("/proc/self/statm", "r");
    if (fp) {
        long rss;
        if (fscanf(fp, "%*s%ld", &rss) == 1) {
            fclose(fp);
            return (double)rss * sysconf(_SC_PAGESIZE);
        }
        fclose(fp);
    }
#endif
    return 0.0;
}

static inline int vcore_get_pid() {
#ifdef _WIN32
    return _getpid();
#else
    return getpid();
#endif
}

void setupVCore(SymbolContainer& env, StringPool& pool);

double getPhysicalMemoryUsage();