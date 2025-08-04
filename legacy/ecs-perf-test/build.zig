const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Original performance test
    const exe = b.addExecutable(.{
        .name = "zig_perf_test",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_perf_test.zig" } },
        .target = target,
        .optimize = optimize,
    });

    // Add the rewind module path
    exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the performance test");
    run_step.dependOn(&run_cmd.step);

    // Comprehensive test
    const comprehensive_exe = b.addExecutable(.{
        .name = "comprehensive_test",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "comprehensive_test.zig" } },
        .target = target,
        .optimize = optimize,
    });

    comprehensive_exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(comprehensive_exe);

    const run_comprehensive = b.addRunArtifact(comprehensive_exe);
    run_comprehensive.step.dependOn(b.getInstallStep());

    const comprehensive_step = b.step("comprehensive", "Run the comprehensive test");
    comprehensive_step.dependOn(&run_comprehensive.step);

    // Verified test
    const verified_exe = b.addExecutable(.{
        .name = "zig_perf_test_verified",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_perf_test_verified.zig" } },
        .target = target,
        .optimize = optimize,
    });

    verified_exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(verified_exe);

    const run_verified = b.addRunArtifact(verified_exe);
    run_verified.step.dependOn(b.getInstallStep());

    const verified_step = b.step("verified", "Run the verified test");
    verified_step.dependOn(&run_verified.step);

    // High resolution timer test
    const hires_exe = b.addExecutable(.{
        .name = "zig_perf_test_hires",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_perf_test_hires.zig" } },
        .target = target,
        .optimize = optimize,
    });

    hires_exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(hires_exe);

    const run_hires = b.addRunArtifact(hires_exe);
    run_hires.step.dependOn(b.getInstallStep());

    const hires_step = b.step("hires", "Run the high resolution timer test");
    hires_step.dependOn(&run_hires.step);

    // Fast test
    const fast_exe = b.addExecutable(.{
        .name = "zig_perf_test_fast",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_perf_test_fast.zig" } },
        .target = target,
        .optimize = optimize,
    });

    fast_exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(fast_exe);

    const run_fast = b.addRunArtifact(fast_exe);
    run_fast.step.dependOn(b.getInstallStep());

    const fast_step = b.step("fast", "Run the fast test");
    fast_step.dependOn(&run_fast.step);

    // Direct access test (C# equivalent)
    const direct_exe = b.addExecutable(.{
        .name = "zig_perf_direct",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_perf_direct.zig" } },
        .target = target,
        .optimize = optimize,
    });

    direct_exe.root_module.addImport("ecs", b.createModule(.{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "../rewind/ecs.zig" } },
    }));

    b.installArtifact(direct_exe);

    const run_direct = b.addRunArtifact(direct_exe);
    run_direct.step.dependOn(b.getInstallStep());

    const direct_step = b.step("direct", "Run the direct access test");
    direct_step.dependOn(&run_direct.step);

    // True direct access test (C# equivalent)
    const true_direct_exe = b.addExecutable(.{
        .name = "zig_true_direct",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_true_direct.zig" } },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(true_direct_exe);

    const run_true_direct = b.addRunArtifact(true_direct_exe);
    run_true_direct.step.dependOn(b.getInstallStep());

    const true_direct_step = b.step("true-direct", "Run the true direct access test");
    true_direct_step.dependOn(&run_true_direct.step);

    // Ultra fast test (manual bitset operations)
    const ultra_fast_exe = b.addExecutable(.{
        .name = "zig_ultra_fast",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_ultra_fast.zig" } },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(ultra_fast_exe);

    const run_ultra_fast = b.addRunArtifact(ultra_fast_exe);
    run_ultra_fast.step.dependOn(b.getInstallStep());

    const ultra_fast_step = b.step("ultra-fast", "Run the ultra fast test");
    ultra_fast_step.dependOn(&run_ultra_fast.step);

    // Fixed direct test (C# equivalent implementation)
    const fixed_direct_exe = b.addExecutable(.{
        .name = "zig_fixed_direct",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "zig_fixed_direct.zig" } },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(fixed_direct_exe);

    const run_fixed_direct = b.addRunArtifact(fixed_direct_exe);
    run_fixed_direct.step.dependOn(b.getInstallStep());

    const fixed_direct_step = b.step("fixed-direct", "Run the fixed direct access test");
    fixed_direct_step.dependOn(&run_fixed_direct.step);
}