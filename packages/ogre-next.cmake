if (NOT scpm_ogre_version)
    set(scpm_ogre_version "2.3.3" CACHE STRING "")
endif()
set(scpm_ogre_repo "https://github.com/OGRECave/ogre-next")

scpm_install(rapidjson)

if (NOT EXISTS ${scpm_work_dir}/ogre-${scpm_ogre_version}.installed)
    scpm_download_github_archive("${scpm_ogre_repo}" "v${scpm_ogre_version}")
    scpm_build_cmake("${scpm_work_dir}/ogre-next-${scpm_ogre_version}" "-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=ON" "-DOGRE_BUILD_LIBS_AS_FRAMEWORKS=NO" "-DOGRE_PLUGIN_LIB_PREFIX=lib" "-DCMAKE_CXX_STANDARD=11")
    file(WRITE ${scpm_work_dir}/ogre-${scpm_ogre_version}.installed)
endif()
if(scpm_platform_windows)
    set(scpm_ogre_lib
        ogre
        CACHE STRING ""
    )
    set(scpm_ogre_lib_debug
        ogred
        CACHE STRING ""
    )
else()
    set(scpm_ogre_lib
        ogre
        CACHE STRING ""
    )
endif()
set(scpm_ogre_depends
    CACHE STRING ""
)
