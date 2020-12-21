if (NOT scpm_postgres_version)
    set(scpm_postgres_version "REL_12_2" CACHE STRING "")
endif()
set(scpm_postgres_repo "https://github.com/postgres/postgres")

if (NOT EXISTS ${scpm_work_dir}/postgres-${scpm_postgres_version}.installed)
    scpm_download_github_archive("${scpm_postgres_repo}" "${scpm_postgres_version}")
    if (scpm_platform_windows)
        scpm_install(mingw)
        execute_process(
            COMMAND ${scpm_perl_exec} "${scpm_work_dir}/postgres-${scpm_postgres_version}/src/tools/msvc/build.pl"
            WORKING_DIRECTORY "${scpm_work_dir}/postgres-${scpm_postgres_version}"
            RESULT_VARIABLE scpm_build_configure_configure_result
        )
        if (NOT scpm_build_configure_configure_result EQUAL "0")
            message(FATAL_ERROR "[SCPM] cannot build postgres")
        endif()
    else()
        scpm_build_configure("${scpm_work_dir}/postgres-${scpm_postgres_version}")
    endif()
    file(WRITE ${scpm_work_dir}/postgres-${scpm_postgres_version}.installed "")
endif()

set(scpm_postgres_lib
    ""
    CACHE STRING ""
)

set(scpm_postgres_lib_debug
    ""
    CACHE STRING ""
)

set(scpm_postgres_depends
    ""
    CACHE STRING ""
)
