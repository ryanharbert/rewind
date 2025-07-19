const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});

// Direct extern declarations for STB functions
extern fn stbi_load(filename: [*:0]const u8, x: *c_int, y: *c_int, comp: *c_int, req_comp: c_int) ?*u8;
extern fn stbi_image_free(retval_from_stbi_load: ?*anyopaque) void;

pub const Texture = struct {
    id: c_uint,
    width: i32,
    height: i32,

    pub fn init(path: []const u8) !Texture {
        std.debug.print("Attempting to load texture: {s}\n", .{path});
        
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

        // Create null-terminated string for C API
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const allocator = arena.allocator();
        const null_terminated_path = try std.fmt.allocPrintZ(allocator, "{s}", .{path});

        // Test if file exists first
        const file = std.fs.cwd().openFile(path, .{}) catch |err| {
            std.debug.print("File doesn't exist or can't be opened: {s}, error: {}\n", .{path, err});
            return error.TextureLoadFailed;
        };
        file.close();
        std.debug.print("File exists and can be opened: {s}\n", .{path});
        
        std.debug.print("About to call stbi_load with path: {s}\n", .{null_terminated_path});
        const data = stbi_load(null_terminated_path.ptr, &width, &height, &nr_channels, 0);
        if (data != null) {
            const pixels = data.?;
            std.debug.print("STB loaded: {}x{} with {} channels\n", .{width, height, nr_channels});
            std.debug.print("First few pixels: R={} G={} B={}\n", .{@as([*]u8, @ptrCast(pixels))[0], @as([*]u8, @ptrCast(pixels))[1], @as([*]u8, @ptrCast(pixels))[2]});
            const format = if (nr_channels == 3) c.GL_RGB else c.GL_RGBA;
            c.glTexImage2D(c.GL_TEXTURE_2D, 0, @intCast(format), width, height, 0, @intCast(format), c.GL_UNSIGNED_BYTE, pixels);
            c.glGenerateMipmap(c.GL_TEXTURE_2D);
        } else {
            std.debug.print("Failed to load texture: {s}\n", .{path});
            return error.TextureLoadFailed;
        }

        stbi_image_free(data);

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

};