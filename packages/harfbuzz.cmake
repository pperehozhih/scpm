if (NOT scpm_harfbuzz_version)
    set(scpm_harfbuzz_version "3.1.1" CACHE STRING "")
endif()
set(scpm_harfbuzz_repo "https://github.com/harfbuzz/harfbuzz")

if (NOT EXISTS ${scpm_work_dir}/harfbuzz-${scpm_harfbuzz_version}.installed)
    scpm_download_and_extract_archive("${scpm_harfbuzz_repo}/releases/download/${scpm_harfbuzz_version}" "harfbuzz-${scpm_harfbuzz_version}.tar.xz")
    scpm_build_cmake("${scpm_work_dir}/harfbuzz-${scpm_harfbuzz_version}" "-DHB_HAVE_FREETYPE=ON")
    # //https://github.com/harfbuzz/harfbuzz/releases/download/3.1.1/harfbuzz-3.1.1.tar.xz
    file(WRITE ${scpm_work_dir}/harfbuzz-${scpm_harfbuzz_version}.installed)
endif()

set(scpm_harfbuzz_lib
    harfbuzz
    CACHE STRING ""
)
set(scpm_harfbuzz_lib_debug
    harfbuzzd
    CACHE STRING ""
)
set(scpm_harfbuzz_depends
    ""
    CACHE STRING ""
)
