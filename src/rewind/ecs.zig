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

/// High-performance bitset with direct word access
fn BitSet(comptime size: u32) type {
    return struct {
        const Self = @This();
        const word_count = (size + 63) / 64;
        
        words: [word_count]u64,
        
        pub fn initEmpty() Self {
            return Self{
                .words = [_]u64{0} ** word_count,
            };
        }
        
        pub fn initFull() Self {
            var self = Self{
                .words = [_]u64{std.math.maxInt(u64)} ** word_count,
            };
            // Clear bits beyond size in the last word
            const remainder = size % 64;
            if (remainder != 0) {
                const mask = (@as(u64, 1) << @intCast(remainder)) - 1;
                self.words[word_count - 1] &= mask;
            }
            return self;
        }
        
        pub inline fn set(self: *Self, index: u32) void {
            if (index >= size) return;
            const word_index = index >> 6;
            const bit_index = @as(u6, @intCast(index & 63));
            self.words[word_index] |= @as(u64, 1) << bit_index;
        }
        
        pub inline fn unset(self: *Self, index: u32) void {
            if (index >= size) return;
            const word_index = index >> 6;
            const bit_index = @as(u6, @intCast(index & 63));
            self.words[word_index] &= ~(@as(u64, 1) << bit_index);
        }
        
        pub inline fn isSet(self: *const Self, index: u32) bool {
            if (index >= size) return false;
            const word_index = index >> 6;
            const bit_index = @as(u6, @intCast(index & 63));
            return (self.words[word_index] & (@as(u64, 1) << bit_index)) != 0;
        }
        
        pub inline fn toggle(self: *Self, index: u32) void {
            if (index >= size) return;
            const word_index = index >> 6;
            const bit_index = @as(u6, @intCast(index & 63));
            self.words[word_index] ^= @as(u64, 1) << bit_index;
        }
        
        pub fn clear(self: *Self) void {
            @memset(&self.words, 0);
        }
        
        pub fn count(self: *const Self) u32 {
            var total: u32 = 0;
            for (self.words) |word| {
                total += @popCount(word);
            }
            return total;
        }
        
        pub fn intersectWith(self: *const Self, other: *const Self) Self {
            var result = Self.initEmpty();
            for (0..word_count) |i| {
                result.words[i] = self.words[i] & other.words[i];
            }
            return result;
        }

        pub fn intersectInto(self: *const Self, other: *const Self, result: *Self) void {
            for (0..word_count) |i| {
                result.words[i] = self.words[i] & other.words[i];
            }
        }
        
        pub fn copyFrom(self: *Self, other: *const Self) void {
            @memcpy(&self.words, &other.words);
        }
        
        // Standard iterator for compatibility
        pub const Iterator = struct {
            bitset: *const Self,
            index: u32,
            
            const IteratorOptions = struct {};
            
            pub fn next(self: *Iterator) ?u32 {
                while (self.index < size) {
                    const current = self.index;
                    self.index += 1;
                    if (self.bitset.isSet(current)) {
                        return current;
                    }
                }
                return null;
            }
        };
        
        pub fn iterator(self: *const Self, _: Iterator.IteratorOptions) Iterator {
            return Iterator{
                .bitset = self,
                .index = 0,
            };
        }
        
        // Fast word-based iterator
        pub const FastIterator = struct {
            bitset: *const Self,
            word_index: usize,
            current_word: u64,
            base_index: u32,
            
            pub fn init(bitset: *const Self) FastIterator {
                var iter = FastIterator{
                    .bitset = bitset,
                    .word_index = 0,
                    .current_word = if (word_count > 0) bitset.words[0] else 0,
                    .base_index = 0,
                };
                // Skip empty words at start
                while (iter.word_index < word_count and iter.current_word == 0) {
                    iter.word_index += 1;
                    if (iter.word_index < word_count) {
                        iter.current_word = bitset.words[iter.word_index];
                        iter.base_index = @intCast(iter.word_index * 64);
                    }
                }
                return iter;
            }
            
            pub inline fn next(self: *FastIterator) ?u32 {
                while (self.word_index < word_count) {
                    if (self.current_word != 0) {
                        const bit_index = @ctz(self.current_word);
                        const entity = self.base_index + bit_index;
                        self.current_word &= self.current_word - 1;
                        return entity;
                    }
                    
                    self.word_index += 1;
                    if (self.word_index < word_count) {
                        self.current_word = self.bitset.words[self.word_index];
                        self.base_index = @intCast(self.word_index * 64);
                    }
                }
                return null;
            }
        };
        
        pub fn fastIterator(self: *const Self) FastIterator {
            return FastIterator.init(self);
        }
    };
}

