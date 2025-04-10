# Grapefruit Game Engine

A lightweight game engine built with Zig and OpenGL, focusing on simplicity and learning.

## Current Features

- OpenGL rendering pipeline using GLFW and GLAD
- 3D sphere rendering with dynamic movement
- Screen-relative sizing and bounds
- Keyboard controls (WASD/Arrow keys)
- Window resize handling with proper aspect ratio maintenance

## Controls

- W/Up Arrow: Move up
- S/Down Arrow: Move down
- A/Left Arrow: Move left
- D/Right Arrow: Move right
- ESC: Exit game

## Project Goals

- Learn and explore Zig for game development
- Create a minimal but functional game engine
- Understand OpenGL and graphics programming concepts
- Keep dependencies simple and self-contained
- Focus on cross-platform compatibility (future)

## Development Requirements

- [Zig](https://ziglang.org/) compiler
- Windows (currently Windows-only, cross-platform support planned)

That's it! All other dependencies (GLFW, GLAD) are included in the repository.

## Project Structure

```
.
├── src/
│   └── main.zig        # Main game engine code
├── deps/
│   ├── glad/           # GLAD OpenGL loader
│   └── glfw/           # GLFW headers
├── libs/
│   └── glfw3dll.dll    # GLFW binary
├── build.zig           # Build configuration
└── .gitignore
```

## Building and Running

1. Clone the repository:
```bash
git clone https://github.com/ryanharbert/grapefruit.git
cd grapefruit
```

2. Build and run:
```bash
zig build run
```

## End Users

For users who just want to play the game:
- Windows required
- No additional installations needed
- Just run the executable

## Implementation Details

- Written in Zig
- Uses OpenGL for rendering
- GLFW for window management and input
- GLAD for OpenGL function loading
- All dependencies are vendored (no external installations required)

## Current Status

The engine currently demonstrates:
- Basic 3D rendering
- Window management
- Input handling
- Screen-relative object sizing
- Proper aspect ratio handling
- Collision detection with screen bounds

## Future Plans

- [ ] Cross-platform support (Linux, macOS)
- [ ] More geometric primitives
- [ ] Texture support
- [ ] Basic physics
- [ ] Scene management
- [ ] Asset loading
- [ ] Sound support

## Contributing

Feel free to open issues or submit pull requests. The project is in early stages and welcomes contributions!

## License

MIT License - See LICENSE file for details 