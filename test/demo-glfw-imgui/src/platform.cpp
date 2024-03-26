#include "platform.hpp"
#include <imgui.h>
#include <imgui-glfw.h>
#include <imgui_freetype.h>
#include <fstream>
#include <filesystem>

namespace platform {
    void update_execute_dir(const std::string& dir);
}

int application_main(int argc, char* argv[]);

#ifdef __APPLE__
#include <CoreServices/CoreServices.h>
int main(int argc, char* argv[])
{
    auto dir = std::filesystem::weakly_canonical(std::filesystem::path(argv[0])).parent_path();
    ::platform::update_execute_dir(dir.string());
    return application_main(argc, argv);
}

void platform_add_system_font(){
    ImGuiIO& io = ImGui::GetIO();
    io.Fonts->AddFontFromFileTTF("/System/Library/Fonts/SFNS.ttf", 18, nullptr, io.Fonts->GetGlyphRangesCyrillic());
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

std::string platform_get_config_folder() {
    FSRef ref;
    OSType folderType = kApplicationSupportFolderType;
    char path[PATH_MAX] = {0};
    FSFindFolder(kUserDomain, folderType, kCreateFolder, &ref);
    FSRefMakePath(&ref, (UInt8*)&path, PATH_MAX);
    std::filesystem::path std_path = path;
    std_path /= "0x6efo/";
    std::error_code ec;
    if (std::filesystem::exists(std_path, ec) == false) {
        std::filesystem::create_directory(std_path, ec);
    }
    return std_path;
}

#pragma clang diagnostic pop

#elif WIN32
#include <windows.h>
#include <shellapi.h>
extern "C" {
    _declspec(dllexport) DWORD NvOptimusEnablement = 0x00000001;
}

INT WINAPI wWinMain(HINSTANCE hInst, HINSTANCE hPrevInstance, LPWSTR, INT)
{
    UNREFERENCED_PARAMETER(hInst);
    UNREFERENCED_PARAMETER(hPrevInstance);
    
    int argc;
    char** argv;
    {
        LPWSTR* lpArgv = CommandLineToArgvW(GetCommandLineW(), &argc);
        argv = (char**)malloc(argc * sizeof(char*));
        int size, i = 0;
        for (; i < argc; ++i)
        {
            size = wcslen(lpArgv[i]) + 1;
            argv[i] = (char*)malloc(size);
            wcstombs(argv[i], lpArgv[i], size);
        }
        LocalFree(lpArgv);
    }
    auto dir = std::filesystem::weakly_canonical(std::filesystem::path(argv[0])).parent_path();
    ::platform::update_execute_dir(dir.string());
    return application_main(argc, argv);
}
void platform_add_system_font() {
    ImGuiIO& io = ImGui::GetIO();
    io.Fonts->AddFontFromFileTTF("C:/Windows/Fonts/Segoeui.ttf", 16, nullptr, io.Fonts->GetGlyphRangesCyrillic());
}
#else
void platform_add_system_font(){
    
}
#endif

namespace platform{
    static std::string _execute_location;
    void update_execute_dir(const std::string& dir) {
        _execute_location = dir;
    }
    void platform::load_system_font() {
        platform_add_system_font();
    }
    const std::string& platform::execute_location() {
        return _execute_location;
    }
    std::string platform::load_config(const std::string& filename) {
        std::string path = platform_get_config_folder() + filename;
        std::ifstream file(path);
        std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
        return content;
    }
    void platform::save_config(const std::string& filename, const std::string& content) {
        std::ofstream output(platform_get_config_folder() + filename);
        if (output.is_open()) {
            output << content;
            output.close();
        }
    }
}
