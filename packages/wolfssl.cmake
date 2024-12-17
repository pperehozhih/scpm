if (NOT scpm_wolfssl_version)
    set(scpm_wolfssl_version "5.7.4-stable" CACHE STRING "")
endif()
set(scpm_wolfssl_repo "https://github.com/wolfSSL/wolfssl")

if (NOT EXISTS ${scpm_work_dir}/wolfssl-${scpm_wolfssl_version}.installed)
    scpm_download_github_archive("${scpm_wolfssl_repo}" "v${scpm_wolfssl_version}")
    scpm_build_cmake("${scpm_work_dir}/wolfssl-${scpm_wolfssl_version}" "-DBUILD_SHARED_LIBS=OFF" "-DWOLFSSL_OPENSSLEXTRA=ON")
    file(WRITE ${scpm_work_dir}/wolfssl-${scpm_wolfssl_version}.installed)
endif()

if(scpm_platform_macos)
    set(scpm_wolfssl_lib
        wolfssl
        "-framework  Foundation"
        "-framework  SystemConfiguration"
        "-framework  Security"
        "-ObjC"
        CACHE STRING ""
    )
    set(scpm_wolfssl_depends
        ""
        CACHE STRING ""
    )
elseif(scpm_platform_windows)
    set(scpm_wolfssl_lib
        wolfssl
        CACHE STRING ""
    )
    set(scpm_wolfssl_lib_debug
        wolfssld
        CACHE STRING ""
    )
    set(scpm_wolfssl_depends
        ""
        CACHE STRING ""
    )
else()

    set(scpm_wolfssl_lib
        wolfssl
        CACHE STRING ""
    )
    set(scpm_wolfssl_depends
        ""
        CACHE STRING ""
    )

endif()
