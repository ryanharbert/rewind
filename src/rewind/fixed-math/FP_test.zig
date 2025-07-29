const std = @import("std");
const testing = std.testing;
const FP = @import("FP.zig").FP;
const fp = @import("FP.zig").fp;

test "FP creation from integers" {
    const a = fp(5);
    try testing.expectEqual(@as(i64, 5 << 16), a.raw_value);
    
    const b = fp(-10);
    try testing.expectEqual(@as(i64, -10 << 16), b.raw_value);
    
    const c = fp(0);
    try testing.expectEqual(@as(i64, 0), c.raw_value);
}

test "FP creation from compile-time floats" {
    const a = FP.fromFloat(3.14);
    const expected_raw = @as(i64, @intFromFloat(3.14 * @as(f64, 1 << 16)));
    try testing.expectEqual(expected_raw, a.raw_value);
    
    const b = fp(3.14);  // Should work with comptime floats
    try testing.expectEqual(expected_raw, b.raw_value);
}

test "FP constants" {
    try testing.expectEqual(@as(i64, 0), fp(0).raw_value);
    try testing.expectEqual(@as(i64, 1 << 16), fp(1).raw_value);
    try testing.expectEqual(@as(i64, 2 << 16), fp(2).raw_value);
    try testing.expectEqual(@as(i64, 1 << 15), fp(0.5).raw_value);
    try testing.expectEqual(@as(i64, 1 << 14), fp(0.25).raw_value);
    try testing.expectEqual(@as(i64, 3 << 14), fp(0.75).raw_value);
}

test "FP arithmetic - addition" {
    const a = fp(5);
    const b = fp(3);
    const c = a.add(b);
    try testing.expectEqual(@as(i64, 8 << 16), c.raw_value);
    
    const d = fp(0.5).add(fp(0.25));
    try testing.expectEqual(fp(0.75).raw_value, d.raw_value);
}

test "FP arithmetic - subtraction" {
    const a = fp(10);
    const b = fp(3);
    const c = a.sub(b);
    try testing.expectEqual(@as(i64, 7 << 16), c.raw_value);
    
    const d = fp(1).sub(fp(0.25));
    try testing.expectEqual(fp(0.75).raw_value, d.raw_value);
}

test "FP arithmetic - multiplication" {
    const a = fp(5);
    const b = fp(4);
    const c = a.mul(b);
    try testing.expectEqual(@as(i64, 20 << 16), c.raw_value);
    
    const d = fp(0.5).mul(fp(0.5));
    try testing.expectEqual(fp(0.25).raw_value, d.raw_value);
    
    // Test with negative numbers
    const e = fp(-3);
    const f = fp(4);
    const g = e.mul(f);
    try testing.expectEqual(@as(i64, -12 << 16), g.raw_value);
}

test "FP arithmetic - division" {
    const a = fp(20);
    const b = fp(4);
    const c = a.div(b);
    try testing.expectEqual(@as(i64, 5 << 16), c.raw_value);
    
    const d = fp(1).div(fp(2));
    try testing.expectEqual(fp(0.5).raw_value, d.raw_value);
    
    const e = fp(3).div(fp(4));
    try testing.expectEqual(fp(0.75).raw_value, e.raw_value);
}

test "FP comparisons" {
    const a = fp(5);
    const b = fp(3);
    const c = fp(5);
    
    try testing.expect(a.gt(b));
    try testing.expect(b.lt(a));
    try testing.expect(a.gte(c));
    try testing.expect(a.lte(c));
    try testing.expect(a.eq(c));
    try testing.expect(a.neq(b));
}

test "FP conversion to/from integers" {
    const a = fp(42);
    try testing.expectEqual(@as(i32, 42), a.asInt());
    try testing.expectEqual(@as(i64, 42), a.asLong());
    try testing.expectEqual(@as(u32, 42), a.toInt(u32));
    
    // Test truncation of fractional part
    const b = FP.fromFloat(3.75);
    try testing.expectEqual(@as(i32, 3), b.asInt());
}

test "FP formatting" {
    var buffer: [100]u8 = undefined;
    
    const a = fp(42);
    const result1 = try std.fmt.bufPrint(&buffer, "{}", .{a});
    try testing.expectEqualStrings("42", result1);
    
    const b = FP.fromFloat(3.14159);
    const result2 = try std.fmt.bufPrint(&buffer, "{}", .{b});
    try testing.expect(std.mem.startsWith(u8, result2, "3.14"));
    
    const c = FP.fromFloat(-123.456);
    const result3 = try std.fmt.bufPrint(&buffer, "{}", .{c});
    try testing.expect(std.mem.startsWith(u8, result3, "-123.45"));
    
    const d = fp(0.5);
    const result4 = try std.fmt.bufPrint(&buffer, "{}", .{d});
    try testing.expectEqualStrings("0.5", result4);
}

