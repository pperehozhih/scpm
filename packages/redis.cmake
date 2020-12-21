if (NOT scpm_redis_version)
    set(scpm_redis_version "5.0.8" CACHE STRING "")
endif()
set(scpm_redis_repo "https://github.com/antirez/redis")

if (NOT EXISTS ${scpm_work_dir}/redis-${scpm_redis_version}.installed)
    scpm_download_github_archive("${scpm_redis_repo}" "${scpm_redis_version}")
    scpm_build_make("${scpm_work_dir}/redis-${scpm_redis_version}")
    file(WRITE ${scpm_work_dir}/redis-${scpm_redis_version}.installed "")
endif()

set(scpm_redis_lib
    ""
    CACHE STRING ""
)

set(scpm_redis_lib_debug
    ""
    CACHE STRING ""
)

set(scpm_redis_depends
    ""
    CACHE STRING ""
)
