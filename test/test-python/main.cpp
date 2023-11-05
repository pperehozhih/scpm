#include <imgui.h>
#include <imgui-glfw.h>
#include <stdio.h>
#include <GLFW/glfw3.h>

static void glfw_error_callback(int error, const char* description)
{
    fprintf(stderr, "Glfw Error %d: %s\n", error, description);
}

int main() {
       // Setup window
    glfwSetErrorCallback(glfw_error_callback);
    if (!glfwInit())
        return 1;

    // Decide GL+GLSL versions
#ifdef __APPLE__
    // GL 3.2 + GLSL 150
    const char* glsl_version = "#version 150";
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);  // 3.2+ only
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // Required on Mac
#else
    // GL 3.0 + GLSL 130
    const char* glsl_version = "#version 130";
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);
    //glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);  // 3.2+ only
    //glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // 3.0+ only
#endif

    // Create window with graphics context
    GLFWwindow* window = glfwCreateWindow(1280, 720, "Dear ImGui + GLFW example", NULL, NULL);
    if (window == NULL)
        return 1;
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1); // Enable vsync
    if (!ImGui::GLFW::Init(window)) {
        return -1;
    }
    auto&& io = ImGui::GetIO();
//    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;
//    io.ConfigDockingWithShift = true;
    ImGui::GLFW::UpdateFontTexture();
    bool show_demo_window = true;
    bool show_another_window = true;
   while (!glfwWindowShouldClose(window)) {
      glfwPollEvents();

      // Start the Dear ImGui frame
      ImGui::GLFW::NewFrame();
      
      
      ImGui::ShowDemoWindow();
      
      ImGui::Begin("Hello, world!");
      ImGui::Button("Look at this pretty button");
      ImGui::End();
      ImGui::Render();
      ImGui::GLFW::Render(window);

      glfwSwapBuffers(window);
   }
   
   ImGui::GLFW::Shutdown();

   glfwDestroyWindow(window);
   glfwTerminate();
   return 0;

}
