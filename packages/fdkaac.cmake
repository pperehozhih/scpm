if (NOT scpm_fdkaac_version)
    set(scpm_fdkaac_version "2.0.0" CACHE STRING "")
endif()
set(scpm_fdkaac_repo "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac")

if (NOT EXISTS ${scpm_work_dir}/fdkaac-${scpm_fdkaac_version}.installed)
    scpm_download_and_extract_archive("${scpm_fdkaac_repo}" "fdk-aac-${scpm_fdkaac_version}.tar.gz")
    scpm_build_configure("${scpm_work_dir}/fdk-aac-${scpm_fdkaac_version}")
    file(WRITE ${scpm_work_dir}/fdkaac-${scpm_fdkaac_version}.installed)
endif()

set(scpm_fdkaac_lib
    fdk-aac
    CACHE STRING ""
)
set(scpm_fdkaac_lib_debug
    fdk-aac
    CACHE STRING ""
)
set(scpm_fdkaac_depends
    ""
    CACHE STRING ""
)
