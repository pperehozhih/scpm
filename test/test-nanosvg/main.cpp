#include <nanosvg/nanosvg.h>
#include <nanosvg/nanosvgrast.h>
#include <stdio.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb_image_write.h>

int main() {
    auto image = nsvgParseFromFile("/tmp/scpm/test/test-nanosvg/build/scpm/nanosvg_master/example/23.svg", "px", 96);
    int w = (int)image->width;
    int h = (int)image->height;

    auto rast = nsvgCreateRasterizer();
    if (rast == 0) {
        printf("Could not init rasterizer.\n");
        return -1;
    }

    unsigned char* img = new unsigned char[w*h*4];
    nsvgRasterize(rast, image, 0,0,1, img, w, h, w*4);
    stbi_write_png("/tmp/svg.png", w, h, 4, img, w*4);
    return 0;
}
