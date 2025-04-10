const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "game_engine",
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Link against libc
    exe.linkLibC();

    // Link GLFW
    exe.linkSystemLibrary("glfw3dll");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("opengl32");

    // Add GLFW include path
    exe.addIncludePath(.{ .cwd_relative = "vcpkg/installed/x64-windows/include" });
    exe.addLibraryPath(.{ .cwd_relative = "vcpkg/installed/x64-windows/lib" });

    // Add GLAD
    exe.addCSourceFile(.{ .file = .{ .cwd_relative = "deps/glad/src/glad.c" }, .flags = &.{} });
    exe.addIncludePath(.{ .cwd_relative = "deps/glad/include" });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
} 