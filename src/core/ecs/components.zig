const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Transform = struct {
    position: Vec3,
    rotation: Vec3,
    scale: Vec3,

    pub fn init() Transform {
        return Transform{
            .position = Vec3{ .x = 0, .y = 0, .z = 0 },
            .rotation = Vec3{ .x = 0, .y = 0, .z = 0 },
            .scale = Vec3{ .x = 1, .y = 1, .z = 1 },
        };
    }
};

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
        };
    }

    pub fn scale(self: Vec3, scalar: f32) Vec3 {
        return Vec3{
            .x = self.x * scalar,
            .y = self.y * scalar,
            .z = self.z * scalar,
        };
    }
};

pub const RigidBody = struct {
    velocity: Vec3,
    mass: f32,
    is_static: bool,

    pub fn init() RigidBody {
        return RigidBody{
            .velocity = Vec3{ .x = 0, .y = 0, .z = 0 },
            .mass = 1.0,
            .is_static = false,
        };
    }
};

pub const ComponentType = enum(u32) {
    Transform,
    RigidBody,
    // Add more component types as needed
};

pub const ComponentManager = struct {
    allocator: Allocator,
    transforms: std.AutoHashMap(u32, Transform),
    rigid_bodies: std.AutoHashMap(u32, RigidBody),

    pub fn init(allocator: Allocator) ComponentManager {
        return ComponentManager{
            .allocator = allocator,
            .transforms = std.AutoHashMap(u32, Transform).init(allocator),
            .rigid_bodies = std.AutoHashMap(u32, RigidBody).init(allocator),
        };
    }

    pub fn deinit(self: *ComponentManager) void {
        self.transforms.deinit();
        self.rigid_bodies.deinit();
    }

    pub fn addTransform(self: *ComponentManager, entity_id: u32) !void {
        try self.transforms.put(entity_id, Transform.init());
    }

    pub fn addRigidBody(self: *ComponentManager, entity_id: u32) !void {
        try self.rigid_bodies.put(entity_id, RigidBody.init());
    }

    pub fn getTransform(self: *ComponentManager, entity_id: u32) ?*Transform {
        return self.transforms.getPtr(entity_id);
    }

    pub fn getRigidBody(self: *ComponentManager, entity_id: u32) ?*RigidBody {
        return self.rigid_bodies.getPtr(entity_id);
    }

    pub fn removeTransform(self: *ComponentManager, entity_id: u32) void {
        _ = self.transforms.remove(entity_id);
    }

    pub fn removeRigidBody(self: *ComponentManager, entity_id: u32) void {
        _ = self.rigid_bodies.remove(entity_id);
    }
}; 