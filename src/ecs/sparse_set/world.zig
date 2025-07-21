const std = @import("std");
const components = @import("../components/mod.zig");

pub const EntityID = u32;

pub const World = struct {
    allocator: std.mem.Allocator,
    
    // Entity management
    next_entity_id: EntityID,
    entity_count: u32,
    
    // Component storage - dense arrays
    transforms: std.ArrayList(components.Transform),
    physics: std.ArrayList(components.Physics),
    sprites: std.ArrayList(components.Sprite),
    players: std.ArrayList(components.Player),
    enemies: std.ArrayList(components.Enemy),
    
    // Entity -> component index mappings (sparse sets)
    entity_to_transform: std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
    entity_to_physics: std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
    entity_to_sprite: std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
    entity_to_player: std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
    entity_to_enemy: std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
    
    // Component masks for fast queries
    component_masks: std.HashMap(EntityID, u64, std.hash_map.AutoContext(EntityID), 80),
    
    pub fn init(allocator: std.mem.Allocator) World {
        return World{
            .allocator = allocator,
            .next_entity_id = 1, // Start from 1 so 0 can be invalid
            .entity_count = 0,
            
            .transforms = std.ArrayList(components.Transform).init(allocator),
            .physics = std.ArrayList(components.Physics).init(allocator),
            .sprites = std.ArrayList(components.Sprite).init(allocator),
            .players = std.ArrayList(components.Player).init(allocator),
            .enemies = std.ArrayList(components.Enemy).init(allocator),
            
            .entity_to_transform = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            .entity_to_physics = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            .entity_to_sprite = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            .entity_to_player = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            .entity_to_enemy = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            
            .component_masks = std.HashMap(EntityID, u64, std.hash_map.AutoContext(EntityID), 80).init(allocator),
        };
    }
    
    pub fn deinit(self: *World) void {
        self.transforms.deinit();
        self.physics.deinit();
        self.sprites.deinit();
        self.players.deinit();
        self.enemies.deinit();
        
        self.entity_to_transform.deinit();
        self.entity_to_physics.deinit();
        self.entity_to_sprite.deinit();
        self.entity_to_player.deinit();
        self.entity_to_enemy.deinit();
        
        self.component_masks.deinit();
    }
    
    pub fn createEntity(self: *World) !EntityID {
        const entity_id = self.next_entity_id;
        self.next_entity_id += 1;
        self.entity_count += 1;
        
        // Initialize with empty component mask
        try self.component_masks.put(entity_id, 0);
        
        return entity_id;
    }
    
    pub fn destroyEntity(self: *World, entity: EntityID) void {
        if (!self.component_masks.contains(entity)) return;
        
        // Remove all components
        self.removeComponent(entity, components.Transform);
        self.removeComponent(entity, components.Physics);
        self.removeComponent(entity, components.Sprite);
        self.removeComponent(entity, components.Player);
        self.removeComponent(entity, components.Enemy);
        
        _ = self.component_masks.remove(entity);
        self.entity_count -= 1;
    }
    
    pub fn addComponent(self: *World, entity: EntityID, component: anytype) !void {
        const T = @TypeOf(component);
        
        if (!self.component_masks.contains(entity)) {
            return error.InvalidEntity;
        }
        
        switch (T) {
            components.Transform => {
                if (self.entity_to_transform.contains(entity)) return; // Already has component
                
                const index = @as(u32, @intCast(self.transforms.items.len));
                try self.transforms.append(component);
                try self.entity_to_transform.put(entity, index);
                
                // Update component mask
                const current_mask = self.component_masks.get(entity) orelse 0;
                try self.component_masks.put(entity, current_mask | components.componentBit(T));
            },
            components.Physics => {
                if (self.entity_to_physics.contains(entity)) return;
                
                const index = @as(u32, @intCast(self.physics.items.len));
                try self.physics.append(component);
                try self.entity_to_physics.put(entity, index);
                
                const current_mask = self.component_masks.get(entity) orelse 0;
                try self.component_masks.put(entity, current_mask | components.componentBit(T));
            },
            components.Sprite => {
                if (self.entity_to_sprite.contains(entity)) return;
                
                const index = @as(u32, @intCast(self.sprites.items.len));
                try self.sprites.append(component);
                try self.entity_to_sprite.put(entity, index);
                
                const current_mask = self.component_masks.get(entity) orelse 0;
                try self.component_masks.put(entity, current_mask | components.componentBit(T));
            },
            components.Player => {
                if (self.entity_to_player.contains(entity)) return;
                
                const index = @as(u32, @intCast(self.players.items.len));
                try self.players.append(component);
                try self.entity_to_player.put(entity, index);
                
                const current_mask = self.component_masks.get(entity) orelse 0;
                try self.component_masks.put(entity, current_mask | components.componentBit(T));
            },
            components.Enemy => {
                if (self.entity_to_enemy.contains(entity)) return;
                
                const index = @as(u32, @intCast(self.enemies.items.len));
                try self.enemies.append(component);
                try self.entity_to_enemy.put(entity, index);
                
                const current_mask = self.component_masks.get(entity) orelse 0;
                try self.component_masks.put(entity, current_mask | components.componentBit(T));
            },
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        }
    }
    
    pub fn removeComponent(self: *World, entity: EntityID, comptime T: type) void {
        if (!self.component_masks.contains(entity)) return;
        
        switch (T) {
            components.Transform => {
                if (self.entity_to_transform.remove(entity)) {
                    // TODO: Implement efficient removal (swap with last element)
                    const current_mask = self.component_masks.get(entity) orelse 0;
                    _ = self.component_masks.put(entity, current_mask & ~components.componentBit(T)) catch {};
                }
            },
            components.Physics => {
                if (self.entity_to_physics.remove(entity)) {
                    const current_mask = self.component_masks.get(entity) orelse 0;
                    _ = self.component_masks.put(entity, current_mask & ~components.componentBit(T)) catch {};
                }
            },
            components.Sprite => {
                if (self.entity_to_sprite.remove(entity)) {
                    const current_mask = self.component_masks.get(entity) orelse 0;
                    _ = self.component_masks.put(entity, current_mask & ~components.componentBit(T)) catch {};
                }
            },
            components.Player => {
                if (self.entity_to_player.remove(entity)) {
                    const current_mask = self.component_masks.get(entity) orelse 0;
                    _ = self.component_masks.put(entity, current_mask & ~components.componentBit(T)) catch {};
                }
            },
            components.Enemy => {
                if (self.entity_to_enemy.remove(entity)) {
                    const current_mask = self.component_masks.get(entity) orelse 0;
                    _ = self.component_masks.put(entity, current_mask & ~components.componentBit(T)) catch {};
                }
            },
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        }
    }
    
    pub fn hasComponent(self: *World, entity: EntityID, comptime T: type) bool {
        const mask = self.component_masks.get(entity) orelse 0;
        return (mask & components.componentBit(T)) != 0;
    }
    
    pub fn getComponent(self: *World, entity: EntityID, comptime T: type) ?*T {
        if (!self.hasComponent(entity, T)) return null;
        
        return switch (T) {
            components.Transform => {
                const index = self.entity_to_transform.get(entity) orelse return null;
                return &self.transforms.items[index];
            },
            components.Physics => {
                const index = self.entity_to_physics.get(entity) orelse return null;
                return &self.physics.items[index];
            },
            components.Sprite => {
                const index = self.entity_to_sprite.get(entity) orelse return null;
                return &self.sprites.items[index];
            },
            components.Player => {
                const index = self.entity_to_player.get(entity) orelse return null;
                return &self.players.items[index];
            },
            components.Enemy => {
                const index = self.entity_to_enemy.get(entity) orelse return null;
                return &self.enemies.items[index];
            },
            else => @compileError("Unknown component type: " ++ @typeName(T)),
        };
    }
    
    pub fn query(self: *World, comptime component_types: anytype) @import("query.zig").Query(component_types) {
        return @import("query.zig").Query(component_types).init(self);
    }
};

pub fn runCompatibilityTest(allocator: std.mem.Allocator) !void {
    std.debug.print("Testing Sparse Set ECS...\n", .{});
    
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
    
    std.debug.print("Sparse Set ECS compatibility test passed!\n", .{});
}