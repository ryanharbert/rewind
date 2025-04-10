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

    // Add local library paths
    exe.addLibraryPath(.{ .cwd_relative = "libs" });

    // Add include paths
    exe.addIncludePath(.{ .cwd_relative = "deps/glfw/include" });
    exe.addIncludePath(.{ .cwd_relative = "deps/glad/include" });

    // Link GLFW from local DLL
    exe.linkSystemLibrary("glfw3dll");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("opengl32");

    // Add GLAD source
    exe.addCSourceFile(.{
        .file = .{ .cwd_relative = "deps/glad/src/glad.c" },
        .flags = &.{},
    });

    // Install the DLL alongside the executable
    b.installBinFile("libs/glfw3dll.dll", "glfw3dll.dll");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
} 