test "FP string parsing" {
    const a = try FP.fromString("42");
    try testing.expectEqual(fp(42).raw_value, a.raw_value);
    
    const b = try FP.fromString("3.14");
    try testing.expectApproxEqAbs(@as(f32, 3.14), b.toFloat(f32), 0.01);
    
    const c = try FP.fromString("-123.456");
    try testing.expectApproxEqAbs(@as(f32, -123.456), c.toFloat(f32), 0.01);
    
    const d = try FP.fromString("0.5");
    try testing.expectEqual(fp(0.5).raw_value, d.raw_value);
    
    const e = try FP.fromString("  42.0  ");
    try testing.expectEqual(fp(42).raw_value, e.raw_value);
}

test "FP edge cases" {
    // Test zero
    const zero = fp(0);
    try testing.expectEqual(@as(i64, 0), zero.raw_value);
    try testing.expectEqual(@as(i32, 0), zero.asInt());
    
    // Test negation
    const a = fp(5);
    const neg_a = a.negate();
    try testing.expectEqual(@as(i64, -5 << 16), neg_a.raw_value);
    
    // Test smallest non-zero
    const tiny = FP.SMALLEST_NON_ZERO;
    try testing.expectEqual(@as(i64, 1), tiny.raw_value);
    try testing.expectEqual(@as(i32, 0), tiny.asInt()); // Should truncate to 0
    
    // Test modulo
    const x = fp(10);
    const y = fp(3);
    const remainder = x.mod(y);
    try testing.expectEqual(fp(1).raw_value, remainder.raw_value);
}

test "FP mathematical constants" {
    // Test that constants are reasonable values
    try testing.expect(FP.PI.toFloat(f32) > 3.14 and FP.PI.toFloat(f32) < 3.15);
    try testing.expect(FP.E.toFloat(f32) > 2.71 and FP.E.toFloat(f32) < 2.72);
    try testing.expect(FP.SQRT2.toFloat(f32) > 1.41 and FP.SQRT2.toFloat(f32) < 1.42);
    
    // Test angle conversions
    const degrees = fp(180);
    const radians = degrees.mul(FP.DEG2RAD);
    try testing.expectApproxEqAbs(FP.PI.toFloat(f32), radians.toFloat(f32), 0.01);
    
    const back_to_degrees = radians.mul(FP.RAD2DEG);
    try testing.expectApproxEqAbs(@as(f32, 180), back_to_degrees.toFloat(f32), 0.15);
}

test "FP overflow behavior" {
    // Test that we can represent the full useable range
    const max_useable = FP.USEABLE_MAX;
    const min_useable = FP.USEABLE_MIN;
    
    try testing.expectEqual(@as(i32, std.math.maxInt(i32)), max_useable.asInt());
    try testing.expectEqual(@as(i32, std.math.minInt(i32)), min_useable.asInt());
    
    // Multiplication within useable range should not overflow
    const small = fp(100);
    const result = small.mul(small); // 10,000
    try testing.expectEqual(@as(i32, 10000), result.asInt());
}

test "FP determinism" {
    // Test that operations are deterministic
    const a = FP.fromFloat(1.0 / 3.0);
    const b = FP.fromFloat(1.0 / 3.0);
    try testing.expectEqual(a.raw_value, b.raw_value);
    
    // Multiple operations should yield same result
    const x = fp(7);
    const y = fp(3);
    const result1 = x.mul(y).add(fp(5)).div(fp(2));
    const result2 = x.mul(y).add(fp(5)).div(fp(2));
    try testing.expectEqual(result1.raw_value, result2.raw_value);
}

test "FP math operations - sign" {
    const positive = fp(5);
    const negative = fp(-5);
    const zero = fp(0);
    
    try testing.expectEqual(fp(1).raw_value, positive.sign().raw_value);
    try testing.expectEqual(fp(-1).raw_value, negative.sign().raw_value);
    try testing.expectEqual(fp(1).raw_value, zero.sign().raw_value);
    
    // Sign with zero handling
    try testing.expectEqual(fp(1).raw_value, positive.signZero().raw_value);
    try testing.expectEqual(fp(-1).raw_value, negative.signZero().raw_value);
    try testing.expectEqual(fp(0).raw_value, zero.signZero().raw_value);
}

