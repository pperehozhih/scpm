if (NOT scpm_expat_version)
    set(scpm_expat_version "R_2_2_6" CACHE STRING "")
endif()
set(scpm_expat_repo "https://github.com/libexpat/libexpat")

if (NOT EXISTS ${scpm_work_dir}/libexpat-${scpm_expat_version}.installed)
    scpm_download_github_archive("${scpm_expat_repo}" "${scpm_expat_version}")
    scpm_build_cmake("${scpm_work_dir}/libexpat-${scpm_expat_version}/expat" "-DBUILD_shared=OFF")
    file(WRITE ${scpm_work_dir}/libexpat-${scpm_expat_version}.installed)
endif()

set(scpm_expat_lib
    expat
    CACHE STRING ""
)
set(scpm_expat_lib_debug
    expatd
    CACHE STRING ""
)
set(scpm_expat_depends
    CACHE STRING ""
)
