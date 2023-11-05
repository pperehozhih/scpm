if (NOT scpm_stb_version)
        set(scpm_stb_version "master" CACHE STRING "")
endif()
set(scpm_stb_repo "https://github.com/nothings/stb")

function(scpm_stb_copy_file_to_root filename)
    message("COPY ${scpm_work_dir}/stb-${scpm_stb_version}/${filename} ${scpm_root_dir}/include")
    file(COPY ${scpm_work_dir}/stb-${scpm_stb_version}/${filename} DESTINATION ${scpm_root_dir}/include)
endfunction(scpm_stb_copy_file_to_root)

if (NOT EXISTS ${scpm_work_dir}/stb-${scpm_stb_version}.installed)
    execute_process(
        COMMAND git clone -b ${scpm_stb_version} --depth 1 ${scpm_stb_repo} stb-${scpm_stb_version}
        WORKING_DIRECTORY ${scpm_work_dir}
        RESULT_VARIABLE scpm_clone_git_result
    )
    if (NOT scpm_clone_git_result EQUAL "0")
        message(FATAL_ERROR "[SCPM] cannot clone repos ${scpm_stb_repo}")
    endif()
    scpm_stb_copy_file_to_root(stb_image.h)
    scpm_stb_copy_file_to_root(stb_truetype.h)
    scpm_stb_copy_file_to_root(stb_image_write.h)
    scpm_stb_copy_file_to_root(stb_image_resize2.h)
    scpm_stb_copy_file_to_root(stb_rect_pack.h)
    scpm_stb_copy_file_to_root(stb_ds.h)
    scpm_stb_copy_file_to_root(stb_sprintf.h)
    scpm_stb_copy_file_to_root(stb_textedit.h)
    scpm_stb_copy_file_to_root(stb_voxel_render.h)
    scpm_stb_copy_file_to_root(stb_dxt.h)
    scpm_stb_copy_file_to_root(stb_easy_font.h)
    scpm_stb_copy_file_to_root(stb_tilemap_editor.h)
    scpm_stb_copy_file_to_root(stb_herringbone_wang_tile.h)
    scpm_stb_copy_file_to_root(stb_c_lexer.h)
    scpm_stb_copy_file_to_root(stb_divide.h)
    scpm_stb_copy_file_to_root(stb_connected_components.h)
    scpm_stb_copy_file_to_root(stb_leakcheck.h)
    scpm_stb_copy_file_to_root(stb_include.h)
    file(WRITE ${scpm_work_dir}/stb-${scpm_stb_version}.installed)
endif()
