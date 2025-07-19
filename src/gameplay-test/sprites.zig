const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});
const Texture = @import("../engine/texture.zig").Texture;

pub fn createCheckerboard() !Texture {
    const size = 64;
    var data: [size * size * 3]u8 = undefined;

    for (0..size) |y| {
        for (0..size) |x| {
            const index = (y * size + x) * 3;
            const checker = ((x / 8) + (y / 8)) % 2;
            const color: u8 = if (checker == 0) 200 else 50;
            data[index] = color;     // R
            data[index + 1] = color; // G  
            data[index + 2] = color; // B
        }
    }

    var texture_id: c.GLuint = undefined;
    c.glGenTextures(1, &texture_id);
    c.glBindTexture(c.GL_TEXTURE_2D, texture_id);

    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_LINEAR);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_LINEAR);

    c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RGB, size, size, 0, c.GL_RGB, c.GL_UNSIGNED_BYTE, &data);
    c.glGenerateMipmap(c.GL_TEXTURE_2D);

    return Texture{
        .id = texture_id,
        .width = size,
        .height = size,
    };
}

pub fn createTriangle() !Texture {
    const size = 64;
    var data: [size * size * 3]u8 = undefined;

    for (0..size) |y| {
        for (0..size) |x| {
            const index = (y * size + x) * 3;
            
            // Triangle vertices (centered, pointing up)
            const cx = @as(f32, @floatFromInt(x)) - @as(f32, @floatFromInt(size)) / 2.0;
            const cy = @as(f32, @floatFromInt(y)) - @as(f32, @floatFromInt(size)) / 2.0;
            
            // Simple triangle test
            const in_triangle = (cy > -@as(f32, @floatFromInt(size)) / 3.0) and 
                              (cy < @as(f32, @floatFromInt(size)) / 3.0) and
                              (@abs(cx) < (@as(f32, @floatFromInt(size)) / 3.0 - @abs(cy) * 0.5));
            
            if (in_triangle) {
                data[index] = 255;     // R (white)
                data[index + 1] = 100; // G (yellowish)
                data[index + 2] = 100; // B
            } else {
                data[index] = 0;       // R (transparent-ish)
                data[index + 1] = 0;   // G
                data[index + 2] = 0;   // B
            }
        }
    }

    var texture_id: c.GLuint = undefined;
    c.glGenTextures(1, &texture_id);
    c.glBindTexture(c.GL_TEXTURE_2D, texture_id);

    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_LINEAR);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_LINEAR);

    c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RGB, size, size, 0, c.GL_RGB, c.GL_UNSIGNED_BYTE, &data);
    c.glGenerateMipmap(c.GL_TEXTURE_2D);

    return Texture{
        .id = texture_id,
        .width = size,
        .height = size,
    };
}