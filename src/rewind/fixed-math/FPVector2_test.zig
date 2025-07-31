const std = @import("std");
const testing = std.testing;
const FP = @import("FP.zig").FP;
const fp = @import("FP.zig").fp;
const FPVector2 = @import("FPVector2.zig").FPVector2;
const fpVec2 = @import("FPVector2.zig").fpVec2;

test "FPVector2: fpVec2 compile-time creation" {
    // Test integer creation
    const v1 = fpVec2(5, 10);
    try testing.expectEqual(fp(5), v1.x);
    try testing.expectEqual(fp(10), v1.y);

    // Test float creation
    const v2 = fpVec2(3.5, -2.25);
    try testing.expectEqual(fp(3.5), v2.x);
    try testing.expectEqual(fp(-2.25), v2.y);

    // Test mixed types
    const v3 = fpVec2(7, 4.5);
    try testing.expectEqual(fp(7), v3.x);
    try testing.expectEqual(fp(4.5), v3.y);

    const v4 = fpVec2(1.5, -3);
    try testing.expectEqual(fp(1.5), v4.x);
    try testing.expectEqual(fp(-3), v4.y);
}

test "FPVector2: constants" {
    try testing.expect(FPVector2.ZERO.eq(fpVec2(0, 0)));
    try testing.expect(FPVector2.ONE.eq(fpVec2(1, 1)));
    try testing.expect(FPVector2.RIGHT.eq(fpVec2(1, 0)));
    try testing.expect(FPVector2.LEFT.eq(fpVec2(-1, 0)));
    try testing.expect(FPVector2.UP.eq(fpVec2(0, 1)));
    try testing.expect(FPVector2.DOWN.eq(fpVec2(0, -1)));
}

test "FPVector2: arithmetic operations" {
    const v1 = fpVec2(3, 4);
    const v2 = fpVec2(1, 2);

    // Addition
    const sum = v1.add(v2);
    try testing.expect(sum.eq(fpVec2(4, 6)));

    // Subtraction
    const diff = v1.sub(v2);
    try testing.expect(diff.eq(fpVec2(2, 2)));

    // Scalar multiplication
    const scaled = v1.mul(fp(2));
    try testing.expect(scaled.eq(fpVec2(6, 8)));

    // Scalar division
    const divided = v1.div(fp(2));
    try testing.expect(divided.eq(fpVec2(1.5, 2)));

    // Integer multiplication
    const scaled_int = v1.mulInt(3);
    try testing.expect(scaled_int.eq(fpVec2(9, 12)));

    // Integer division
    const divided_int = v1.divInt(2);
    try testing.expect(divided_int.eq(fpVec2(1.5, 2)));

    // Negation
    const negated = v1.negate();
    try testing.expect(negated.eq(fpVec2(-3, -4)));
}

test "FPVector2: dot and cross product" {
    const v1 = fpVec2(3, 4);
    const v2 = fpVec2(2, 1);

    // Dot product: 3*2 + 4*1 = 10
    const dot_result = v1.dot(v2);
    try testing.expectEqual(fp(10), dot_result);

    // Cross product (2D): 3*1 - 4*2 = -5
    const cross_result = v1.cross(v2);
    try testing.expectEqual(fp(-5), cross_result);

    // Perpendicular vectors should have dot product 0
    const v3 = fpVec2(1, 0);
    const v4 = fpVec2(0, 1);
    try testing.expectEqual(fp(0), v3.dot(v4));
}

test "FPVector2: magnitude operations" {
    // 3-4-5 triangle
    const v1 = fpVec2(3, 4);
    
    // Squared magnitude: 3² + 4² = 25
    const sqr_mag = v1.sqrMagnitude();
    try testing.expectEqual(fp(25), sqr_mag);

    // Magnitude: sqrt(25) = 5
    const mag = v1.magnitude();
    try testing.expectApproxEqAbs(fp(5).toFloat(f32), mag.toFloat(f32), 0.001);

    // Test zero vector
    const zero_mag = FPVector2.ZERO.magnitude();
    try testing.expectEqual(fp(0), zero_mag);
}

test "FPVector2: normalization" {
    const v1 = fpVec2(3, 4);
    const normalized = v1.normalize();
    
    // Check magnitude is 1
    const mag = normalized.magnitude();
    try testing.expectApproxEqAbs(1.0, mag.toFloat(f32), 0.001);

    // Check direction is preserved
    const ratio = v1.x.div(v1.y);
    const norm_ratio = normalized.x.div(normalized.y);
    try testing.expectApproxEqAbs(ratio.toFloat(f32), norm_ratio.toFloat(f32), 0.001);

    // Test zero vector normalization
    const zero_norm = FPVector2.ZERO.normalize();
    try testing.expect(zero_norm.eq(FPVector2.ZERO));

    // Test normalize with magnitude output
    var out_mag: FP = undefined;
    const norm_with_mag = v1.normalizeWithMagnitude(&out_mag);
    try testing.expectApproxEqAbs(5.0, out_mag.toFloat(f32), 0.001);
    try testing.expectApproxEqAbs(1.0, norm_with_mag.magnitude().toFloat(f32), 0.001);
}