/// Generic bitset ECS - generates specialized ECS implementation at compile time
pub fn ECS(
    comptime config: struct {
        components: []const type,
        input: type,
        max_entities: EntityLimit = .medium,
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
        const EntityBitSet = BitSet(MAX_ENTITIES);

        /// Generate component storage type for a specific component
        fn generateComponentStorage(comptime T: type) type {
            return struct {
                dense: std.ArrayList(T),
                entity_bitset: EntityBitSet,
                entity_to_index: [MAX_ENTITIES]u32,
                index_to_entity: std.ArrayList(EntityID),

                const StorageSelf = @This();

                pub fn init(allocator: std.mem.Allocator) StorageSelf {
                    return StorageSelf{
                        .dense = std.ArrayList(T).init(allocator),
                        .entity_bitset = EntityBitSet.initEmpty(),
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
                    if (self.entity_bitset.isSet(entity)) return;

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

                // Direct access methods for hot paths
                pub inline fn getDirect(self: *StorageSelf, entity: EntityID) *T {
                    const index = self.entity_to_index[entity];
                    return &self.dense.items[index];
                }

                pub inline fn getDirectConst(self: *const StorageSelf, entity: EntityID) *const T {
                    const index = self.entity_to_index[entity];
                    return &self.dense.items[index];
                }

                // Expose raw arrays for maximum performance direct access
                pub inline fn getDenseArray(self: *StorageSelf) []T {
                    return self.dense.items;
                }

                pub inline fn getEntityToIndexArray(self: *StorageSelf) *[MAX_ENTITIES]u32 {
                    return &self.entity_to_index;
                }
            };
        }

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

        pub const FrameState = struct {
            storages: std.meta.Tuple(&StorageTypes),
            active_entities: EntityBitSet,
            next_entity: EntityID,
            entity_count: u32,
            allocator: std.mem.Allocator,

            // Pre-allocated bitsets for query operations - no allocations during queries
            query_result: EntityBitSet,
            query_temp: EntityBitSet,

            const FrameStateSelf = @This();

            pub fn createEntity(self: *FrameStateSelf) !EntityID {
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

                inline for (0..ComponentTypes.len) |i| {
                    _ = self.storages[i].remove(entity);
                }

                self.active_entities.unset(entity);
                self.entity_count -= 1;
            }

            pub fn addComponent(self: *FrameStateSelf, entity: EntityID, component: anytype) !void {
                const T = @TypeOf(component);
                
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

            pub fn query(self: *FrameStateSelf, comptime QueryTypes: []const type) !buildQuery(QueryTypes, FrameStateSelf) {
                return buildQuery(QueryTypes, FrameStateSelf).init(self);
            }

            pub fn getEntityCount(self: *const FrameStateSelf) u32 {
                return self.entity_count;
            }

            pub inline fn getStorage(self: *FrameStateSelf, comptime T: type) *StorageTypes[getComponentIndex(T)] {
                const storage_index = comptime getComponentIndex(T);
                return &self.storages[storage_index];
            }

            pub fn copyFrom(self: *FrameStateSelf, other: *const FrameStateSelf) !void {
                self.active_entities.copyFrom(&other.active_entities);
                self.next_entity = other.next_entity;
                self.entity_count = other.entity_count;

                inline for (0..ComponentTypes.len) |i| {
                    const other_storage = &other.storages[i];
                    var storage = &self.storages[i];

                    storage.entity_bitset.copyFrom(&other_storage.entity_bitset);
                    storage.entity_to_index = other_storage.entity_to_index;

                    storage.dense.clearRetainingCapacity();
                    try storage.dense.appendSlice(other_storage.dense.items);

                    storage.index_to_entity.clearRetainingCapacity();
                    try storage.index_to_entity.appendSlice(other_storage.index_to_entity.items);
                }
            }
        };

        fn buildQuery(comptime QueryTypes: []const type, comptime FrameStateType: type) type {
            return struct {
                const QuerySelf = @This();

                result_entities: EntityBitSet,
                iterator: EntityBitSet.Iterator,
                fast_iterator: EntityBitSet.FastIterator,
                frame_state: *FrameStateType,

                pub fn init(frame_state: *FrameStateType) QuerySelf {
                    var result_entities = frame_state.active_entities;

                    inline for (QueryTypes) |T| {
                        const storage_index = comptime getComponentIndex(T);
                        const component_bitset = &frame_state.storages[storage_index].entity_bitset;
                        result_entities = result_entities.intersectWith(component_bitset);
                    }

                    return QuerySelf{
                        .result_entities = result_entities,
                        .iterator = result_entities.iterator(.{}),
                        .fast_iterator = result_entities.fastIterator(),
                        .frame_state = frame_state,
                    };
                }

                pub fn next(self: *QuerySelf) ?createQueryResult(FrameStateType) {
                    if (self.iterator.next()) |entity| {
                        return createQueryResult(FrameStateType){
                            .frame_state = self.frame_state,
                            .entity = entity,
                        };
                    }
                    return null;
                }

                pub fn nextFast(self: *QuerySelf) ?createQueryResult(FrameStateType) {
                    if (self.fast_iterator.next()) |entity| {
                        return createQueryResult(FrameStateType){
                            .frame_state = self.frame_state,
                            .entity = entity,
                        };
                    }
                    return null;
                }

                pub fn count(self: *QuerySelf) u32 {
                    return self.result_entities.count();
                }

                pub fn reset(self: *QuerySelf) void {
                    self.iterator = self.result_entities.iterator(.{});
                    self.fast_iterator = self.result_entities.fastIterator();
                }

                pub const Iterator = struct {
                    query: *QuerySelf,

                    pub fn next(self: *Iterator) ?createQueryResult(FrameStateType) {
                        return self.query.next();
                    }
                };

                pub fn createIterator(self: *QuerySelf) Iterator {
                    return .{ .query = self };
                }

                pub const FastIterator = struct {
                    query: *QuerySelf,

                    pub fn next(self: *FastIterator) ?createQueryResult(FrameStateType) {
                        return self.query.nextFast();
                    }
                };

                pub fn createFastIterator(self: *QuerySelf) FastIterator {
                    return .{ .query = self };
                }
            };
        }

        fn createQueryResult(comptime FrameStateType: type) type {
            return struct {
                frame_state: *FrameStateType,
                entity: EntityID,

                pub fn get(self: @This(), comptime T: type) *T {
                    return self.frame_state.getComponent(self.entity, T).?;
                }
            };
        }

        pub const Frame = struct {
            state: FrameState,
            input: InputType,
            deltaTime: f32,
            time: f64,
            frame_number: u64,

            const FrameSelf = @This();

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

            pub inline fn getStorage(self: *FrameSelf, comptime T: type) *StorageTypes[getComponentIndex(T)] {
                return self.state.getStorage(T);
            }
        };

        current_frame: Frame,

        pub fn init(allocator: std.mem.Allocator) !Self {
            var frame_state = FrameState{
                .storages = undefined,
                .active_entities = EntityBitSet.initEmpty(),
                .next_entity = 0,
                .entity_count = 0,
                .allocator = allocator,
                .query_result = EntityBitSet.initEmpty(),
                .query_temp = EntityBitSet.initEmpty(),
            };

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

        pub fn saveFrame(self: *const Self, allocator: std.mem.Allocator) !Frame {
            var saved_frame = Frame{
                .state = FrameState{
                    .storages = undefined,
                    .active_entities = self.current_frame.state.active_entities,
                    .next_entity = self.current_frame.state.next_entity,
                    .entity_count = self.current_frame.state.entity_count,
                    .allocator = allocator,
                    .query_result = EntityBitSet.initEmpty(),
                    .query_temp = EntityBitSet.initEmpty(),
                },
                .input = self.current_frame.input,
                .deltaTime = self.current_frame.deltaTime,
                .time = self.current_frame.time,
                .frame_number = self.current_frame.frame_number,
            };

            inline for (0..ComponentTypes.len) |i| {
                saved_frame.state.storages[i] = StorageTypes[i].init(allocator);
            }

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