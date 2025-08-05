const std = @import("std");
const sokol = @import("sokol");
const sg = sokol.gfx;
const assets = @import("assets.zig");
const shd = @import("sprite_shader.glsl.zig");

pub const Vec2 = struct {
    x: f32,
    y: f32,
};

pub const Color = struct {
    r: f32 = 1.0,
    g: f32 = 1.0,
    b: f32 = 1.0,
    a: f32 = 1.0,
};

// Simple sprite - just position, size, color, and texture
pub const Sprite = struct {
    position: Vec2,
    size: Vec2,
    color: Color = .{},
    texture_id: u32,
};

// Instance data sent to GPU per sprite
const SpriteInstance = struct {
    pos_size: [4]f32, // x, y, width, height
    color: [4]f32,    // r, g, b, a
};

const MAX_SPRITES = 10000;

// Quad vertices (two triangles)
const quad_vertices = [_]f32{
    0.0, 0.0,  // Bottom-left
    1.0, 0.0,  // Bottom-right
    1.0, 1.0,  // Top-right
    0.0, 0.0,  // Bottom-left
    1.0, 1.0,  // Top-right
    0.0, 1.0,  // Top-left
};

pub const SpriteRenderer = struct {
    allocator: std.mem.Allocator,
    
    // GPU resources
    shader: sg.Shader,
    pipeline: sg.Pipeline,
    vertex_buffer: sg.Buffer,
    instance_buffers: [8]sg.Buffer, // Multiple instance buffers to avoid update conflicts
    sampler: sg.Sampler,
    
    // Textures
    textures: std.ArrayList(sg.Image),
    
    // Current frame sprites
    sprites: std.ArrayList(Sprite),
    
    pub fn init(allocator: std.mem.Allocator) !SpriteRenderer {
        // Create vertex buffer for quad
        const vertex_buffer = sg.makeBuffer(.{
            .data = sg.asRange(&quad_vertices),
        });
        
        // Create multiple dynamic instance buffers
        var instance_buffers: [8]sg.Buffer = undefined;
        for (&instance_buffers) |*buffer| {
            buffer.* = sg.makeBuffer(.{
                .size = MAX_SPRITES * @sizeOf(SpriteInstance),
                .usage = .{ .dynamic_update = true },
            });
        }
        
        // Create shader using the standard sokol approach
        const shader = sg.makeShader(shd.spriteShaderDesc(sg.queryBackend()));
        
        // Create sampler for texture sampling
        const sampler = sg.makeSampler(.{
            .min_filter = .LINEAR,
            .mag_filter = .LINEAR,
            .wrap_u = .CLAMP_TO_EDGE,
            .wrap_v = .CLAMP_TO_EDGE,
        });
        
        // Create pipeline
        var pip_desc = sg.PipelineDesc{
            .shader = shader,
            .color_count = 1,
        };
        pip_desc.colors[0].blend = .{
            .enabled = true,
            .src_factor_rgb = .SRC_ALPHA,
            .dst_factor_rgb = .ONE_MINUS_SRC_ALPHA,
        };
        
        // Vertex layout - must match shader attributes
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_pos] = .{ .format = .FLOAT2 }; // vertex position
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_inst_pos_size] = .{ .format = .FLOAT4, .buffer_index = 1 }; // instance pos_size
        pip_desc.layout.attrs[shd.ATTR_sprite_vs_a_inst_color] = .{ .format = .FLOAT4, .buffer_index = 1 }; // instance color
        pip_desc.layout.buffers[1].step_func = .PER_INSTANCE;
        
        const pipeline = sg.makePipeline(pip_desc);
        
        return SpriteRenderer{
            .allocator = allocator,
            .shader = shader,
            .pipeline = pipeline,
            .vertex_buffer = vertex_buffer,
            .instance_buffers = instance_buffers,
            .sampler = sampler,
            .textures = std.ArrayList(sg.Image).init(allocator),
            .sprites = std.ArrayList(Sprite).init(allocator),
        };
    }
    
    pub fn deinit(self: *SpriteRenderer) void {
        sg.destroyBuffer(self.vertex_buffer);
        for (self.instance_buffers) |buffer| {
            sg.destroyBuffer(buffer);
        }
        sg.destroyPipeline(self.pipeline);
        sg.destroyShader(self.shader);
        sg.destroySampler(self.sampler);
        
        for (self.textures.items) |texture| {
            sg.destroyImage(texture);
        }
        self.textures.deinit();
        self.sprites.deinit();
    }
    
    pub fn loadTexture(self: *SpriteRenderer, image: assets.Image) !u32 {
        const sg_image = sg.makeImage(.{
            .width = @intCast(image.width),
            .height = @intCast(image.height),
            .pixel_format = .RGBA8,
            .data = .{
                .subimage = .{
                    .{ .{ .ptr = image.data.ptr, .size = image.data.len }, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                    .{ .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                },
            },
        });
        
        try self.textures.append(sg_image);
        const texture_id = @as(u32, @intCast(self.textures.items.len - 1));
        std.debug.print("Loaded texture {} ({}x{}) at index {}\n", .{ self.textures.items.len, image.width, image.height, texture_id });
        return texture_id;
    }
    
    pub fn drawSprite(self: *SpriteRenderer, sprite: Sprite) !void {
        try self.sprites.append(sprite);
    }
    
    pub fn render(self: *SpriteRenderer, projection: [16]f32) void {
        if (self.sprites.items.len == 0) return;
        
        // Apply pipeline and uniforms once
        sg.applyPipeline(self.pipeline);
        sg.applyUniforms(shd.SLOT_vs_params, sg.asRange(&projection));
        
        // Render each texture group separately using different instance buffers
        for (0..self.textures.items.len) |texture_id| {
            // Collect only sprites for this texture
            var batch_instances: [MAX_SPRITES]SpriteInstance = undefined;
            var batch_count: u32 = 0;
            
            for (self.sprites.items) |sprite| {
                if (sprite.texture_id == texture_id) {
                    batch_instances[batch_count] = .{
                        .pos_size = .{ sprite.position.x, sprite.position.y, sprite.size.x, sprite.size.y },
                        .color = .{ sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a },
                    };
                    batch_count += 1;
                }
            }
            
            // Skip if no sprites use this texture
            if (batch_count == 0) continue;
            
            // Use a different instance buffer for each texture to avoid conflicts
            const buffer_index = texture_id % self.instance_buffers.len;
            const current_buffer = self.instance_buffers[buffer_index];
            
            // Update buffer with only this batch's instances
            const batch_data = batch_instances[0..batch_count];
            sg.updateBuffer(current_buffer, sg.asRange(batch_data));
            
            // Bind this texture and the corresponding instance buffer
            sg.applyBindings(.{
                .vertex_buffers = .{ self.vertex_buffer, current_buffer, .{}, .{}, .{}, .{}, .{}, .{} },
                .images = .{ self.textures.items[texture_id], .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
                .samplers = .{ self.sampler, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{}, .{} },
            });
            
            // Draw only this batch
            sg.draw(0, 6, @intCast(batch_count));
        }
        
        // Clear for next frame
        self.sprites.clearRetainingCapacity();
    }
};