test "FP math operations - abs" {
    const positive = fp(5);
    const negative = fp(-5);
    
    try testing.expectEqual(fp(5).raw_value, positive.abs().raw_value);
    try testing.expectEqual(fp(5).raw_value, negative.abs().raw_value);
    try testing.expectEqual(fp(0).raw_value, fp(0).abs().raw_value);
}

test "FP math operations - min/max" {
    const a = fp(5);
    const b = fp(10);
    const c = fp(-3);
    
    try testing.expectEqual(a.raw_value, FP.min(a, b).raw_value);
    try testing.expectEqual(b.raw_value, FP.max(a, b).raw_value);
    try testing.expectEqual(c.raw_value, FP.min(a, c).raw_value);
    try testing.expectEqual(a.raw_value, FP.max(a, c).raw_value);
}

test "FP math operations - clamp" {
    const value = fp(5);
    const min_val = fp(0);
    const max_val = fp(10);
    
    try testing.expectEqual(value.raw_value, value.clamp(min_val, max_val).raw_value);
    try testing.expectEqual(min_val.raw_value, fp(-5).clamp(min_val, max_val).raw_value);
    try testing.expectEqual(max_val.raw_value, fp(15).clamp(min_val, max_val).raw_value);
    
    // Test clamp01
    try testing.expectEqual(fp(0).raw_value, fp(-1).clamp01().raw_value);
    try testing.expectEqual(fp(1).raw_value, fp(2).clamp01().raw_value);
    try testing.expectEqual(fp(0.5).raw_value, fp(0.5).clamp01().raw_value);
}

test "FP math operations - floor/ceil/round" {
    const a = FP.fromFloat(3.7);
    const b = FP.fromFloat(3.3);
    const c = FP.fromFloat(-2.7);
    const d = FP.fromFloat(4.5);
    
    // Floor
    try testing.expectEqual(@as(i32, 3), a.floorToInt());
    try testing.expectEqual(@as(i32, 3), b.floorToInt());
    try testing.expectEqual(@as(i32, -3), c.floorToInt());
    
    // Ceil
    try testing.expectEqual(@as(i32, 4), a.ceilToInt());
    try testing.expectEqual(@as(i32, 4), b.ceilToInt());
    try testing.expectEqual(@as(i32, -2), c.ceilToInt());
    
    // Round
    try testing.expectEqual(@as(i32, 4), a.roundToInt());
    try testing.expectEqual(@as(i32, 3), b.roundToInt());
    try testing.expectEqual(@as(i32, -3), c.roundToInt());
    try testing.expectEqual(@as(i32, 4), d.roundToInt()); // 4.5 rounds to even = 4
}

test "FP math operations - fraction" {
    const a = FP.fromFloat(3.75);
    const frac = a.fraction();
    
    try testing.expectEqual(fp(0.75).raw_value, frac.raw_value);
    try testing.expectEqual(fp(0).raw_value, fp(5).fraction().raw_value);
}

test "FP math operations - lerp" {
    const start = fp(0);
    const end = fp(10);
    
    try testing.expectEqual(start.raw_value, FP.lerp(start, end, fp(0)).raw_value);
    try testing.expectEqual(end.raw_value, FP.lerp(start, end, fp(1)).raw_value);
    try testing.expectEqual(fp(5).raw_value, FP.lerp(start, end, fp(0.5)).raw_value);
    
    // Test clamping
    try testing.expectEqual(start.raw_value, FP.lerp(start, end, fp(-1)).raw_value);
    try testing.expectEqual(end.raw_value, FP.lerp(start, end, fp(2)).raw_value);
    
    // Test unclamped
    try testing.expectEqual(fp(-10).raw_value, FP.lerpUnclamped(start, end, fp(-1)).raw_value);
    try testing.expectEqual(fp(20).raw_value, FP.lerpUnclamped(start, end, fp(2)).raw_value);
}

test "FP math operations - sqrt" {
    const a = fp(4);
    const b = fp(16);
    const c = fp(2);
    
    const sqrt_a = a.sqrt();
    const sqrt_b = b.sqrt();
    const sqrt_c = c.sqrt();
    
    // Check results are approximately correct
    try testing.expectApproxEqAbs(@as(f32, 2.0), sqrt_a.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 4.0), sqrt_b.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.414), sqrt_c.toFloat(f32), 0.01);
}

