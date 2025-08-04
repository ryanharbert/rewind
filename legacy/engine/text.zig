const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("stb_truetype.h");
});

pub const Font = struct {
    font_info: c.stbtt_fontinfo,
    font_data: []u8,
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator, font_path: []const u8) !Font {
        // Load font file
        const file = std.fs.cwd().openFile(font_path, .{}) catch |err| {
            std.debug.print("Failed to open font file: {s}, error: {}\n", .{font_path, err});
            return error.FontLoadFailed;
        };
        defer file.close();
        
        const file_size = try file.getEndPos();
        const font_data = try allocator.alloc(u8, file_size);
        _ = try file.readAll(font_data);
        
        var font = Font{
            .font_info = std.mem.zeroes(c.stbtt_fontinfo),
            .font_data = font_data,
            .allocator = allocator,
        };
        
        // Initialize font
        const result = c.stbtt_InitFont(&font.font_info, @ptrCast(font_data.ptr), 0);
        std.debug.print("Font loaded successfully: {s}\n", .{font_path});
        if (result == 0) {
            allocator.free(font_data);
            return error.FontInitFailed;
        }
        
        return font;
    }
    
    pub fn deinit(self: *Font) void {
        self.allocator.free(self.font_data);
    }
    
    pub fn getScale(self: *const Font, pixel_height: f32) f32 {
        return c.stbtt_ScaleForPixelHeight(&self.font_info, pixel_height);
    }
    
    pub fn getCodepointBitmap(self: *const Font, scale: f32, codepoint: u32, width: *i32, height: *i32, xoff: *i32, yoff: *i32) ?*u8 {
        var c_width: c_int = undefined;
        var c_height: c_int = undefined;
        var c_xoff: c_int = undefined;
        var c_yoff: c_int = undefined;
        
        const bitmap = c.stbtt_GetCodepointBitmap(&self.font_info, scale, scale, @intCast(codepoint), &c_width, &c_height, &c_xoff, &c_yoff);
        
        width.* = c_width;
        height.* = c_height;
        xoff.* = c_xoff;
        yoff.* = c_yoff;
        
        return @ptrCast(bitmap);
    }
    
    pub fn getCodepointMetrics(self: *const Font, codepoint: u32, advance_width: *i32, left_side_bearing: *i32) void {
        var c_advance: c_int = undefined;
        var c_bearing: c_int = undefined;
        c.stbtt_GetCodepointHMetrics(&self.font_info, @intCast(codepoint), &c_advance, &c_bearing);
        advance_width.* = c_advance;
        left_side_bearing.* = c_bearing;
    }
    
    pub fn getFontMetrics(self: *const Font, ascent: *i32, descent: *i32, line_gap: *i32) void {
        var c_ascent: c_int = undefined;
        var c_descent: c_int = undefined;
        var c_line_gap: c_int = undefined;
        c.stbtt_GetFontVMetrics(&self.font_info, &c_ascent, &c_descent, &c_line_gap);
        ascent.* = c_ascent;
        descent.* = c_descent;
        line_gap.* = c_line_gap;
    }
    
    pub fn freeBitmap(bitmap: ?*anyopaque) void {
        c.stbtt_FreeBitmap(@ptrCast(bitmap), null);
    }
};

