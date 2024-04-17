if (NOT scpm_protobuf_version)
    set(scpm_protobuf_version "26.1" CACHE STRING "")
endif()
scpm_install(abseil)
set(scpm_protobuf_repo "https://github.com/protocolbuffers/protobuf")

if (NOT EXISTS ${scpm_work_dir}/protobuf-${scpm_protobuf_version}.installed)
    scpm_download_github_archive("${scpm_protobuf_repo}" "v${scpm_protobuf_version}")
    scpm_build_cmake("${scpm_work_dir}/protobuf-${scpm_protobuf_version}" "-Dprotobuf_BUILD_TESTS=OFF")
    file(WRITE ${scpm_work_dir}/protobuf-${scpm_protobuf_version}.installed)
endif()

set(scpm_protobuf_lib
    protobuf
    CACHE STRING ""
)
set(scpm_protobuf_lib_debug
    protobufd
    CACHE STRING ""
)
set(scpm_protobuf_depends
    CACHE STRING ""
)
