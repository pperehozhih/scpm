if (NOT scpm_magic_version)
    set(scpm_magic_version "master" CACHE STRING "")
endif()
set(scpm_magic_repo "https://gitflic.ru/project/paul2la/file.git")

if (NOT EXISTS ${scpm_work_dir}/magic-${scpm_magic_version}.installed)
    if(EXISTS "${scpm_work_dir}/magic-${scpm_magic_version}")
        FILE(REMOVE_RECURSE "${scpm_work_dir}/magic-${scpm_magic_version}")
    endif()
    execute_process(
        COMMAND git clone -b "${scpm_magic_version}" --depth 1 ${scpm_magic_repo} magic-${scpm_magic_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_magic_clone_reult
    )
    if (NOT scpm_magic_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_magic_repo}")
    endif()
    # Hack for disable build utils
    set(buildargs "-DBUILD_FILE_UTILS=OFF" "-DBUILD_MEMTEST_UTILS=OFF" "-DBUILD_SHARED_LIBS=OFF")
    scpm_build_cmake("${scpm_work_dir}/magic-${scpm_magic_version}/cmake" "${buildargs}")
    FILE(WRITE ${scpm_work_dir}/magic-${scpm_magic_version}.installed)
endif()

set(scpm_magic_lib
    magic
    CACHE STRING ""
)
set(scpm_magic_lib_debug
    magicd
    CACHE STRING ""
)
set(scpm_magic_depends
    ""
    CACHE STRING ""
)
