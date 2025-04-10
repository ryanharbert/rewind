# Rewind Game Engine

A high-performance game engine written in Zig, designed for fast iteration and deterministic networking.

## Goals

- **Performance**: Built in Zig for maximum performance and minimal overhead
- **Deterministic**: Built-in support for deterministic physics and rollback networking
- **Fast Iteration**: Quick build times and hot-reloading capabilities
- **ECS Architecture**: Entity Component System for efficient game object management
- **Developer Friendly**: Clean API and comprehensive documentation

## Project Structure

```
src/
├── platform/       # Platform-specific systems
│   ├── window/     # Window management
│   └── input/      # Input handling
├── rendering/      # Rendering systems
│   ├── gl/         # OpenGL implementation
│   └── shader/     # Shader management
├── physics/        # Physics systems
│   ├── collision/  # Collision detection
│   └── dynamics/   # Physics simulation
├── networking/     # Networking systems
│   ├── rollback/   # Rollback networking
│   └── snapshot/   # State snapshots
├── game/           # Game-specific systems
│   ├── components/ # Built-in components
│   ├── systems/    # Built-in systems
│   └── scene/      # Scene management
└── demo/           # Example implementations
```

## Development Plan

1. **Platform Systems**
   - [x] Window management
   - [x] Basic input handling
   - [ ] Mouse input
   - [ ] Controller support

2. **Rendering**
   - [x] Basic OpenGL integration
   - [ ] Shader management
   - [ ] Material system
   - [ ] Camera system

3. **Physics**
   - [ ] Collision detection
   - [ ] Physics simulation
   - [ ] Deterministic physics

4. **Networking**
   - [ ] Basic networking
   - [ ] State synchronization
   - [ ] Rollback system

5. **Game Systems**
   - [ ] Scene management
   - [ ] Audio system
   - [ ] Asset management

## Building

```bash
zig build run
```

## Testing

```bash
zig build test
```

## License

MIT License 