const std = @import("std");
const builtin = @import("builtin");

pub const EntityID = u32;
pub const INVALID_ENTITY: EntityID = std.math.maxInt(EntityID);

/// Entity count limits - constrained to power-of-2 for optimal bitset performance
pub const EntityLimit = enum(u16) {
    tiny = 64, // 1 u64 chunk - good for prototypes, simple games
    small = 256, // 4 u64 chunks - good for puzzle games, small arcade games
    medium = 512, // 8 u64 chunks - good for most indie games (default)
    large = 1024, // 16 u64 chunks - good for complex games with many objects
    huge = 2048, // 32 u64 chunks - good for large worlds, particle systems
    massive = 4096, // 64 u64 chunks - good for RTS games, massive simulations

    pub fn toInt(self: EntityLimit) u16 {
        return @intFromEnum(self);
    }
};

/// Generic bitset ECS - generates specialized ECS implementation at compile time
pub fn ECS(
    comptime config: struct {
        components: []const type, // Array of component types to register
        input: type, // Input type for frame context
        max_entities: EntityLimit = .medium, // Entity limit (defaults to 512)
    },
) type {
    const ComponentTypes = config.components;
    const InputType = config.input;
    const MAX_ENTITIES = config.max_entities.toInt();

    // Compile-time validation
    comptime {
        if (ComponentTypes.len == 0) {
            @compileError("Must register at least one component type");
        }
        if (ComponentTypes.len > 64) {
            @compileError("Maximum 64 component types supported (for bitmask)");
        }
    }

    return struct {
        const Self = @This();

        /// Generate component storage type for a specific component
        fn generateComponentStorage(comptime T: type) type {
            return struct {
                /// Dense array of components - same as sparse set
                dense: std.ArrayList(T),

                /// Bitset tracking which entities have this component - replaces HashMap
                entity_bitset: std.bit_set.IntegerBitSet(MAX_ENTITIES),

                /// Fixed array mapping entity -> dense index - replaces HashMap
                entity_to_index: [MAX_ENTITIES]u32,

                /// Reverse mapping for efficient removal - same concept as sparse set
                index_to_entity: std.ArrayList(EntityID),

                const StorageSelf = @This();

                pub fn init(allocator: std.mem.Allocator) StorageSelf {
                    return StorageSelf{
                        .dense = std.ArrayList(T).init(allocator),
                        .entity_bitset = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
                        .entity_to_index = [_]u32{0} ** MAX_ENTITIES,
                        .index_to_entity = std.ArrayList(EntityID).init(allocator),
                    };
                }

                pub fn deinit(self: *StorageSelf) void {
                    self.dense.deinit();
                    self.index_to_entity.deinit();
                }

                pub fn add(self: *StorageSelf, entity: EntityID, component: T) !void {
                    if (entity >= MAX_ENTITIES) {
                        std.log.err("Cannot add component to entity {}: exceeds max limit of {} entities. " ++
                            "Increase max_entities in ECS config (current: {s})", .{ entity, MAX_ENTITIES, @tagName(config.max_entities) });
                        return error.EntityLimitExceeded;
                    }
                    if (self.entity_bitset.isSet(entity)) return; // Already exists

                    const index = @as(u32, @intCast(self.dense.items.len));
                    try self.dense.append(component);
                    try self.index_to_entity.append(entity);
                    self.entity_to_index[entity] = index;
                    self.entity_bitset.set(entity);
                }

                pub fn get(self: *StorageSelf, entity: EntityID) ?*T {
                    if (entity >= MAX_ENTITIES) return null;
                    if (!self.entity_bitset.isSet(entity)) return null;

                    const index = self.entity_to_index[entity];
                    return &self.dense.items[index];
                }

                pub fn has(self: *StorageSelf, entity: EntityID) bool {
                    if (entity >= MAX_ENTITIES) return false;
                    return self.entity_bitset.isSet(entity);
                }

                pub fn remove(self: *StorageSelf, entity: EntityID) bool {
                    if (entity >= MAX_ENTITIES) return false;
                    if (!self.entity_bitset.isSet(entity)) return false;

                    const index = self.entity_to_index[entity];
                    const last_index = self.dense.items.len - 1;

                    // Swap with last element for O(1) removal
                    if (index != last_index) {
                        const last_entity = self.index_to_entity.items[last_index];
                        self.dense.items[index] = self.dense.items[last_index];
                        self.index_to_entity.items[index] = last_entity;
                        self.entity_to_index[last_entity] = index;
                    }

                    _ = self.dense.pop();
                    _ = self.index_to_entity.pop();
                    self.entity_bitset.unset(entity);

                    return true;
                }

                pub fn count(self: *const StorageSelf) u32 {
                    return @intCast(self.dense.items.len);
                }
            };
        }

        // Generate storage types at compile time - same as sparse set approach
        const StorageTypes = blk: {
            var storage_types: [ComponentTypes.len]type = undefined;
            for (ComponentTypes, 0..) |T, i| {
                storage_types[i] = generateComponentStorage(T);
            }
            break :blk storage_types;
        };

        fn getComponentIndex(comptime T: type) comptime_int {
            inline for (ComponentTypes, 0..) |ComponentType, i| {
                if (ComponentType == T) return i;
            }
            @compileError("Component type '" ++ @typeName(T) ++ "' not registered. " ++
                "Add it to the components array in ECS config: " ++
                "components = &.{ Position, Velocity, " ++ @typeName(T) ++ " }");
        }

        /// FrameState contains all ECS data - same structure as sparse set version
        pub const FrameState = struct {
            /// Component storages - one per component type
            storages: std.meta.Tuple(&StorageTypes),

            /// Entity management - bitset instead of counter
            active_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
            next_entity: EntityID,
            entity_count: u32,
            allocator: std.mem.Allocator,

            const FrameStateSelf = @This();

            // ===== ENTITY MANAGEMENT =====

            pub fn createEntity(self: *FrameStateSelf) !EntityID {
                // Find next available entity ID
                var entity = self.next_entity;
                while (entity < MAX_ENTITIES and self.active_entities.isSet(entity)) {
                    entity += 1;
                }

                if (entity >= MAX_ENTITIES) {
                    std.log.err("Cannot create entity: would exceed max limit of {} entities. " ++
                        "Increase max_entities in ECS config (current: {s})", .{ MAX_ENTITIES, @tagName(config.max_entities) });
                    return error.EntityLimitExceeded;
                }

                self.active_entities.set(entity);
                self.entity_count += 1;
                self.next_entity = entity + 1;

                return entity;
            }

            pub fn destroyEntity(self: *FrameStateSelf, entity: EntityID) void {
                if (entity >= MAX_ENTITIES) return;
                if (!self.active_entities.isSet(entity)) return;

                // Remove from all component storages
                inline for (0..ComponentTypes.len) |i| {
                    _ = self.storages[i].remove(entity);
                }

                self.active_entities.unset(entity);
                self.entity_count -= 1;
            }

            // ===== COMPONENT API - Same interface as sparse set =====

            pub fn addComponent(self: *FrameStateSelf, entity: EntityID, component: anytype) !void {
                const T = @TypeOf(component);
                
                // Debug-only bounds check - zero overhead in release builds
                if (builtin.mode == .Debug) {
                    if (entity >= MAX_ENTITIES) {
                        std.log.err("Cannot add component to entity {}: entity ID out of bounds (max: {})", .{ entity, MAX_ENTITIES });
                        return error.InvalidEntity;
                    }
                }
                
                if (!self.active_entities.isSet(entity)) {
                    std.log.err("Cannot add component to entity {}: entity does not exist. " ++
                        "Create the entity first with createEntity()", .{entity});
                    return error.InvalidEntity;
                }

                const storage_index = comptime getComponentIndex(T);
                try self.storages[storage_index].add(entity, component);
            }

            pub fn getComponent(self: *FrameStateSelf, entity: EntityID, comptime T: type) ?*T {
                if (entity == INVALID_ENTITY) return null;
                const storage_index = comptime getComponentIndex(T);
                return self.storages[storage_index].get(entity);
            }

            pub fn hasComponent(self: *FrameStateSelf, entity: EntityID, comptime T: type) bool {
                if (entity == INVALID_ENTITY) return false;
                const storage_index = comptime getComponentIndex(T);
                return self.storages[storage_index].has(entity);
            }

            pub fn removeComponent(self: *FrameStateSelf, entity: EntityID, comptime T: type) bool {
                const storage_index = comptime getComponentIndex(T);
                return self.storages[storage_index].remove(entity);
            }

            // ===== QUERY API - Much simpler than sparse set! =====

            pub fn query(self: *FrameStateSelf, comptime QueryTypes: []const type) !buildQuery(QueryTypes, FrameStateSelf) {
                return buildQuery(QueryTypes, FrameStateSelf).init(self);
            }

            // ===== UTILITY FUNCTIONS =====

            pub fn getEntityCount(self: *const FrameStateSelf) u32 {
                return self.entity_count;
            }


            // ===== ROLLBACK SUPPORT =====

            pub fn copyFrom(self: *FrameStateSelf, other: *const FrameStateSelf) !void {
                self.active_entities = other.active_entities;
                self.next_entity = other.next_entity;
                self.entity_count = other.entity_count;

                // Copy all component storages
                inline for (0..ComponentTypes.len) |i| {
                    const other_storage = &other.storages[i];
                    var storage = &self.storages[i];

                    // Copy bitset
                    storage.entity_bitset = other_storage.entity_bitset;

                    // Copy entity mappings
                    storage.entity_to_index = other_storage.entity_to_index;

                    // Copy dense arrays
                    storage.dense.clearRetainingCapacity();
                    try storage.dense.appendSlice(other_storage.dense.items);

                    storage.index_to_entity.clearRetainingCapacity();
                    try storage.index_to_entity.appendSlice(other_storage.index_to_entity.items);
                }
            }
        };

        /// Query builder - creates optimized query using bitset intersection
        fn buildQuery(comptime QueryTypes: []const type, comptime FrameStateType: type) type {
            return struct {
                const QuerySelf = @This();

                result_entities: std.bit_set.IntegerBitSet(MAX_ENTITIES),
                iterator: std.bit_set.IntegerBitSet(MAX_ENTITIES).Iterator(.{}),
                frame_state: *FrameStateType,

                pub fn init(frame_state: *FrameStateType) QuerySelf {
                    // Start with active entities
                    var result_entities = frame_state.active_entities;

                    // Intersect with required component bitsets - SIMD fast!
                    inline for (QueryTypes) |T| {
                        const storage_index = comptime getComponentIndex(T);
                        const component_bitset = frame_state.storages[storage_index].entity_bitset;
                        result_entities = result_entities.intersectWith(component_bitset);
                    }

                    return QuerySelf{
                        .result_entities = result_entities,
                        .iterator = result_entities.iterator(.{}),
                        .frame_state = frame_state,
                    };
                }

                pub fn next(self: *QuerySelf) ?createQueryResult(FrameStateType) {
                    if (self.iterator.next()) |entity_index| {
                        const entity = @as(EntityID, @intCast(entity_index));
                        return createQueryResult(FrameStateType){
                            .frame_state = self.frame_state,
                            .entity = entity,
                        };
                    }
                    return null;
                }

                pub fn count(self: *QuerySelf) u32 {
                    return @intCast(self.result_entities.count());
                }

                pub fn reset(self: *QuerySelf) void {
                    self.iterator = self.result_entities.iterator(.{});
                }

                // Zero-cost iterator for for-loops
                pub const Iterator = struct {
                    query: *QuerySelf,

                    pub fn next(self: *Iterator) ?createQueryResult(FrameStateType) {
                        return self.query.next();
                    }
                };

                pub fn createIterator(self: *QuerySelf) Iterator {
                    return .{ .query = self };
                }

                // No deinit needed - everything is stack allocated!
            };
        }

        /// Generate query result type for component access
        fn createQueryResult(comptime FrameStateType: type) type {
            return struct {
                frame_state: *FrameStateType,
                entity: EntityID,

                pub fn get(self: @This(), comptime T: type) *T {
                    return self.frame_state.getComponent(self.entity, T).?;
                }
            };
        }

        /// Frame contains FrameState + context - identical to sparse set version
        pub const Frame = struct {
            state: FrameState,
            input: InputType,
            deltaTime: f32,
            time: f64,
            frame_number: u64,

            const FrameSelf = @This();

            // All methods delegate to state - same as sparse set
            pub fn createEntity(self: *FrameSelf) !EntityID {
                return self.state.createEntity();
            }

            pub fn destroyEntity(self: *FrameSelf, entity: EntityID) void {
                self.state.destroyEntity(entity);
            }

            pub fn addComponent(self: *FrameSelf, entity: EntityID, component: anytype) !void {
                return self.state.addComponent(entity, component);
            }

            pub fn getComponent(self: *FrameSelf, entity: EntityID, comptime T: type) ?*T {
                return self.state.getComponent(entity, T);
            }

            pub fn hasComponent(self: *FrameSelf, entity: EntityID, comptime T: type) bool {
                return self.state.hasComponent(entity, T);
            }

            pub fn removeComponent(self: *FrameSelf, entity: EntityID, comptime T: type) bool {
                return self.state.removeComponent(entity, T);
            }

            pub fn query(self: *FrameSelf, comptime QueryTypes: []const type) !buildQuery(QueryTypes, FrameState) {
                return self.state.query(QueryTypes);
            }

            pub fn getEntityCount(self: *const FrameSelf) u32 {
                return self.state.getEntityCount();
            }
        };

        // ECS container - same as sparse set
        current_frame: Frame,

        pub fn init(allocator: std.mem.Allocator) !Self {
            var frame_state = FrameState{
                .storages = undefined,
                .active_entities = std.bit_set.IntegerBitSet(MAX_ENTITIES).initEmpty(),
                .next_entity = 0,
                .entity_count = 0,
                .allocator = allocator,
            };

            // Initialize all component storages
            inline for (0..ComponentTypes.len) |i| {
                frame_state.storages[i] = StorageTypes[i].init(allocator);
            }

            return Self{
                .current_frame = Frame{
                    .state = frame_state,
                    .input = std.mem.zeroes(InputType),
                    .deltaTime = 0.0,
                    .time = 0.0,
                    .frame_number = 0,
                },
            };
        }

        pub fn deinit(self: *Self) void {
            inline for (0..ComponentTypes.len) |i| {
                self.current_frame.state.storages[i].deinit();
            }
        }

        pub fn getFrame(self: *Self) *Frame {
            return &self.current_frame;
        }

        pub fn update(self: *Self, input: InputType, deltaTime: f32, time: f64) void {
            self.current_frame.input = input;
            self.current_frame.deltaTime = deltaTime;
            self.current_frame.time = time;
            self.current_frame.frame_number += 1;
        }

        // Rollback support - same interface as sparse set
        pub fn saveFrame(self: *const Self, allocator: std.mem.Allocator) !Frame {
            var saved_frame = Frame{
                .state = FrameState{
                    .storages = undefined,
                    .active_entities = self.current_frame.state.active_entities,
                    .next_entity = self.current_frame.state.next_entity,
                    .entity_count = self.current_frame.state.entity_count,
                    .allocator = allocator,
                },
                .input = self.current_frame.input,
                .deltaTime = self.current_frame.deltaTime,
                .time = self.current_frame.time,
                .frame_number = self.current_frame.frame_number,
            };

            // Initialize storages for saved frame
            inline for (0..ComponentTypes.len) |i| {
                saved_frame.state.storages[i] = StorageTypes[i].init(allocator);
            }

            // Copy all data
            try saved_frame.state.copyFrom(&self.current_frame.state);

            return saved_frame;
        }

        pub fn restoreFrame(self: *Self, saved_frame: *const Frame) !void {
            try self.current_frame.state.copyFrom(&saved_frame.state);
            self.current_frame.input = saved_frame.input;
            self.current_frame.deltaTime = saved_frame.deltaTime;
            self.current_frame.time = saved_frame.time;
            self.current_frame.frame_number = saved_frame.frame_number;
        }

        pub fn freeSavedFrame(saved_frame: *Frame) void {
            inline for (0..ComponentTypes.len) |i| {
                saved_frame.state.storages[i].deinit();
            }
        }
    };
}