test "FP fast square root functions" {
    const a = fp(4);
    const b = fp(16);
    const c = fp(2);
    
    // Test sqrtFast
    const sqrt_fast_a = a.sqrtFast();
    const sqrt_fast_b = b.sqrtFast();
    const sqrt_fast_c = c.sqrtFast();
    
    try testing.expectApproxEqAbs(@as(f32, 2.0), sqrt_fast_a.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 4.0), sqrt_fast_b.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 1.414), sqrt_fast_c.toFloat(f32), 0.05);
    
    // Test rsqrt (reciprocal square root)
    const rsqrt_a = a.rsqrt();  // 1/sqrt(4) = 1/2 = 0.5
    const rsqrt_b = b.rsqrt();  // 1/sqrt(16) = 1/4 = 0.25
    
    try testing.expectApproxEqAbs(@as(f32, 0.5), rsqrt_a.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 0.25), rsqrt_b.toFloat(f32), 0.05);
    
    // Test rsqrtFast
    const rsqrt_fast_a = a.rsqrtFast();
    const rsqrt_fast_b = b.rsqrtFast();
    
    try testing.expectApproxEqAbs(@as(f32, 0.5), rsqrt_fast_a.toFloat(f32), 0.1);
    try testing.expectApproxEqAbs(@as(f32, 0.25), rsqrt_fast_b.toFloat(f32), 0.1);
}

test "FP trigonometric functions - basic" {
    // Test sin
    const sin_0 = fp(0).sin();
    const sin_pi_2 = FP.PI_2.sin();
    const sin_pi = FP.PI.sin();
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), sin_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), sin_pi_2.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 0.0), sin_pi.toFloat(f32), 0.01);
    
    // Test cos
    const cos_0 = fp(0).cos();
    const cos_pi_2 = FP.PI_2.cos();
    const cos_pi = FP.PI.cos();
    
    try testing.expectApproxEqAbs(@as(f32, 1.0), cos_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 0.0), cos_pi_2.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, -1.0), cos_pi.toFloat(f32), 0.01);
    
    // Test tan
    const tan_0 = fp(0).tan();
    const tan_pi_4 = FP.PI_4.tan();
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), tan_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), tan_pi_4.toFloat(f32), 0.05);
}

test "FP trigonometric functions - inverse" {
    // Test asin
    const asin_0 = fp(0).asin();
    const asin_1 = fp(1).asin();
    const asin_neg1 = fp(-1).asin();
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), asin_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(FP.PI_2.toFloat(f32), asin_1.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(-FP.PI_2.toFloat(f32), asin_neg1.toFloat(f32), 0.05);
    
    // Test acos
    const acos_0 = fp(0).acos();
    const acos_1 = fp(1).acos();
    
    try testing.expectApproxEqAbs(FP.PI_2.toFloat(f32), acos_0.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 0.0), acos_1.toFloat(f32), 0.05);
    
    // Test atan
    const atan_0 = fp(0).atan();
    const atan_1 = fp(1).atan();
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), atan_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(FP.PI_4.toFloat(f32), atan_1.toFloat(f32), 0.05);
    
    // Test atan2
    const atan2_result = FP.atan2(fp(1), fp(1)); // atan2(1,1) = π/4
    try testing.expectApproxEqAbs(FP.PI_4.toFloat(f32), atan2_result.toFloat(f32), 0.05);
    
    const atan2_result2 = FP.atan2(fp(1), fp(0)); // atan2(1,0) = π/2
    try testing.expectApproxEqAbs(FP.PI_2.toFloat(f32), atan2_result2.toFloat(f32), 0.05);
}

test "FP exponential and logarithmic functions" {
    // Test exp
    const exp_0 = fp(0).exp();     // e^0 = 1
    const exp_1 = fp(1).exp();     // e^1 = e ≈ 2.718
    const exp_2 = fp(2).exp();     // e^2 ≈ 7.389
    
    try testing.expectApproxEqAbs(@as(f32, 1.0), exp_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 2.718), exp_1.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 7.389), exp_2.toFloat(f32), 0.1);
    
    // Test ln
    const ln_1 = fp(1).ln();       // ln(1) = 0
    const ln_e = FP.E.ln();        // ln(e) = 1
    const ln_2 = fp(2).ln();       // ln(2) ≈ 0.693
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), ln_1.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), ln_e.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 0.693), ln_2.toFloat(f32), 0.05);
    
    // Test log2
    const log2_1 = fp(1).log2();   // log2(1) = 0
    const log2_2 = fp(2).log2();   // log2(2) = 1
    const log2_8 = fp(8).log2();   // log2(8) = 3
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), log2_1.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), log2_2.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 3.0), log2_8.toFloat(f32), 0.1);
    
    // Test log10
    const log10_1 = fp(1).log10();  // log10(1) = 0
    const log10_10 = fp(10).log10(); // log10(10) = 1
    const log10_100 = fp(100).log10(); // log10(100) = 2
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), log10_1.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), log10_10.toFloat(f32), 0.05);
    try testing.expectApproxEqAbs(@as(f32, 2.0), log10_100.toFloat(f32), 0.1);
}

