
if (EMSCRIPTEN)
    return()
endif(EMSCRIPTEN)

if (NOT scpm_glfw_version)
    set(scpm_glfw_version "3.3.5" CACHE STRING "")
endif()
set(scpm_glfw_repo "https://github.com/glfw/glfw")

if (NOT EXISTS ${scpm_work_dir}/glfw-${scpm_glfw_version}.installed)
    scpm_download_github_archive("${scpm_glfw_repo}" "${scpm_glfw_version}")
    if (CROSS_WIN)
        scpm_build_cmake("${scpm_work_dir}/glfw-${scpm_glfw_version}" "-DGLFW_BUILD_EXAMPLES=OFF" "-DGLFW_BUILD_TESTS=OFF")
    else()
        scpm_build_cmake("${scpm_work_dir}/glfw-${scpm_glfw_version}" "")
    endif()
    file(WRITE ${scpm_work_dir}/glfw-${scpm_glfw_version}.installed)
endif()

set(scpm_glfw_lib
    glfw3
)
set(scpm_glfw_lib_debug
    glfw3d
)
set(scpm_glfw_depends
    ""
    CACHE STRING ""
)

if(scpm_platform_macos)
    set(scpm_glfw_lib ${scpm_glfw_lib}
        "-framework  CoreFoundation"
        "-framework  AppKit"
        "-framework  OpenGL"
        "-framework  IOKit"
        "-framework  Cocoa"
        "-framework  Carbon"
        "-framework  CoreVideo"
        "-ObjC"
    )
elseif(scpm_platform_ios)
    set(scpm_glfw_lib ${scpm_glfw_lib}
        "-framework  OpenGLES"
        "-framework  UIKit"
        "-framework  CoreFoundation"
        "-framework  Foundation"
        "-framework  CoreMotion"
        "-framework  QuartzCore"
        "-ObjC"
    )
elseif (scpm_platform_windows)
    set(scpm_glfw_lib ${scpm_glfw_lib}
        "OpenGL32"
    )
    set(scpm_glfw_lib_debug ${scpm_glfw_lib_debug}
        "OpenGL32"
    )
elseif (scpm_platform_android)
    set(scpm_glfw_lib ${scpm_glfw_lib}
        android
        log 
        EGL
        z
        stdc++
    )
    if (scpm_sfml_gles_one)
        set(scpm_glfw_lib ${scpm_glfw_lib}
            GLESv1_CM
        )
    else()
        set(scpm_glfw_lib ${scpm_glfw_lib}
            GLESv2
        )
    endif()
endif()
set(scpm_glfw_lib ${scpm_glfw_lib} CACHE STRING "")
set(scpm_glfw_lib_debug ${scpm_glfw_lib_debug} CACHE STRING "")
