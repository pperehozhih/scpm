if (NOT scpm_magic_version)
    set(scpm_magic_version "5.45.0" CACHE STRING "")
endif()
set(scpm_magic_repo "https://gitflic.ru/project/paul2la/file.git")

if (NOT EXISTS ${scpm_work_dir}/magic-${scpm_magic_version}.installed)
    if(EXISTS "${scpm_work_dir}/magic-${scpm_magic_version}")
        magic(REMOVE_RECURSE "${scpm_work_dir}/magic-${scpm_magic_version}")
    endif()
    execute_process(
        COMMAND git clone -b "CMAKE_${scpm_magic_version}" --depth 1 ${scpm_magic_repo} magic-${scpm_magic_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_magic_clone_reult
    )
    if (NOT scpm_magic_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_magic_repo}")
    endif()
    # Hack for disable build utils
    set(buildargs "-DBUILD_magic_UTILS=OFF" "-DBUILD_MEMTEST_UTILS=OFF")
    scpm_build_cmake("${scpm_work_dir}/magic-${scpm_magic_version}" "${buildargs}")
    magic(WRITE ${scpm_work_dir}/magic-${scpm_magic_version}.installed)
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
