if (NOT scpm_openssl_version)
	set(scpm_openssl_version "openssl-3.0.3" CACHE STRING "")
endif()
set(scpm_openssl_repo "https://github.com/openssl/openssl")

if (NOT EXISTS ${scpm_work_dir}/openssl-${scpm_openssl_version}.installed)
    if (scpm_platform_windows)
        scpm_install(mingw)
    else()
        find_program (scpm_make_exec NAMES "make")
        find_program (scpm_perl_exec NAMES "perl")
    endif()
    if(EXISTS "${scpm_work_dir}/openssl-${scpm_openssl_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/openssl-${scpm_openssl_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_openssl_version} --depth 1 ${scpm_openssl_repo} openssl-${scpm_openssl_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_openssl_clone_reult
    )
    execute_process(
        COMMAND ${scpm_perl_exec} Configure --prefix=${scpm_root_dir}
        WORKING_DIRECTORY "${scpm_work_dir}/openssl-${scpm_openssl_version}"
        RESULT_VARIABLE scpm_openssl_make_result
    )
    execute_process(
        COMMAND ${scpm_make_exec} install DESTDIR=${scpm_root_dir} INSTALLTOP="/"
        WORKING_DIRECTORY "${scpm_work_dir}/openssl-${scpm_openssl_version}"
        RESULT_VARIABLE scpm_openssl_make_result
    )
    file(WRITE ${scpm_work_dir}/openssl-${scpm_openssl_version}.installed)
endif()

set(scpm_openssl_lib
    crypto
    ssl
	CACHE STRING ""
)

set(scpm_openssl_lib_debug
    cryptod
    ssl
	CACHE STRING ""
)

set(scpm_openssl_depends
	""
	CACHE STRING ""
)