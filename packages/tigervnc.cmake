if (NOT scpm_tigervnc_version)
    set(scpm_tigervnc_version "1.15.0" CACHE STRING "")
endif()
set(scpm_tigervnc_repo "https://github.com/TigerVNC/tigervnc.git")

if (NOT EXISTS ${scpm_work_dir}/tigervnc-${scpm_tigervnc_version}.installed)
    scpm_download_github_archive("${scpm_tigervnc_repo}" "v${scpm_tigervnc_version}")
    scpm_build_cmake("${scpm_work_dir}/tigervnc-${scpm_tigervnc_version}")
    file(WRITE ${scpm_work_dir}/tigervnc-${scpm_tigervnc_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_tigervnc_lib
        tigervnc
        CACHE STRING ""
    )
    set(scpm_tigervnclib_debug
        tigervncd
        CACHE STRING ""
    )
else()
    set(scpm_tigervnc_lib
        tigervnc
        CACHE STRING ""
    )
endif()
set(scpm_tigervnc_depends
    CACHE STRING ""
)