test "FPVector2: distance operations" {
    const v1 = fpVec2(1, 2);
    const v2 = fpVec2(4, 6);

    // Distance should be 5 (3-4-5 triangle)
    const dist = FPVector2.distance(v1, v2);
    try testing.expectApproxEqAbs(5.0, dist.toFloat(f32), 0.001);

    // Squared distance should be 25
    const dist_sqr = FPVector2.distanceSquared(v1, v2);
    try testing.expectEqual(fp(25), dist_sqr);
}

test "FPVector2: comparison operations" {
    const v1 = fpVec2(3, 4);
    const v2 = fpVec2(3, 4);
    const v3 = fpVec2(3, 5);

    // Equality
    try testing.expect(v1.eq(v2));
    try testing.expect(!v1.eq(v3));

    // Inequality
    try testing.expect(!v1.neq(v2));
    try testing.expect(v1.neq(v3));

    // Approximate equality
    const v4 = fpVec2(3.001, 4.001);
    try testing.expect(v1.approxEq(v4, fp(0.01)));
    try testing.expect(!v1.approxEq(v4, fp(0.0001)));
}

test "FPVector2: component operations" {
    const v1 = fpVec2(3, 7);
    const v2 = fpVec2(5, 2);

    // Min
    const min_v = FPVector2.min(v1, v2);
    try testing.expect(min_v.eq(fpVec2(3, 2)));

    // Max
    const max_v = FPVector2.max(v1, v2);
    try testing.expect(max_v.eq(fpVec2(5, 7)));

    // Clamp
    const v3 = fpVec2(10, -5);
    const clamped = v3.clamp(fpVec2(0, 0), fpVec2(5, 5));
    try testing.expect(clamped.eq(fpVec2(5, 0)));

    // Scale (component-wise multiplication)
    const scaled = v1.scale(v2);
    try testing.expect(scaled.eq(fpVec2(15, 14)));

    // Absolute value
    const v4 = fpVec2(-3, -4);
    const abs_v = v4.abs();
    try testing.expect(abs_v.eq(fpVec2(3, 4)));

    // Sign
    const v5 = fpVec2(-5, 3);
    const sign_v = v5.sign();
    try testing.expect(sign_v.eq(fpVec2(-1, 1)));
}

test "FPVector2: clamp magnitude" {
    const v1 = fpVec2(3, 4); // magnitude = 5
    
    // Clamp to smaller magnitude
    const clamped1 = v1.clampMagnitude(fp(2));
    const mag1 = clamped1.magnitude();
    try testing.expectApproxEqAbs(2.0, mag1.toFloat(f32), 0.001);
    
    // Clamp to larger magnitude (no change)
    const clamped2 = v1.clampMagnitude(fp(10));
    try testing.expect(clamped2.eq(v1));
}

