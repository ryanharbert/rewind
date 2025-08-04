const std = @import("std");

// Let's visualize what ECS memory actually looks like vs what we WISH it looked like

const Transform = struct { x: f32, y: f32, rotation: f32 };
const Velocity = struct { dx: f32, dy: f32, angular: f32 };

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    
    // Current ECS memory layout - SCATTERED across different allocations
    var transforms = std.ArrayList(Transform).init(allocator);
    var velocities = std.ArrayList(Velocity).init(allocator);
    var entity_to_transform = [_]u32{0} ** 1024;
    var entity_to_velocity = [_]u32{0} ** 1024;
    defer transforms.deinit();
    defer velocities.deinit();
    
    // Add some data
    try transforms.append(Transform{ .x = 1.0, .y = 2.0, .rotation = 0.0 });
    try transforms.append(Transform{ .x = 3.0, .y = 4.0, .rotation = 1.0 });
    
    try velocities.append(Velocity{ .dx = 10.0, .dy = 20.0, .angular = 0.5 });
    
    std.debug.print("=== Current ECS Memory Layout (SCATTERED) ===\\n", .{});
    std.debug.print("transforms.items.ptr = 0x{X}\\n", .{@intFromPtr(transforms.items.ptr)});
    std.debug.print("velocities.items.ptr = 0x{X}\\n", .{@intFromPtr(velocities.items.ptr)});
    std.debug.print("entity_to_transform ptr = 0x{X}\\n", .{@intFromPtr(&entity_to_transform)});
    std.debug.print("entity_to_velocity ptr = 0x{X}\\n", .{@intFromPtr(&entity_to_velocity)});
    
    const transform_size = transforms.items.len * @sizeOf(Transform);
    const velocity_size = velocities.items.len * @sizeOf(Velocity);
    
    std.debug.print("\\nData is scattered across memory!\\n", .{});
    std.debug.print("transforms: {} bytes at 0x{X}\\n", .{ transform_size, @intFromPtr(transforms.items.ptr) });
    std.debug.print("velocities: {} bytes at 0x{X}\\n", .{ velocity_size, @intFromPtr(velocities.items.ptr) });
    std.debug.print("mappings: {} bytes each at different locations\\n", .{@sizeOf(@TypeOf(entity_to_transform))});
    
    std.debug.print("\\n❌ CAN'T use single @memcpy because data is in separate allocations!\\n", .{});
    
    // What we WISH we could have - contiguous layout
    const ContiguousFrame = struct {
        // All data in one block
        transform_count: u32,
        velocity_count: u32,
        transforms: [100]Transform, // Fixed max size
        velocities: [100]Velocity,
        entity_to_transform: [1024]u32,
        entity_to_velocity: [1024]u32,
        
        pub fn copyFrom(self: *@This(), other: *const @This()) void {
            // Single @memcpy for entire frame!
            @memcpy(std.mem.asBytes(self), std.mem.asBytes(other));
            std.debug.print("✅ Single @memcpy of {} bytes!\\n", .{@sizeOf(@This())});
        }
    };
    
    std.debug.print("\\n=== Ideal Contiguous Layout (WHAT WE WANT) ===\\n", .{});
    std.debug.print("ContiguousFrame size: {} bytes\\n", .{@sizeOf(ContiguousFrame)});
    std.debug.print("All data in ONE memory block = ONE @memcpy\\n", .{});
    
    var frame1 = std.mem.zeroes(ContiguousFrame);
    var frame2 = std.mem.zeroes(ContiguousFrame);
    
    frame1.transform_count = 2;
    frame1.transforms[0] = Transform{ .x = 1.0, .y = 2.0, .rotation = 0.0 };
    frame1.transforms[1] = Transform{ .x = 3.0, .y = 4.0, .rotation = 1.0 };
    
    std.debug.print("\\nCopying contiguous frame...\\n", .{});
    frame2.copyFrom(&frame1);
    std.debug.print("Copied! frame2.transforms[0] = {{ {d}, {d}, {d} }}\\n", .{
        frame2.transforms[0].x, frame2.transforms[0].y, frame2.transforms[0].rotation 
    });
    
    std.debug.print("\\n=== WHY ECS CAN'T DO THIS ===\\n", .{});
    std.debug.print("1. ArrayList = dynamic size, separate allocations\\n", .{});
    std.debug.print("2. Each component type = separate ArrayList\\n", .{});
    std.debug.print("3. ArrayLists can grow/shrink at runtime\\n", .{});
    std.debug.print("4. Memory is fragmented across heap\\n", .{});
    std.debug.print("\\nTo get single @memcpy, we'd need fixed-size arrays\\n", .{});
    std.debug.print("But then we lose dynamic resizing capability!\\n", .{});
}