pub const Text = struct {
    texture_id: c_uint,
    width: f32,
    height: f32,
    x: f32,
    y: f32,
    text: []const u8,
    font_size: f32,
    color: [3]f32,
    
    pub fn init(allocator: std.mem.Allocator, font: *const Font, text: []const u8, x: f32, y: f32, font_size: f32) !Text {
        // Create texture for text
        var texture_id: c_uint = undefined;
        c.glGenTextures(1, &texture_id);
        c.glBindTexture(c.GL_TEXTURE_2D, texture_id);
        
        // Set texture parameters for crisp text rendering
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_CLAMP_TO_EDGE);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_CLAMP_TO_EDGE);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_NEAREST);
        c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_NEAREST);
        
        const scale = font.getScale(font_size);
        
        // Calculate text dimensions
        var text_width: f32 = 0.0;
        var max_height: f32 = 0.0;
        
        // Get font metrics
        var ascent: i32 = undefined;
        var descent: i32 = undefined;
        var line_gap: i32 = undefined;
        font.getFontMetrics(&ascent, &descent, &line_gap);
        
        const scaled_ascent = @as(f32, @floatFromInt(ascent)) * scale;
        const scaled_descent = @as(f32, @floatFromInt(descent)) * scale;
        max_height = scaled_ascent - scaled_descent;
        
        // std.debug.print("Font metrics: ascent={}, descent={}, scale={}, height={}\n", .{ascent, descent, scale, max_height});
        
        // Calculate total width
        for (text) |char| {
            var advance: i32 = undefined;
            var bearing: i32 = undefined;
            font.getCodepointMetrics(char, &advance, &bearing);
            text_width += @as(f32, @floatFromInt(advance)) * scale;
        }
        
        // Create a bitmap for the entire text
        const bitmap_width = @as(i32, @intFromFloat(@ceil(text_width)));
        const bitmap_height = @as(i32, @intFromFloat(@ceil(max_height)));
        
        if (bitmap_width <= 0 or bitmap_height <= 0) {
            return error.InvalidTextDimensions;
        }
        
        var bitmap = try allocator.alloc(u8, @intCast(bitmap_width * bitmap_height));
        defer allocator.free(bitmap);
        @memset(bitmap, 0);
        
        // Render each character to the bitmap
        var x_offset: f32 = 0.0;
        
        for (text) |char| {
            var char_width: i32 = undefined;
            var char_height: i32 = undefined;
            var xoff: i32 = undefined;
            var yoff: i32 = undefined;
            
            const char_bitmap = font.getCodepointBitmap(scale, char, &char_width, &char_height, &xoff, &yoff);
            // std.debug.print("Char '{}' ({}): {}x{}, offset ({}, {}), bitmap: {?*}\n", .{char, char, char_width, char_height, xoff, yoff, char_bitmap});
            
            if (char_bitmap != null and char_width > 0 and char_height > 0) {
                // Copy character bitmap to main bitmap
                const start_x = @as(i32, @intFromFloat(@round(x_offset))) + xoff;
                // Place text baseline at the bottom of the bitmap area, yoff is relative to baseline
                const baseline_y = bitmap_height - @as(i32, @intFromFloat(@abs(scaled_descent))) - 1;
                const start_y = baseline_y + yoff;
                
                var y_idx: i32 = 0;
                while (y_idx < char_height) : (y_idx += 1) {
                    const dst_y = start_y + y_idx;
                    if (dst_y >= 0 and dst_y < bitmap_height) {
                        var x_idx: i32 = 0;
                        while (x_idx < char_width) : (x_idx += 1) {
                            const dst_x = start_x + x_idx;
                            if (dst_x >= 0 and dst_x < bitmap_width) {
                                const src_idx = @as(usize, @intCast(y_idx * char_width + x_idx));
                                const dst_idx = @as(usize, @intCast(dst_y * bitmap_width + dst_x));
                                const char_data = @as([*]u8, @ptrCast(char_bitmap.?))[src_idx];
                                bitmap[dst_idx] = @max(bitmap[dst_idx], char_data);
                            }
                        }
                    }
                }
                
                Font.freeBitmap(char_bitmap);
            }
            
            // Advance x position
            var advance: i32 = undefined;
            var bearing: i32 = undefined;
            font.getCodepointMetrics(char, &advance, &bearing);
            x_offset += @as(f32, @floatFromInt(advance)) * scale;
        }
        
        // Debug character bitmap generation
        var non_zero_pixels: u32 = 0;
        for (bitmap) |pixel| {
            if (pixel > 0) non_zero_pixels += 1;
        }
        // std.debug.print("Bitmap {}x{}, non-zero pixels: {}/{}\n", .{bitmap_width, bitmap_height, non_zero_pixels, bitmap.len});
        
        // Upload bitmap to OpenGL texture
        c.glPixelStorei(c.GL_UNPACK_ALIGNMENT, 1); // Important for single-channel textures
        c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RED, bitmap_width, bitmap_height, 0, c.GL_RED, c.GL_UNSIGNED_BYTE, bitmap.ptr);
        
        // std.debug.print("Text created: '{s}' at ({}, {}) size {}x{}\n", .{text, x, y, text_width, max_height});
        
        return Text{
            .texture_id = texture_id,
            .width = text_width,
            .height = max_height,
            .x = x,
            .y = y,
            .text = text,
            .font_size = font_size,
            .color = .{ 1.0, 1.0, 1.0 }, // Default white color
        };
    }
    
    pub fn deinit(self: *const Text) void {
        c.glDeleteTextures(1, &self.texture_id);
    }
    
    pub fn setPosition(self: *Text, x: f32, y: f32) void {
        self.x = x;
        self.y = y;
    }
    
    pub fn setColor(self: *Text, r: f32, g: f32, b: f32) void {
        self.color = .{ r, g, b };
    }
    
    pub fn bind(self: *const Text) void {
        c.glBindTexture(c.GL_TEXTURE_2D, self.texture_id);
    }
};