const std = @import("std");
const World = @import("world.zig").World;
const EntityID = @import("world.zig").EntityID;
const components = @import("../components/mod.zig");

pub fn Query(comptime component_types: anytype) type {
    return struct {
        const Self = @This();
        
        world: *World,
        required_mask: u64,
        entities: std.ArrayList(EntityID),
        current_index: usize,
        
        pub fn init(world: *World) Self {
            // Calculate required component mask
            var required_mask: u64 = 0;
            inline for (component_types) |ComponentType| {
                required_mask |= components.componentBit(ComponentType);
            }
            
            var query = Self{
                .world = world,
                .required_mask = required_mask,
                .entities = std.ArrayList(EntityID).init(world.allocator),
                .current_index = 0,
            };
            
            // Find entities that match the query
            var entity_iter = world.component_masks.iterator();
            while (entity_iter.next()) |entry| {
                const entity = entry.key_ptr.*;
                const mask = entry.value_ptr.*;
                
                if ((mask & required_mask) == required_mask) {
                    query.entities.append(entity) catch {}; // TODO: Handle error properly
                }
            }
            
            return query;
        }
        
        pub fn deinit(self: *Self) void {
            self.entities.deinit();
        }
        
        pub fn next(self: *Self) ?EntityID {
            if (self.current_index >= self.entities.items.len) {
                return null;
            }
            
            const entity = self.entities.items[self.current_index];
            self.current_index += 1;
            return entity;
        }
        
        pub fn count(self: *Self) u32 {
            return @intCast(self.entities.items.len);
        }
    };
}