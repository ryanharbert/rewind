const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("stb_image.h");
});

pub const Texture = struct {
    id: c_uint,
    width: i32,
    height: i32,

    pub fn init(path: []const u8) !Texture {
        var texture_id: c_uint = undefined;
        c.glGenTextures(1, &texture_id);
        c.glBindTexture(c.GL_TEXTURE_2D, texture_id);

        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_REPEAT);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_REPEAT);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_LINEAR);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_LINEAR);

        var width: c_int = undefined;
        var height: c_int = undefined;
        var nr_channels: c_int = undefined;

        const data = c.stbi_load(path.ptr, &width, &height, &nr_channels, 0);
        if (data != null) {
            const format = if (nr_channels == 3) c.GL_RGB else c.GL_RGBA;
            c.glTexImage2D(c.GL_TEXTURE_2D, 0, @intCast(format), width, height, 0, @intCast(format), c.GL_UNSIGNED_BYTE, data);
            c.glGenerateMipmap(c.GL_TEXTURE_2D);
        } else {
            std.debug.print("Failed to load texture: {s}\n", .{path});
            return error.TextureLoadFailed;
        }

        c.stbi_image_free(data);

        return Texture{
            .id = texture_id,
            .width = width,
            .height = height,
        };
    }

    pub fn bind(self: *const Texture) void {
        c.glBindTexture(c.GL_TEXTURE_2D, self.id);
    }

    pub fn deinit(self: *const Texture) void {
        c.glDeleteTextures(1, &self.id);
    }

    pub fn createTestSprite() !Texture {
        var texture_id: c_uint = undefined;
        c.glGenTextures(1, &texture_id);
        c.glBindTexture(c.GL_TEXTURE_2D, texture_id);

        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_REPEAT);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_REPEAT);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_NEAREST);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_NEAREST);

        // Create a simple 32x32 checkerboard pattern
        const size = 32;
        var data: [size * size * 3]u8 = undefined;
        
        for (0..size) |y| {
            for (0..size) |x| {
                const index = (y * size + x) * 3;
                const checker = ((x / 8) + (y / 8)) % 2;
                const color: u8 = if (checker == 0) 255 else 64;
                data[index] = color;     // R
                data[index + 1] = color; // G  
                data[index + 2] = color; // B
            }
        }

        c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RGB, size, size, 0, c.GL_RGB, c.GL_UNSIGNED_BYTE, &data);
        c.glGenerateMipmap(c.GL_TEXTURE_2D);

        return Texture{
            .id = texture_id,
            .width = size,
            .height = size,
        };
    }
};