test "FP power functions" {
    // Test pow
    const pow_2_3 = fp(2).pow(fp(3));   // 2^3 = 8
    const pow_3_2 = fp(3).pow(fp(2));   // 3^2 = 9
    const pow_e_2 = FP.E.pow(fp(2));    // e^2 ≈ 7.389
    
    try testing.expectApproxEqAbs(@as(f32, 8.0), pow_2_3.toFloat(f32), 0.2);
    try testing.expectApproxEqAbs(@as(f32, 9.0), pow_3_2.toFloat(f32), 0.2);
    try testing.expectApproxEqAbs(@as(f32, 7.389), pow_e_2.toFloat(f32), 0.3);
    
    // Test powi (integer power - should be more accurate and faster)
    const powi_2_3 = fp(2).powi(3);     // 2^3 = 8
    const powi_3_4 = fp(3).powi(4);     // 3^4 = 81
    const powi_5_neg2 = fp(5).powi(-2); // 5^-2 = 1/25 = 0.04
    
    try testing.expectEqual(@as(i64, 8 << 16), powi_2_3.raw_value);
    try testing.expectEqual(@as(i64, 81 << 16), powi_3_4.raw_value);
    try testing.expectApproxEqAbs(@as(f32, 0.04), powi_5_neg2.toFloat(f32), 0.01);
    
    // Test edge cases
    const pow_anything_0 = fp(42).pow(fp(0)); // anything^0 = 1
    const pow_1_anything = fp(1).pow(fp(123)); // 1^anything = 1
    const powi_anything_0 = fp(42).powi(0);   // anything^0 = 1
    
    try testing.expectEqual(fp(1).raw_value, pow_anything_0.raw_value);
    try testing.expectEqual(fp(1).raw_value, pow_1_anything.raw_value);
    try testing.expectEqual(fp(1).raw_value, powi_anything_0.raw_value);
}

test "FP advanced interpolation functions" {
    // Test smoothstep
    const smooth_0 = FP.smoothstep(fp(0), fp(1), fp(0));     // Should be 0
    const smooth_1 = FP.smoothstep(fp(0), fp(1), fp(1));     // Should be 1
    const smooth_half = FP.smoothstep(fp(0), fp(1), fp(0.5)); // Should be 0.5
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), smooth_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), smooth_1.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 0.5), smooth_half.toFloat(f32), 0.05);
    
    // Test smootherstep
    const smoother_0 = FP.smootherstep(fp(0), fp(1), fp(0));
    const smoother_1 = FP.smootherstep(fp(0), fp(1), fp(1));
    const smoother_half = FP.smootherstep(fp(0), fp(1), fp(0.5));
    
    try testing.expectApproxEqAbs(@as(f32, 0.0), smoother_0.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 1.0), smoother_1.toFloat(f32), 0.01);
    try testing.expectApproxEqAbs(@as(f32, 0.5), smoother_half.toFloat(f32), 0.05);
    
    // Test hermite interpolation
    const hermite_result = FP.hermite(fp(0), fp(1), fp(0), fp(0), fp(0.5));
    try testing.expectApproxEqAbs(@as(f32, 0.5), hermite_result.toFloat(f32), 0.05);
    
    // Test catmull-rom spline
    const catmull_result = FP.catmullRom(fp(0), fp(1), fp(2), fp(3), fp(0.5));
    try testing.expectApproxEqAbs(@as(f32, 1.5), catmull_result.toFloat(f32), 0.1);
    
    // Test bezier cubic
    const bezier_result = FP.bezierCubic(fp(0), fp(1), fp(2), fp(3), fp(0.5));
    try testing.expectApproxEqAbs(@as(f32, 1.5), bezier_result.toFloat(f32), 0.1);
    
    // Test barycentric interpolation
    const bary_result = FP.barycentric(fp(10), fp(20), fp(30), fp(0.5), fp(0.3), fp(0.2));
    const expected = 10.0 * 0.5 + 20.0 * 0.3 + 30.0 * 0.2; // = 5 + 6 + 6 = 17
    try testing.expectApproxEqAbs(@as(f32, expected), bary_result.toFloat(f32), 0.1);
    
    // Test exponential decay
    const exp_decay = FP.expDecay(fp(10), fp(0), fp(2), fp(1)); // Decay from 10 to 0
    try testing.expect(exp_decay.gt(fp(0)) and exp_decay.lt(fp(10))); // Should be between 0 and 10
}