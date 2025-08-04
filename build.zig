const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create sokol module that points to the correct location
    const sokol_module = b.addModule("sokol", .{
        .root_source_file = b.path("libs/sokol/src/sokol/sokol.zig"),
    });

    // Main Rewind executable
    const rewind_exe = b.addExecutable(.{
        .name = "rewind",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    
    // Add Sokol module
    rewind_exe.root_module.addImport("sokol", sokol_module);
    
    // Add C source files directly
    rewind_exe.addCSourceFile(.{
        .file = b.path("libs/sokol/src/sokol/c/sokol_log.c"),
        .flags = &.{ "-DIMPL", "-DSOKOL_D3D11" },
    });
    rewind_exe.addCSourceFile(.{
        .file = b.path("libs/sokol/src/sokol/c/sokol_app.c"),
        .flags = &.{ "-DIMPL", "-DSOKOL_D3D11" },
    });
    rewind_exe.addCSourceFile(.{
        .file = b.path("libs/sokol/src/sokol/c/sokol_gfx.c"),
        .flags = &.{ "-DIMPL", "-DSOKOL_D3D11" },
    });
    rewind_exe.addCSourceFile(.{
        .file = b.path("libs/sokol/src/sokol/c/sokol_glue.c"),
        .flags = &.{ "-DIMPL", "-DSOKOL_D3D11" },
    });
    
    // Add STB Image
    rewind_exe.addIncludePath(b.path("libs/stb"));
    rewind_exe.addCSourceFile(.{
        .file = b.path("libs/stb/stb_image.c"),
        .flags = &.{"-std=c99"},
    });
    
    // Link system libraries for Windows D3D11
    rewind_exe.linkSystemLibrary("d3d11");
    rewind_exe.linkSystemLibrary("dxgi");
    rewind_exe.linkSystemLibrary("user32");
    rewind_exe.linkSystemLibrary("gdi32");
    rewind_exe.linkSystemLibrary("ole32");
    rewind_exe.linkLibC();
    
    b.installArtifact(rewind_exe);

    const run_rewind = b.addRunArtifact(rewind_exe);
    const run_step = b.step("run", "Run Rewind");
    run_step.dependOn(&run_rewind.step);

    // Core module with ECS and rollback (will be used later for display)
    _ = b.createModule(.{
        .root_source_file = b.path("src/core/ecs.zig"),
    });

    // ECS Test
    const ecs_test = b.addTest(.{
        .root_source_file = b.path("src/core/ecs_test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_ecs_test = b.addRunArtifact(ecs_test);
    const ecs_test_step = b.step("test-ecs", "Run ECS tests");
    ecs_test_step.dependOn(&run_ecs_test.step);

    // Rollback Test
    const rollback_test = b.addTest(.{
        .root_source_file = b.path("src/core/rollback_test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_rollback_test = b.addRunArtifact(rollback_test);
    const rollback_test_step = b.step("test-rollback", "Run rollback tests");
    rollback_test_step.dependOn(&run_rollback_test.step);

    // ECS Performance Test
    const ecs_perf_exe = b.addExecutable(.{
        .name = "ecs-perf",
        .root_source_file = b.path("src/core/ecs_perf_test.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });

    const run_ecs_perf = b.addRunArtifact(ecs_perf_exe);
    const ecs_perf_step = b.step("perf-ecs", "Run ECS performance test");
    ecs_perf_step.dependOn(&run_ecs_perf.step);

    // Rollback Performance Test
    const rollback_perf_exe = b.addExecutable(.{
        .name = "rollback-perf",
        .root_source_file = b.path("src/core/rollback_perf_test.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });

    const run_rollback_perf = b.addRunArtifact(rollback_perf_exe);
    const rollback_perf_step = b.step("perf-rollback", "Run rollback performance test");
    rollback_perf_step.dependOn(&run_rollback_perf.step);

    // All tests
    const test_all_step = b.step("test", "Run all tests");
    test_all_step.dependOn(&run_ecs_test.step);
    test_all_step.dependOn(&run_rollback_test.step);
}