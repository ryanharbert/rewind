const std = @import("std");
const ecs = @import("ecs.zig");

const TestComponent = struct { x: f32 };

pub fn main() !void {
    const TestECS = ecs.ECS(.{
        .components = &.{TestComponent},
        .input = struct {},
        .max_entities = .tiny,
    });
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    var test_ecs = try TestECS.init(allocator);
    defer test_ecs.deinit();
    
    std.debug.print("ECS initialized successfully\n", .{});
    
    const frame = test_ecs.getFrame();
    const entity = try frame.createEntity();
    std.debug.print("Created entity: {}\n", .{entity});
    
    try frame.addComponent(entity, TestComponent{ .x = 42.0 });
    std.debug.print("Added component\n", .{});
    
    var query = try frame.query(&.{TestComponent});
    std.debug.print("Created query\n", .{});
    
    var count: u32 = 0;
    var iter = query.createIterator();
    while (iter.next()) |_| {
        count += 1;
    }
    std.debug.print("Query found {} entities\n", .{count});
}