const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

const math = std.math;
const PI = math.pi;

const Position = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
    z: f32 = 0.0,
};

const Vertex = struct {
    x: f32,
    y: f32,
    z: f32,
    r: f32,
    g: f32,
    b: f32,
};

// Screen bounds
var SCREEN_WIDTH: f32 = 800.0;
var SCREEN_HEIGHT: f32 = 600.0;
const SPHERE_SIZE_RATIO: f32 = 0.1; // Size relative to screen height
const MOVEMENT_SPEED_RATIO: f32 = 0.01; // Speed relative to screen height
var SPHERE_RADIUS: f32 = undefined;
var MOVEMENT_SPEED: f32 = undefined;
var BOUNDS_X: f32 = undefined;
var BOUNDS_Y: f32 = undefined;

// Window resize callback
fn framebufferSizeCallback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    SCREEN_WIDTH = @floatFromInt(width);
    SCREEN_HEIGHT = @floatFromInt(height);
    c.glViewport(0, 0, width, height);
    updateScreenMetrics();
}

fn updateScreenMetrics() void {
    // Make sphere size relative to screen height
    SPHERE_RADIUS = SCREEN_HEIGHT * SPHERE_SIZE_RATIO / 1000.0;
    // Make movement speed relative to screen height
    MOVEMENT_SPEED = SCREEN_HEIGHT * MOVEMENT_SPEED_RATIO / 1000.0;
    // Update bounds based on aspect ratio
    const aspect_ratio = SCREEN_WIDTH / SCREEN_HEIGHT;
    BOUNDS_X = 1.0 * aspect_ratio;
    BOUNDS_Y = 1.0;
}

// Generate sphere vertices
fn generateSphereVertices(radius: f32, sectors: u32, stacks: u32) !struct { vertices: []Vertex, indices: []u32 } {
    const allocator = std.heap.page_allocator;
    const vertex_count = (sectors + 1) * (stacks + 1);
    const index_count = sectors * stacks * 6;

    var vertices = try allocator.alloc(Vertex, vertex_count);
    var indices = try allocator.alloc(u32, index_count);

    var vi: usize = 0;
    var ii: usize = 0;

    // Generate vertices
    var stack: u32 = 0;
    while (stack <= stacks) : (stack += 1) {
        const stack_angle = PI / 2.0 - @as(f32, @floatFromInt(stack)) * PI / @as(f32, @floatFromInt(stacks));
        const xy = radius * @cos(stack_angle);
        const z = radius * @sin(stack_angle);

        var sector: u32 = 0;
        while (sector <= sectors) : (sector += 1) {
            const sector_angle = @as(f32, @floatFromInt(sector)) * 2.0 * PI / @as(f32, @floatFromInt(sectors));
            const x = xy * @cos(sector_angle);
            const y = xy * @sin(sector_angle);

            vertices[vi] = .{
                .x = x,
                .y = y,
                .z = z,
                .r = 0.7,
                .g = 0.2,
                .b = 0.2,
            };
            vi += 1;
        }
    }

    // Generate indices
    var stack_2: u32 = 0;
    while (stack_2 < stacks) : (stack_2 += 1) {
        var sector_2: u32 = 0;
        while (sector_2 < sectors) : (sector_2 += 1) {
            const first = (stack_2 * (sectors + 1)) + sector_2;
            const second = first + sectors + 1;

            indices[ii] = @intCast(first);
            indices[ii + 1] = @intCast(second);
            indices[ii + 2] = @intCast(first + 1);

            indices[ii + 3] = @intCast(first + 1);
            indices[ii + 4] = @intCast(second);
            indices[ii + 5] = @intCast(second + 1);

            ii += 6;
        }
    }

    return .{ .vertices = vertices, .indices = indices };
}

const vertex_shader_source: [*:0]const u8 =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\layout (location = 1) in vec3 aColor;
    \\out vec3 ourColor;
    \\uniform mat4 model;
    \\uniform mat4 projection;
    \\void main() {
    \\    gl_Position = projection * model * vec4(aPos, 1.0);
    \\    ourColor = aColor;
    \\}
;

const fragment_shader_source: [*:0]const u8 =
    \\#version 330 core
    \\in vec3 ourColor;
    \\out vec4 FragColor;
    \\void main() {
    \\    FragColor = vec4(ourColor, 1.0);
    \\}
;

fn createShaderProgram() !c_uint {
    const vertex_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
    c.glShaderSource(vertex_shader, 1, &vertex_shader_source, null);
    c.glCompileShader(vertex_shader);

    var success: c_int = undefined;
    c.glGetShaderiv(vertex_shader, c.GL_COMPILE_STATUS, &success);
    if (success == 0) {
        return error.ShaderCompilationFailed;
    }

    const fragment_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragment_shader, 1, &fragment_shader_source, null);
    c.glCompileShader(fragment_shader);

    c.glGetShaderiv(fragment_shader, c.GL_COMPILE_STATUS, &success);
    if (success == 0) {
        return error.ShaderCompilationFailed;
    }

    const shader_program = c.glCreateProgram();
    c.glAttachShader(shader_program, vertex_shader);
    c.glAttachShader(shader_program, fragment_shader);
    c.glLinkProgram(shader_program);

    c.glGetProgramiv(shader_program, c.GL_LINK_STATUS, &success);
    if (success == 0) {
        return error.ShaderLinkFailed;
    }

    c.glDeleteShader(vertex_shader);
    c.glDeleteShader(fragment_shader);

    return shader_program;
}

