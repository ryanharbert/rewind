const std = @import("std");
const EntityID = @import("entity.zig").EntityID;

// Generic component manager that works with any set of component types
pub fn ComponentManager(comptime component_types: []const type) type {
    // Compile-time validation and setup
    comptime {
        if (component_types.len == 0) {
            @compileError("Must register at least one component type");
        }
        if (component_types.len > 64) {
            @compileError("Maximum 64 component types supported (for bitmask)");
        }
    }
    
    return struct {
        const Self = @This();
        
        // Generate component storage types at compile time
        const ComponentArrays = blk: {
            var fields: [component_types.len]std.builtin.Type.StructField = undefined;
            for (component_types, 0..) |ComponentType, i| {
                const field_name = std.fmt.comptimePrint("components_{d}", .{i});
                fields[i] = std.builtin.Type.StructField{
                    .name = field_name,
                    .type = std.ArrayList(ComponentType),
                    .default_value_ptr = null,
                    .is_comptime = false,
                    .alignment = @alignOf(std.ArrayList(ComponentType)),
                };
            }
            break :blk @Type(.{ .@"struct" = .{
                .layout = .auto,
                .fields = &fields,
                .decls = &.{},
                .is_tuple = false,
            }});
        };
        
        // Generate entity->index hashmaps at compile time
        const EntityMaps = blk: {
            var fields: [component_types.len]std.builtin.Type.StructField = undefined;
            for (component_types, 0..) |_, i| {
                const field_name = std.fmt.comptimePrint("entity_map_{d}", .{i});
                fields[i] = std.builtin.Type.StructField{
                    .name = field_name,
                    .type = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80),
                    .default_value_ptr = null,
                    .is_comptime = false,
                    .alignment = @alignOf(std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80)),
                };
            }
            break :blk @Type(.{ .@"struct" = .{
                .layout = .auto,
                .fields = &fields,
                .decls = &.{},
                .is_tuple = false,
            }});
        };
        
        allocator: std.mem.Allocator,
        component_arrays: ComponentArrays,
        entity_maps: EntityMaps,
        component_masks: std.HashMap(EntityID, u64, std.hash_map.AutoContext(EntityID), 80),
        
        pub fn init(allocator: std.mem.Allocator) Self {
            var self = Self{
                .allocator = allocator,
                .component_arrays = undefined,
                .entity_maps = undefined,
                .component_masks = std.HashMap(EntityID, u64, std.hash_map.AutoContext(EntityID), 80).init(allocator),
            };
            
            // Initialize component arrays
            inline for (0..component_types.len) |i| {
                const field_name = comptime std.fmt.comptimePrint("components_{d}", .{i});
                @field(self.component_arrays, field_name) = std.ArrayList(component_types[i]).init(allocator);
            }
            
            // Initialize entity maps
            inline for (0..component_types.len) |i| {
                const field_name = comptime std.fmt.comptimePrint("entity_map_{d}", .{i});
                @field(self.entity_maps, field_name) = std.HashMap(EntityID, u32, std.hash_map.AutoContext(EntityID), 80).init(allocator);
            }
            
            return self;
        }
        
        pub fn deinit(self: *Self) void {
            // Deinitialize component arrays
            inline for (0..component_types.len) |i| {
                const field_name = comptime std.fmt.comptimePrint("components_{d}", .{i});
                @field(self.component_arrays, field_name).deinit();
            }
            
            // Deinitialize entity maps
            inline for (0..component_types.len) |i| {
                const field_name = comptime std.fmt.comptimePrint("entity_map_{d}", .{i});
                @field(self.entity_maps, field_name).deinit();
            }
            
            self.component_masks.deinit();
        }
        
        // Get component type index at compile time
        fn getComponentIndex(comptime T: type) comptime_int {
            inline for (component_types, 0..) |ComponentType, i| {
                if (T == ComponentType) return i;
            }
            @compileError("Component type '" ++ @typeName(T) ++ "' not registered. Register it in component_types array.");
        }
        
        // Get component bitmask at compile time
        fn getComponentMask(comptime T: type) u64 {
            return @as(u64, 1) << getComponentIndex(T);
        }
        
        pub fn addComponent(self: *Self, entity: EntityID, component: anytype) !void {
            const T = @TypeOf(component);
            const index = comptime getComponentIndex(T);
            
            // Get the appropriate storage arrays
            const components_field = comptime std.fmt.comptimePrint("components_{d}", .{index});
            const map_field = comptime std.fmt.comptimePrint("entity_map_{d}", .{index});
            
            var components = &@field(self.component_arrays, components_field);
            var entity_map = &@field(self.entity_maps, map_field);
            
            // Check if entity already has this component
            if (entity_map.contains(entity)) {
                return; // Already has component, skip
            }
            
            // Add component to dense array
            const component_index = @as(u32, @intCast(components.items.len));
            try components.append(component);
            try entity_map.put(entity, component_index);
            
            // Update component mask
            const current_mask = self.component_masks.get(entity) orelse 0;
            const component_mask = comptime getComponentMask(T);
            try self.component_masks.put(entity, current_mask | component_mask);
        }
        
        pub fn hasComponent(self: *Self, entity: EntityID, comptime T: type) bool {
            const mask = self.component_masks.get(entity) orelse 0;
            const component_mask = comptime getComponentMask(T);
            return (mask & component_mask) != 0;
        }
        
        pub fn getComponent(self: *Self, entity: EntityID, comptime T: type) ?*T {
            const index = comptime getComponentIndex(T);
            
            const components_field = comptime std.fmt.comptimePrint("components_{d}", .{index});
            const map_field = comptime std.fmt.comptimePrint("entity_map_{d}", .{index});
            
            const components = &@field(self.component_arrays, components_field);
            const entity_map = &@field(self.entity_maps, map_field);
            
            const component_index = entity_map.get(entity) orelse return null;
            return &components.items[component_index];
        }
        
        pub fn removeComponent(self: *Self, entity: EntityID, comptime T: type) void {
            const index = comptime getComponentIndex(T);
            
            const map_field = comptime std.fmt.comptimePrint("entity_map_{d}", .{index});
            var entity_map = &@field(self.entity_maps, map_field);
            
            if (entity_map.remove(entity)) {
                // Update component mask
                const current_mask = self.component_masks.get(entity) orelse 0;
                const component_mask = comptime getComponentMask(T);
                _ = self.component_masks.put(entity, current_mask & ~component_mask) catch {};
            }
        }
        
        pub fn createEntity(self: *Self) !EntityID {
            // This should be called through World, but provide a basic implementation
            const entity_id = @as(EntityID, @intCast(self.component_masks.count() + 1));
            try self.component_masks.put(entity_id, 0);
            return entity_id;
        }
        
        // Query support - returns entities that have all the specified component types
        pub fn queryEntities(self: *Self, comptime query_types: []const type, entities: *std.ArrayList(EntityID)) !void {
            entities.clearRetainingCapacity();
            
            // Calculate required mask
            var required_mask: u64 = 0;
            inline for (query_types) |T| {
                required_mask |= comptime getComponentMask(T);
            }
            
            // Find matching entities
            var mask_iter = self.component_masks.iterator();
            while (mask_iter.next()) |entry| {
                const entity = entry.key_ptr.*;
                const mask = entry.value_ptr.*;
                
                if ((mask & required_mask) == required_mask) {
                    try entities.append(entity);
                }
            }
        }
    };
}