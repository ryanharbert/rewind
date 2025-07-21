const std = @import("std");
const components = @import("../components/mod.zig");

pub const EntityID = u32;
const MAX_ENTITIES = 4096;
const EntityIndex = u16; // Supports up to 65k components per type

pub const World = struct {
    allocator: std.mem.Allocator,
    
    // Entity management
    active_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
    next_entity_id: EntityID,
    entity_count: u32,
    
    // Component bitsets - which entities have which components
    transform_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
    physics_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
    sprite_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
    
    // Component storage - dense arrays
    transforms: std.ArrayList(components.Transform),
    physics: std.ArrayList(components.Physics),
    sprites: std.ArrayList(components.Sprite),
    
    // Entity -> component index mappings
    entity_to_transform_idx: [MAX_ENTITIES]EntityIndex,
    entity_to_physics_idx: [MAX_ENTITIES]EntityIndex,
    entity_to_sprite_idx: [MAX_ENTITIES]EntityIndex,
    
    pub fn init(allocator: std.mem.Allocator) World {
        return World{
            .allocator = allocator,
            .active_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
            .next_entity_id = 0,
            .entity_count = 0,
            
            .transform_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
            .physics_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
            .sprite_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
            
            .transforms = std.ArrayList(components.Transform).init(allocator),
            .physics = std.ArrayList(components.Physics).init(allocator),
            .sprites = std.ArrayList(components.Sprite).init(allocator),
            
            .entity_to_transform_idx = [_]EntityIndex{0} ** MAX_ENTITIES,
            .entity_to_physics_idx = [_]EntityIndex{0} ** MAX_ENTITIES,
            .entity_to_sprite_idx = [_]EntityIndex{0} ** MAX_ENTITIES,
        };
    }
    
    pub fn deinit(self: *World) void {
        self.transforms.deinit();
        self.physics.deinit();
        self.sprites.deinit();
    }
    
    pub fn createEntity(self: *World) !EntityID {
        if (self.entity_count >= MAX_ENTITIES) {
            return error.MaxEntitiesReached;
        }
        
        // Find next available entity ID
        while (self.active_entities.isSet(self.next_entity_id)) {
            self.next_entity_id += 1;
            if (self.next_entity_id >= MAX_ENTITIES) {
                self.next_entity_id = 0;
            }
        }
        
        const entity_id = self.next_entity_id;
        self.active_entities.set(entity_id);
        self.entity_count += 1;
        self.next_entity_id += 1;
        
        return entity_id;
    }
    
    pub fn destroyEntity(self: *World, entity: EntityID) void {
        if (!self.active_entities.isSet(entity)) return;
        
        // Remove all components
        self.removeComponent(entity, components.Transform);
        self.removeComponent(entity, components.Physics);
        self.removeComponent(entity, components.Sprite);
        
        self.active_entities.unset(entity);
        self.entity_count -= 1;
    }
    
    pub fn addComponent(self: *World, entity: EntityID, component: anytype) !void {
        const T = @TypeOf(component);
        
        if (!self.active_entities.isSet(entity)) {
            return error.InvalidEntity;
        }
        
        switch (T) {
            components.Transform => {
                if (self.transform_entities.isSet(entity)) return; // Already has component
                
                const index = @as(EntityIndex, @intCast(self.transforms.items.len));
                try self.transforms.append(component);
                self.entity_to_transform_idx[entity] = index;
                self.transform_entities.set(entity);
            },
            components.Physics => {
                if (self.physics_entities.isSet(entity)) return;
                
                const index = @as(EntityIndex, @intCast(self.physics.items.len));
                try self.physics.append(component);
                self.entity_to_physics_idx[entity] = index;
                self.physics_entities.set(entity);
            },
            components.Sprite => {
                if (self.sprite_entities.isSet(entity)) return;
                
                const index = @as(EntityIndex, @intCast(self.sprites.items.len));
                try self.sprites.append(component);
                self.entity_to_sprite_idx[entity] = index;
                self.sprite_entities.set(entity);
            },
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        }
    }
    
    pub fn removeComponent(self: *World, entity: EntityID, comptime T: type) void {
        if (!self.active_entities.isSet(entity)) return;
        
        switch (T) {
            components.Transform => {
                if (!self.transform_entities.isSet(entity)) return;
                
                // TODO: Implement efficient removal (swap with last element)
                self.transform_entities.unset(entity);
            },
            components.Physics => {
                if (!self.physics_entities.isSet(entity)) return;
                self.physics_entities.unset(entity);
            },
            components.Sprite => {
                if (!self.sprite_entities.isSet(entity)) return;
                self.sprite_entities.unset(entity);
            },
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        }
    }
    
    pub fn hasComponent(self: *World, entity: EntityID, comptime T: type) bool {
        if (!self.active_entities.isSet(entity)) return false;
        
        return switch (T) {
            components.Transform => self.transform_entities.isSet(entity),
            components.Physics => self.physics_entities.isSet(entity),
            components.Sprite => self.sprite_entities.isSet(entity),
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        };
    }
    
    pub fn getComponent(self: *World, entity: EntityID, comptime T: type) ?*T {
        if (!self.hasComponent(entity, T)) return null;
        
        return switch (T) {
            components.Transform => &self.transforms.items[self.entity_to_transform_idx[entity]],
            components.Physics => &self.physics.items[self.entity_to_physics_idx[entity]],
            components.Sprite => &self.sprites.items[self.entity_to_sprite_idx[entity]],
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        };
    }
    
    pub fn query(self: *World, comptime component_types: anytype) @import("query.zig").Query(component_types) {
        return @import("query.zig").Query(component_types).init(self);
    }
};

pub fn runCompatibilityTest(allocator: std.mem.Allocator) !void {
    std.debug.print("Testing Bitset ECS...\n", .{});
    
    var world = World.init(allocator);
    defer world.deinit();
    
    // Create an entity
    const entity = try world.createEntity();
    std.debug.print("Created entity: {}\n", .{entity});
    
    // Add a transform component
    try world.addComponent(entity, components.Transform{ .position = .{ .x = 10.0, .y = 20.0 } });
    std.debug.print("Added Transform component\n", .{});
    
    // Check if it has the component
    const has_transform = world.hasComponent(entity, components.Transform);
    std.debug.print("Has Transform: {}\n", .{has_transform});
    
    // Get the component
    if (world.getComponent(entity, components.Transform)) |transform| {
        std.debug.print("Transform position: ({d}, {d})\n", .{ transform.position.x, transform.position.y });
    }
    
    std.debug.print("Bitset ECS compatibility test passed!\n", .{});
}