fn createProjectionMatrix(fov: f32, aspect: f32, near: f32, far: f32) [16]f32 {
    const f = 1.0 / @tan(fov * 0.5);
    return .{
        f / aspect, 0.0,  0.0,                            0.0,
        0.0,        f,    0.0,                            0.0,
        0.0,        0.0,  (far + near) / (near - far),    -1.0,
        0.0,        0.0,  (2.0 * far * near) / (near - far), 0.0,
    };
}

fn createModelMatrix(position: Position) [16]f32 {
    return .{
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        position.x, position.y, position.z, 1.0,
    };
}

pub fn main() !void {
    // Initialize GLFW
    if (c.glfwInit() == 0) {
        std.debug.print("Failed to initialize GLFW\n", .{});
        return;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    const window = c.glfwCreateWindow(800, 600, "Game Engine", null, null);
    if (window == null) {
        std.debug.print("Failed to create GLFW window\n", .{});
        return;
    }
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    c.glfwSwapInterval(1);

    // Set up window resize callback
    _ = c.glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);

    // Get initial window size
    var width: c_int = undefined;
    var height: c_int = undefined;
    c.glfwGetFramebufferSize(window, &width, &height);
    SCREEN_WIDTH = @floatFromInt(width);
    SCREEN_HEIGHT = @floatFromInt(height);
    updateScreenMetrics();

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == 0) {
        std.debug.print("Failed to initialize GLAD\n", .{});
        return;
    }

    // Enable depth testing
    c.glEnable(c.GL_DEPTH_TEST);

    // Create and compile shaders
    const shader_program = try createShaderProgram();

    // Generate sphere mesh with initial radius
    const sphere = try generateSphereVertices(SPHERE_RADIUS, 32, 16);
    defer std.heap.page_allocator.free(sphere.vertices);
    defer std.heap.page_allocator.free(sphere.indices);

    // Create and bind VAO
    var vao: c_uint = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    // Create and bind VBO
    var vbo: c_uint = undefined;
    c.glGenBuffers(1, &vbo);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, @intCast(@sizeOf(Vertex) * sphere.vertices.len), sphere.vertices.ptr, c.GL_STATIC_DRAW);

    // Create and bind EBO
    var ebo: c_uint = undefined;
    c.glGenBuffers(1, &ebo);
    c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, ebo);
    c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, @intCast(@sizeOf(u32) * sphere.indices.len), sphere.indices.ptr, c.GL_STATIC_DRAW);

    // Position attribute
    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(0));
    c.glEnableVertexAttribArray(0);

    // Color attribute
    c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vertex), @ptrFromInt(3 * @sizeOf(f32)));
    c.glEnableVertexAttribArray(1);

    // Get uniform locations
    const model_loc = c.glGetUniformLocation(shader_program, "model");
    const projection_loc = c.glGetUniformLocation(shader_program, "projection");

    // Create initial projection matrix
    const projection = createProjectionMatrix(45.0 * PI / 180.0, SCREEN_WIDTH / SCREEN_HEIGHT, 0.1, 100.0);
    c.glUseProgram(shader_program);
    c.glUniformMatrix4fv(projection_loc, 1, c.GL_FALSE, &projection);

    var position = Position{
        .x = 0.0,
        .y = 0.0,
        .z = -2.0,
    };

    while (c.glfwWindowShouldClose(window) == 0) {
        // Process input
        if (c.glfwGetKey(window, c.GLFW_KEY_ESCAPE) == c.GLFW_PRESS) {
            c.glfwSetWindowShouldClose(window, 1);
        }

        // Movement controls with bounds checking
        if (c.glfwGetKey(window, c.GLFW_KEY_W) == c.GLFW_PRESS or
            c.glfwGetKey(window, c.GLFW_KEY_UP) == c.GLFW_PRESS)
        {
            if (position.y + SPHERE_RADIUS < BOUNDS_Y) {
                position.y += MOVEMENT_SPEED;
            }
        }
        if (c.glfwGetKey(window, c.GLFW_KEY_S) == c.GLFW_PRESS or
            c.glfwGetKey(window, c.GLFW_KEY_DOWN) == c.GLFW_PRESS)
        {
            if (position.y - SPHERE_RADIUS > -BOUNDS_Y) {
                position.y -= MOVEMENT_SPEED;
            }
        }
        if (c.glfwGetKey(window, c.GLFW_KEY_A) == c.GLFW_PRESS or
            c.glfwGetKey(window, c.GLFW_KEY_LEFT) == c.GLFW_PRESS)
        {
            if (position.x - SPHERE_RADIUS > -BOUNDS_X) {
                position.x -= MOVEMENT_SPEED;
            }
        }
        if (c.glfwGetKey(window, c.GLFW_KEY_D) == c.GLFW_PRESS or
            c.glfwGetKey(window, c.GLFW_KEY_RIGHT) == c.GLFW_PRESS)
        {
            if (position.x + SPHERE_RADIUS < BOUNDS_X) {
                position.x += MOVEMENT_SPEED;
            }
        }

        // Update projection matrix if window size changed
        const new_projection = createProjectionMatrix(45.0 * PI / 180.0, SCREEN_WIDTH / SCREEN_HEIGHT, 0.1, 100.0);
        c.glUniformMatrix4fv(projection_loc, 1, c.GL_FALSE, &new_projection);

        // Update model matrix
        const model = createModelMatrix(position);
        c.glUniformMatrix4fv(model_loc, 1, c.GL_FALSE, &model);

        // Render
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);

        c.glUseProgram(shader_program);
        c.glBindVertexArray(vao);
        c.glDrawElements(c.GL_TRIANGLES, @intCast(sphere.indices.len), c.GL_UNSIGNED_INT, null);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
} 