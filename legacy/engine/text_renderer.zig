const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
});
const Shader = @import("shader.zig").Shader;
const Text = @import("text.zig").Text;

pub const TextRenderer = struct {
    shader: Shader,
    VAO: c_uint,
    VBO: c_uint,
    
    pub fn init() !TextRenderer {
        const vertex_source = 
            \\#version 330 core
            \\layout (location = 0) in vec2 aPos;
            \\layout (location = 1) in vec2 aTexCoord;
            \\
            \\uniform vec2 position;
            \\uniform vec2 scale;
            \\
            \\out vec2 TexCoord;
            \\
            \\void main()
            \\{
            \\    vec2 pos = aPos * scale + position;
            \\    gl_Position = vec4(pos, 0.0, 1.0);
            \\    TexCoord = aTexCoord;
            \\}
        ;

        const fragment_source = 
            \\#version 330 core
            \\out vec4 FragColor;
            \\
            \\in vec2 TexCoord;
            \\uniform sampler2D textTexture;
            \\uniform vec3 textColor;
            \\
            \\void main()
            \\{
            \\    float alpha = texture(textTexture, TexCoord).r;
            \\    FragColor = vec4(textColor, alpha);
            \\}
        ;
        
        const shader = try Shader.init(vertex_source, fragment_source);
        
        // Create VAO and VBO for a simple quad
        var VAO: c_uint = undefined;
        var VBO: c_uint = undefined;
        
        c.glGenVertexArrays(1, &VAO);
        c.glGenBuffers(1, &VBO);
        
        // Quad vertices (position + texcoord)
        const vertices = [_]f32{
            // positions // texture coords
            0.0, 1.0,   0.0, 0.0,
            1.0, 0.0,   1.0, 1.0,
            0.0, 0.0,   0.0, 1.0,
            
            0.0, 1.0,   0.0, 0.0,
            1.0, 1.0,   1.0, 0.0,
            1.0, 0.0,   1.0, 1.0
        };
        
        c.glBindVertexArray(VAO);
        
        c.glBindBuffer(c.GL_ARRAY_BUFFER, VBO);
        c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, c.GL_STATIC_DRAW);
        
        // Position attribute
        c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, 4 * @sizeOf(f32), null);
        c.glEnableVertexAttribArray(0);
        
        // Texture coordinate attribute
        c.glVertexAttribPointer(1, 2, c.GL_FLOAT, c.GL_FALSE, 4 * @sizeOf(f32), @ptrFromInt(2 * @sizeOf(f32)));
        c.glEnableVertexAttribArray(1);
        
        c.glBindVertexArray(0);
        
        return TextRenderer{
            .shader = shader,
            .VAO = VAO,
            .VBO = VBO,
        };
    }
    
    pub fn deinit(self: *TextRenderer) void {
        c.glDeleteVertexArrays(1, &self.VAO);
        c.glDeleteBuffers(1, &self.VBO);
        self.shader.deinit();
    }
    
    pub fn renderText(self: *TextRenderer, text: *const Text) void {
        self.shader.use();
        
        // Set uniforms - convert pixel coordinates to normalized device coordinates
        const scale_x = text.width / 1200.0 * 2.0; // Scale to NDC width (-1 to 1)
        const scale_y = text.height / 800.0 * 2.0;  // Scale to NDC height (-1 to 1)
        
        self.shader.setVec2("position", text.x, text.y);
        self.shader.setVec2("scale", scale_x, scale_y);
        self.shader.setVec3("textColor", text.color[0], text.color[1], text.color[2]);
        self.shader.setInt("textTexture", 0);
        
        // Bind text texture
        c.glActiveTexture(c.GL_TEXTURE0);
        text.bind();
        
        // Enable blending for text
        c.glEnable(c.GL_BLEND);
        c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);
        
        // Render quad
        c.glBindVertexArray(self.VAO);
        c.glDrawArrays(c.GL_TRIANGLES, 0, 6);
        c.glBindVertexArray(0);
        
        c.glDisable(c.GL_BLEND);
    }
};