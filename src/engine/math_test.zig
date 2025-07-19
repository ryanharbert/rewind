const std = @import("std");
const testing = std.testing;
const math = @import("math.zig");

test "Vec2 creation and conversion" {
    const v = math.Vec2.init(1.5, 2.25);
    
    // Test conversion back to float
    try testing.expectApproxEqRel(v.toFloatX(), 1.5, 0.001);
    try testing.expectApproxEqRel(v.toFloatY(), 2.25, 0.001);
    
    // Test Vec2f conversion
    const vf = v.toFloat();
    try testing.expectApproxEqRel(vf.x, 1.5, 0.001);
    try testing.expectApproxEqRel(vf.y, 2.25, 0.001);
}

test "Vec2 arithmetic" {
    const v1 = math.Vec2.init(2.0, 3.0);
    const v2 = math.Vec2.init(1.0, 4.0);
    
    const sum = v1.add(v2);
    try testing.expectApproxEqRel(sum.toFloatX(), 3.0, 0.001);
    try testing.expectApproxEqRel(sum.toFloatY(), 7.0, 0.001);
    
    const diff = v1.sub(v2);
    try testing.expectApproxEqRel(diff.toFloatX(), 1.0, 0.001);
    try testing.expectApproxEqRel(diff.toFloatY(), -1.0, 0.001);
    
    const scaled = v1.mul(2.0);
    try testing.expectApproxEqRel(scaled.toFloatX(), 4.0, 0.001);
    try testing.expectApproxEqRel(scaled.toFloatY(), 6.0, 0.001);
}

test "Vec2 dot product" {
    const v1 = math.Vec2.init(2.0, 3.0);
    const v2 = math.Vec2.init(4.0, 1.0);
    
    const result = v1.dot(v2);
    try testing.expectApproxEqRel(math.fixedToFloat(result), 11.0, 0.001);
}

test "Vec2f operations" {
    const v1 = math.Vec2f.init(3.0, 4.0);
    const v2 = math.Vec2f.init(1.0, 2.0);
    
    const sum = v1.add(v2);
    try testing.expectApproxEqRel(sum.x, 4.0, 0.001);
    try testing.expectApproxEqRel(sum.y, 6.0, 0.001);
    
    const length = v1.length();
    try testing.expectApproxEqRel(length, 5.0, 0.001); // 3-4-5 triangle
    
    const normalized = v1.normalize();
    try testing.expectApproxEqRel(normalized.x, 0.6, 0.001);
    try testing.expectApproxEqRel(normalized.y, 0.8, 0.001);
}

test "mathf utilities" {
    try testing.expectApproxEqRel(math.mathf.lerp(0.0, 10.0, 0.5), 5.0, 0.001);
    try testing.expectApproxEqRel(math.mathf.clamp(15.0, 0.0, 10.0), 10.0, 0.001);
    try testing.expectApproxEqRel(math.mathf.clamp(-5.0, 0.0, 10.0), 0.0, 0.001);
    
    try testing.expectApproxEqRel(math.mathf.approach(0.0, 10.0, 3.0), 3.0, 0.001);
    try testing.expectApproxEqRel(math.mathf.approach(8.0, 10.0, 3.0), 10.0, 0.001);
}

test "fixed-point precision" {
    const v = math.Vec2.init(0.5, 0.25);
    
    // Test that we maintain precision
    try testing.expectApproxEqRel(v.toFloatX(), 0.5, 0.0001);
    try testing.expectApproxEqRel(v.toFloatY(), 0.25, 0.0001);
    
    // Test deterministic behavior
    const v2 = math.Vec2.init(0.5, 0.25);
    try testing.expect(v.x == v2.x);
    try testing.expect(v.y == v2.y);
}