test "FPVector2: rotation operations" {
    const v1 = fpVec2(1, 0);

    // Rotate 90 degrees counter-clockwise
    const rotated90 = v1.rotate(FP.PI_2);
    try testing.expectApproxEqAbs(0.0, rotated90.x.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(1.0, rotated90.y.toFloat(f32), 0.01);

    // Rotate right (90 degrees clockwise)
    const right = v1.rotateRight();
    try testing.expect(right.eq(fpVec2(0, -1)));

    // Rotate left (90 degrees counter-clockwise)
    const left = v1.rotateLeft();
    try testing.expect(left.eq(fpVec2(0, 1)));

    // Test rotate with precomputed sin/cos
    const angle = FP.PI_4; // 45 degrees
    const sin_val = angle.sin();
    const cos_val = angle.cos();
    const rotated45 = v1.rotateWithSinCos(sin_val, cos_val);
    try testing.expectApproxEqAbs(0.707, rotated45.x.toFloat(f32), 0.001);
    try testing.expectApproxEqAbs(0.707, rotated45.y.toFloat(f32), 0.001);
}

test "FPVector2: angle operations" {
    const v1 = fpVec2(1, 0);
    const v2 = fpVec2(0, 1);
    const v3 = fpVec2(-1, 0);

    // Angle between perpendicular vectors
    const angle90 = FPVector2.angle(v1, v2);
    try testing.expectApproxEqAbs(FP.PI_2.toFloat(f32), angle90.toFloat(f32), 0.001);

    // Angle between opposite vectors
    const angle180 = FPVector2.angle(v1, v3);
    try testing.expectApproxEqAbs(FP.PI.toFloat(f32), angle180.toFloat(f32), 0.001);

    // Signed angle
    const signed_angle1 = FPVector2.signedAngle(v1, v2);
    try testing.expectApproxEqAbs(FP.PI_2.toFloat(f32), signed_angle1.toFloat(f32), 0.001);

    const signed_angle2 = FPVector2.signedAngle(v2, v1);
    try testing.expectApproxEqAbs(-FP.PI_2.toFloat(f32), signed_angle2.toFloat(f32), 0.001);

    // Angle from X axis
    const v4 = fpVec2(1, 1);
    const angle_from_x = v4.angleFromX();
    try testing.expectApproxEqAbs(FP.PI_4.toFloat(f32), angle_from_x.toFloat(f32), 0.1);

    // Create vector from angle
    const from_angle = FPVector2.fromAngle(FP.PI_4);
    try testing.expectApproxEqAbs(0.707, from_angle.x.toFloat(f32), 0.001);
    try testing.expectApproxEqAbs(0.707, from_angle.y.toFloat(f32), 0.001);
}

test "FPVector2: interpolation" {
    const v1 = fpVec2(0, 0);
    const v2 = fpVec2(10, 20);

    // Linear interpolation at t=0.5
    const lerped = FPVector2.lerp(v1, v2, fp(0.5));
    try testing.expect(lerped.eq(fpVec2(5, 10)));

    // Linear interpolation clamped
    const lerped_clamped = FPVector2.lerp(v1, v2, fp(1.5));
    try testing.expect(lerped_clamped.eq(v2));

    // Linear interpolation unclamped
    const lerped_unclamped = FPVector2.lerpUnclamped(v1, v2, fp(1.5));
    try testing.expect(lerped_unclamped.eq(fpVec2(15, 30)));

    // Move towards
    const v3 = fpVec2(3, 4); // distance = 5
    const moved = FPVector2.moveTowards(v1, v3, fp(2));
    const moved_dist = FPVector2.distance(v1, moved);
    try testing.expectApproxEqAbs(2.0, moved_dist.toFloat(f32), 0.001);

    // Move towards when already close
    const moved_close = FPVector2.moveTowards(v1, v3, fp(10));
    try testing.expect(moved_close.eq(v3));
}

test "FPVector2: reflection and projection" {
    const v1 = fpVec2(1, -1);
    const normal = fpVec2(0, 1);

    // Reflection
    const reflected = v1.reflect(normal);
    try testing.expect(reflected.eq(fpVec2(1, 1)));

    // Projection
    const v2 = fpVec2(3, 4);
    const v3 = fpVec2(1, 0);
    const projected = v2.project(v3);
    try testing.expect(projected.eq(fpVec2(3, 0)));

    // Project onto normalized
    const v4 = fpVec2(5, 5);
    const normalized = fpVec2(0.707, 0.707); // approximately normalized (1,1)
    const proj_norm = v4.projectOntoNormalized(normalized);
    const expected_mag = v4.dot(normalized);
    try testing.expectApproxEqAbs(expected_mag.toFloat(f32), proj_norm.magnitude().toFloat(f32), 0.1);

    // Perpendicular component
    const perp = v2.perpendicular(v3);
    try testing.expect(perp.eq(fpVec2(0, 4)));
}

test "FPVector2: swizzle operations" {
    const v = fpVec2(3, 7);

    try testing.expect(v.xx().eq(fpVec2(3, 3)));
    try testing.expect(v.yy().eq(fpVec2(7, 7)));
    try testing.expect(v.yx().eq(fpVec2(7, 3)));
}

test "FPVector2: smooth damp" {
    var current = fpVec2(0, 0);
    const target = fpVec2(10, 10);
    var velocity = FPVector2.ZERO;
    const smooth_time = fp(1);
    const max_speed = fp(100);
    const delta_time = fp(0.1);

    // Simulate several steps
    var i: u32 = 0;
    while (i < 10) : (i += 1) {
        current = FPVector2.smoothDamp(current, target, &velocity, smooth_time, max_speed, delta_time);
    }

    // Should be moving towards target
    const dist = FPVector2.distance(current, target);
    const initial_dist = FPVector2.distance(fpVec2(0, 0), target);
    try testing.expect(dist.lt(initial_dist));
}

test "FPVector2: formatting" {
    const v = fpVec2(3.5, -2.25);
    
    var buffer: [100]u8 = undefined;
    const result = try std.fmt.bufPrint(&buffer, "{}", .{v});
    
    // Should contain both values
    try testing.expect(std.mem.indexOf(u8, result, "3.5") != null);
    try testing.expect(std.mem.indexOf(u8, result, "-2.25") != null);
}