#ifndef platform_hpp
#define platform_hpp

#include <string>

namespace platform {
    class platform {
    public:
        static const std::string& execute_location();
        static void load_system_font();
        static std::string load_config(const std::string& filename);
        static void save_config(const std::string& filename,
                               const std::string& content);
    };
}

#endif /* platform_hpp */
