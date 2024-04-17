if (NOT scpm_flatbuffers_version)
    set(scpm_flatbuffers_version "24.3.25" CACHE STRING "")
endif()
set(scpm_flatbuffers_repo "https://github.com/google/flatbuffers")

if (NOT EXISTS ${scpm_work_dir}/flatbuffers-${scpm_flatbuffers_version}.installed)
    scpm_download_github_archive("${scpm_flatbuffers_repo}" "v${scpm_flatbuffers_version}")
    scpm_build_cmake("${scpm_work_dir}/flatbuffers-${scpm_flatbuffers_version}")
    file(WRITE ${scpm_work_dir}/flatbuffers-${scpm_flatbuffers_version}.installed)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${scpm_root_dir}/lib/cmake/flatbuffers")

set(scpm_flatbuffers_lib
    flatbuffers
    CACHE STRING ""
)
set(scpm_flatbuffers_lib_debug
    flatbuffersd
    CACHE STRING ""
)
set(scpm_flatbuffers_depends
    CACHE STRING ""
)
