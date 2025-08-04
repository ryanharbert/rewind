const std = @import("std");
const c = @cImport({
    @cInclude("stb_image.h");
});

pub const Image = struct {
    width: u32,
    height: u32,
    channels: u32,
    data: []u8,
    allocator: std.mem.Allocator,
    
    pub fn deinit(self: *Image) void {
        // STB manages its own memory, so we use stbi_image_free
        c.stbi_image_free(self.data.ptr);
    }
};

pub const AssetLoader = struct {
    base_path: []const u8,
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator, base_path: []const u8) AssetLoader {
        return AssetLoader{
            .base_path = base_path,
            .allocator = allocator,
        };
    }
    
    pub fn setAssetPath(self: *AssetLoader, new_path: []const u8) void {
        self.base_path = new_path;
    }
    
    pub fn loadImage(self: *AssetLoader, relative_path: []const u8) !Image {
        // Build full path
        const full_path = try std.fmt.allocPrint(self.allocator, "{s}/{s}", .{ self.base_path, relative_path });
        defer self.allocator.free(full_path);
        
        // Convert to null-terminated string for C
        const c_path = try std.fmt.allocPrintZ(self.allocator, "{s}", .{full_path});
        defer self.allocator.free(c_path);
        
        // Load image using stb_image
        var width: c_int = 0;
        var height: c_int = 0;
        var channels: c_int = 0;
        
        const data = c.stbi_load(c_path.ptr, &width, &height, &channels, 4); // Force RGBA
        if (data == null) {
            const error_msg = c.stbi_failure_reason();
            std.log.err("Failed to load image '{s}': {s}", .{ full_path, error_msg });
            return error.ImageLoadFailed;
        }
        
        const data_size = @as(usize, @intCast(width * height * 4)); // 4 channels (RGBA)
        
        return Image{
            .width = @intCast(width),
            .height = @intCast(height),
            .channels = 4, // We forced RGBA
            .data = data[0..data_size],
            .allocator = self.allocator,
        };
    }
};