const std = @import("std");
const Transform = @import("transform.zig").Transform;
const AssetBundle = @import("asset_bundle.zig").AssetBundle;

pub const SpriteRenderer = struct {
    sprite_name: []const u8,
    visible: bool,
    
    pub fn init(sprite_name: []const u8) SpriteRenderer {
        return SpriteRenderer{
            .sprite_name = sprite_name,
            .visible = true,
        };
    }

    pub fn setSprite(self: *SpriteRenderer, sprite_name: []const u8) void {
        self.sprite_name = sprite_name;
    }

    pub fn setVisible(self: *SpriteRenderer, visible: bool) void {
        self.visible = visible;
    }
};