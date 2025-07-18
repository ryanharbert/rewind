const std = @import("std");
const Texture = @import("texture.zig").Texture;

pub const AssetBundle = struct {
    textures: std.StringHashMap(Texture),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) AssetBundle {
        return AssetBundle{
            .textures = std.StringHashMap(Texture).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn loadBundle(self: *AssetBundle, paths: []const []const u8) !void {
        for (paths) |path| {
            const texture = Texture.init(path) catch |err| {
                std.debug.print("Failed to load texture: {s}\n", .{path});
                return err;
            };
            
            // Use the filename as the key
            const filename = std.fs.path.basename(path);
            const owned_key = try self.allocator.dupe(u8, filename);
            try self.textures.put(owned_key, texture);
        }
    }

    pub fn getTexture(self: *const AssetBundle, name: []const u8) ?*const Texture {
        return self.textures.getPtr(name);
    }

    pub fn deinit(self: *AssetBundle) void {
        var iterator = self.textures.iterator();
        while (iterator.next()) |entry| {
            entry.value_ptr.deinit();
            self.allocator.free(entry.key_ptr.*);
        }
        self.textures.deinit();
    }
};