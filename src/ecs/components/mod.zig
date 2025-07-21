// Re-export all component types
pub const Transform = @import("transform.zig").Transform;
pub const Physics = @import("physics.zig").Physics;
pub const Sprite = @import("sprite.zig").Sprite;

// Component type information for ECS implementations
pub const ComponentTypes = enum {
    Transform,
    Physics,
    Sprite,
};

// Helper to get component bit for masks
pub fn componentBit(comptime T: type) u64 {
    return switch (T) {
        Transform => 1 << 0,
        Physics => 1 << 1,
        Sprite => 1 << 2,
        else => @compileError("Unknown component type: " ++ @typeName(T)),
    };
}