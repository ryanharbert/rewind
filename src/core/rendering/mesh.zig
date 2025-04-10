const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

pub const Mesh = struct {
    vao: c.GLuint,
    vbo: c.GLuint,
    ebo: c.GLuint,
    index_count: usize,

    pub fn init(vertices: []const f32, indices: []const u32) !Mesh {
        var self: Mesh = undefined;
        self.index_count = indices.len;

        c.glGenVertexArrays(1, &self.vao);
        c.glGenBuffers(1, &self.vbo);
        c.glGenBuffers(1, &self.ebo);

        c.glBindVertexArray(self.vao);

        c.glBindBuffer(c.GL_ARRAY_BUFFER, self.vbo);
        c.glBufferData(c.GL_ARRAY_BUFFER, @as(c_longlong, @intCast(vertices.len * @sizeOf(f32))), vertices.ptr, c.GL_STATIC_DRAW);

        c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, self.ebo);
        c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, @as(c_longlong, @intCast(indices.len * @sizeOf(u32))), indices.ptr, c.GL_STATIC_DRAW);

        // Position attribute
        c.glVertexAttribPointer(0, 3, c.GL_FLOAT, c.GL_FALSE, 8 * @sizeOf(f32), null);
        c.glEnableVertexAttribArray(0);

        // Normal attribute
        c.glVertexAttribPointer(1, 3, c.GL_FLOAT, c.GL_FALSE, 8 * @sizeOf(f32), @ptrFromInt(3 * @sizeOf(f32)));
        c.glEnableVertexAttribArray(1);

        // Texture coordinate attribute
        c.glVertexAttribPointer(2, 2, c.GL_FLOAT, c.GL_FALSE, 8 * @sizeOf(f32), @ptrFromInt(6 * @sizeOf(f32)));
        c.glEnableVertexAttribArray(2);

        c.glBindVertexArray(0);

        return self;
    }

    pub fn deinit(self: *Mesh) void {
        c.glDeleteVertexArrays(1, &self.vao);
        c.glDeleteBuffers(1, &self.vbo);
        c.glDeleteBuffers(1, &self.ebo);
    }

    pub fn draw(self: *Mesh, shader_program: c.GLuint) void {
        c.glUseProgram(shader_program);
        c.glBindVertexArray(self.vao);
        c.glDrawElements(c.GL_TRIANGLES, @intCast(self.index_count), c.GL_UNSIGNED_INT, null);
        c.glBindVertexArray(0);
    }

    pub fn createSphere(radius: f32, sector_count: u32, stack_count: u32) !Mesh {
        const allocator = std.heap.page_allocator;
        var vertices = std.ArrayList(f32).init(allocator);
        defer vertices.deinit();
        var indices = std.ArrayList(u32).init(allocator);
        defer indices.deinit();

        const sector_step = 2 * std.math.pi / @as(f32, @floatFromInt(sector_count));
        const stack_step = std.math.pi / @as(f32, @floatFromInt(stack_count));

        var i: u32 = 0;
        while (i <= stack_count) : (i += 1) {
            const stack_angle = std.math.pi / 2 - @as(f32, @floatFromInt(i)) * stack_step;
            const xy = radius * @cos(stack_angle);
            const z = radius * @sin(stack_angle);

            var j: u32 = 0;
            while (j <= sector_count) : (j += 1) {
                const sector_angle = @as(f32, @floatFromInt(j)) * sector_step;

                const x = xy * @cos(sector_angle);
                const y = xy * @sin(sector_angle);

                // Position
                try vertices.append(x);
                try vertices.append(y);
                try vertices.append(z);

                // Normal
                const nx = x / radius;
                const ny = y / radius;
                const nz = z / radius;
                try vertices.append(nx);
                try vertices.append(ny);
                try vertices.append(nz);

                // Texture coordinates
                const s = @as(f32, @floatFromInt(j)) / @as(f32, @floatFromInt(sector_count));
                const t = @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(stack_count));
                try vertices.append(s);
                try vertices.append(t);
            }
        }

        i = 0;
        while (i < stack_count) : (i += 1) {
            var k1 = i * (sector_count + 1);
            var k2 = k1 + sector_count + 1;

            var j: u32 = 0;
            while (j < sector_count) : (j += 1) {
                if (i != 0) {
                    try indices.append(k1);
                    try indices.append(k2);
                    try indices.append(k1 + 1);
                }

                if (i != stack_count - 1) {
                    try indices.append(k1 + 1);
                    try indices.append(k2);
                    try indices.append(k2 + 1);
                }

                k1 += 1;
                k2 += 1;
            }
        }

        return Mesh.init(vertices.items, indices.items);
    }

    pub fn createFloor(size: f32) !Mesh {
        const vertices = [_]f32{
            // Positions          // Normals           // Texture coords
            -size, 0.0, -size,    0.0, 1.0, 0.0,       0.0, 0.0,
             size, 0.0, -size,    0.0, 1.0, 0.0,       1.0, 0.0,
             size, 0.0,  size,    0.0, 1.0, 0.0,       1.0, 1.0,
            -size, 0.0,  size,    0.0, 1.0, 0.0,       0.0, 1.0,
        };

        const indices = [_]u32{
            0, 1, 2,
            2, 3, 0,
        };

        return Mesh.init(&vertices, &indices);
    }
}; 