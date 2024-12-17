if(NOT scpm_platform_android)
    scpm_install(zlib)
endif()
scpm_install(wolfssl)
if (NOT scpm_curl_version)
    set(scpm_curl_version "curl-8_11_1" CACHE STRING "")
endif()
set(scpm_curl_repo "https://github.com/curl/curl")

if (NOT EXISTS ${scpm_work_dir}/curl-${scpm_curl_version}.installed)
    if(EXISTS "${scpm_work_dir}/curl-${scpm_curl_version}")
        file(REMOVE_RECURSE "${scpm_work_dir}/curl-${scpm_curl_version}")
    endif()
    execute_process(
        COMMAND git clone -b ${scpm_curl_version} --depth 1 ${scpm_curl_repo} curl-${scpm_curl_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_curl_clone_reult
    )
    if (NOT scpm_curl_clone_reult EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_curl_repo}")
    endif()
    scpm_build_cmake("${scpm_work_dir}/curl-${scpm_curl_version}" "-DCURL_BUILD_TESTING=OFF" "-DBUILD_SHARED_LIBS=OFF" "-DBUILD_STATIC_LIBS=OFF" "-DBUILD_CURL_EXE=OFF" "-DCURL_USE_WOLFSSL=ON" "-DUSE_NGHTTP2=OFF" "-DCURL_USE_LIBSSH2=OFF" "-DHTTP_ONLY=ON" "-DUSE_LIBIDN2=OFF" "-DCURL_USE_LIBPSL=OFF")
    file(WRITE ${scpm_work_dir}/curl-${scpm_curl_version}.installed)
endif()

if(scpm_platform_windows)
    set(scpm_curl_lib
        curl
        CACHE STRING ""
    )
    set(scpm_curl_lib_debug
        curld
        CACHE STRING ""
    )
    set(scpm_curl_depends
        wolfssl
        zlib
        CACHE STRING ""
    )
else()

    set(scpm_curl_lib
        curl
        CACHE STRING ""
    )
    set(scpm_curl_depends
        wolfssl
        zlib
        CACHE STRING ""
    )

endif()
