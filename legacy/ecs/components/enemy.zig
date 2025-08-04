pub const Enemy = struct {
    speed: f32 = 1.0, // World coordinate speed (slower than player)  
    target_entity: ?u32 = null, // Use u32 instead of ecs.EntityID to avoid circular dependency
};