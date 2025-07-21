const std = @import("std");
const World = @import("world.zig").World;
const EntityID = @import("world.zig").EntityID;
const components = @import("../components/mod.zig");

pub fn Query(comptime component_types: anytype) type {
    return struct {
        const Self = @This();
        
        world: *World,
        result_entities: std.bit_set.IntegerBitSet(4096),
        iterator: std.bit_set.IntegerBitSet(4096).Iterator(.{}),
        
        pub fn init(world: *World) Self {
            var result_entities = std.bit_set.IntegerBitSet(4096).initEmpty();
            
            // Perform SIMD bitwise AND to find entities with all required components
            result_entities = world.active_entities; // Start with all active entities
            
            inline for (component_types) |ComponentType| {
                const component_bitset = switch (ComponentType) {
                    components.Transform => world.transform_entities,
                    components.Physics => world.physics_entities,
                    components.Sprite => world.sprite_entities,
                    else => @compileError("Unknown component type: " ++ @typeName(ComponentType)),
                };
                
                // SIMD bitwise AND operation
                result_entities = result_entities.intersectWith(component_bitset);
            }
            
            return Self{
                .world = world,
                .result_entities = result_entities,
                .iterator = result_entities.iterator(.{}),
            };
        }
        
        pub fn next(self: *Self) ?EntityID {
            // Use the built-in efficient iterator (already optimized with @ctz internally)
            if (self.iterator.next()) |entity| {
                return @intCast(entity);
            }
            return null;
        }
        
        pub fn count(self: *Self) u32 {
            return @intCast(self.result_entities.count());
        }
    };
}