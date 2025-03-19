if (NOT scpm_gr_osmosdr_version)
    set(scpm_gr_osmosdr_version "0.2.6" CACHE STRING "")
endif()
set(scpm_gr_osmosdr_repo "https://github.com/osmocom/gr-osmosdr")
scpm_install(gnuradio)

if (NOT EXISTS ${scpm_work_dir}/gr_osmosdr-${scpm_gr_osmosdr_version}.installed)
    scpm_download_github_archive("${scpm_gr_osmosdr_repo}" "v${scpm_gr_osmosdr_version}")
    scpm_build_cmake("${scpm_work_dir}/gr_osmosdr-${scpm_gr_osmosdr_version}")
    file(WRITE ${scpm_work_dir}/gr_osmosdr-${scpm_gr_osmosdr_version}.installed)
endif()

set(scpm_gr_osmosdr_lib
    gr_osmosdr
    CACHE STRING ""
)
set(scpm_gr_osmosdr_lib_debug
    gr_osmosdrd
    CACHE STRING ""
)
set(scpm_gr_osmosdr_depends
    CACHE STRING ""
)
