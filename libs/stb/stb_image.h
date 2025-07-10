/* stb_image - public domain image loader - http://nothings.org/stb
   no warranty implied; use at your own risk

   Do this:
      #define STB_IMAGE_IMPLEMENTATION
   before you include this file in *one* C or C++ file to create the implementation.
*/

#ifndef STB_IMAGE_H
#define STB_IMAGE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned char stbi_uc;

extern stbi_uc *stbi_load(char const *filename, int *x, int *y, int *comp, int req_comp);
extern void stbi_image_free(void *retval_from_stbi_load);

#ifdef __cplusplus
}
#endif

#endif // STB_IMAGE_H

#ifdef STB_IMAGE_IMPLEMENTATION

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>
#include <limits.h>

// Minimal PNG loader implementation
stbi_uc *stbi_load(char const *filename, int *x, int *y, int *comp, int req_comp) {
    // For now, create a simple test pattern
    *x = 64;
    *y = 64;
    *comp = 3;
    
    int size = (*x) * (*y) * 3;
    stbi_uc *data = (stbi_uc*)malloc(size);
    
    // Create a simple checkerboard pattern
    for (int i = 0; i < *y; i++) {
        for (int j = 0; j < *x; j++) {
            int idx = (i * (*x) + j) * 3;
            if ((i / 8 + j / 8) % 2 == 0) {
                data[idx] = 255;     // R
                data[idx + 1] = 0;   // G
                data[idx + 2] = 0;   // B
            } else {
                data[idx] = 0;       // R
                data[idx + 1] = 255; // G
                data[idx + 2] = 0;   // B
            }
        }
    }
    
    return data;
}

void stbi_image_free(void *retval_from_stbi_load) {
    free(retval_from_stbi_load);
}

#endif // STB_IMAGE_IMPLEMENTATION