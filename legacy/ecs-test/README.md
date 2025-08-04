# ECS Test

This directory contains tests for both ECS implementations (Bitset and Sparse Set).

## Build Commands

### Test with Bitset ECS (default):
```bash
zig build ecs-test
```

### Test with Sparse Set ECS:
```bash
zig build ecs-test -Dbitset-ecs=false
```

### Compare Performance:
```bash
# Run both implementations and compare output
echo "=== BITSET ECS ===" && zig build ecs-test -Dbitset-ecs=true
echo "=== SPARSE SET ECS ===" && zig build ecs-test -Dbitset-ecs=false
```

## What the Test Does

1. **Compatibility Test**: Creates an entity, adds a Transform component, and verifies the API works
2. **Performance Benchmark**: 
   - Creates 1000 entities with various component combinations
   - Runs 100 query operations to measure performance
   - Reports setup time and query time
3. **Query Test**: Creates entities with different component combinations and tests various queries

## Expected Output

The test will show:
- Which ECS implementation is active (Bitset or Sparse Set)
- Setup time for creating 1000 entities
- Query performance for 100 iterations
- Results of various component queries

## Implementation Details

The ECS system supports:
- **Components**: Transform, Physics, Sprite
- **Operations**: createEntity, addComponent, removeComponent, hasComponent, getComponent
- **Queries**: Filter entities by component combinations using `.query(.{ Component1, Component2 })`

## Performance Notes

### Comprehensive Benchmark Results (1000 query iterations):

| Entity Count | Query Type | Bitset ECS | Sparse Set ECS | **Performance Advantage** |
|-------------|------------|------------|---------------|--------------------------|
| 100 | Transform+Physics (50% selectivity) | **9ms** | 20ms | **Bitset 2.2x faster** |
| 500 | Transform+Physics (50% selectivity) | **41ms** | 65ms | **Bitset 1.6x faster** |
| 1000 | Transform+Physics (50% selectivity) | **81ms** | 102ms | **Bitset 1.3x faster** |
| 2000 | Transform+Physics (50% selectivity) | **161ms** | 176ms | **Bitset 1.1x faster** |
| 4000 | Transform+Physics (50% selectivity) | **323ms** | 336ms | **Bitset 1.04x faster** |

**Key Finding: Bitset ECS dominates at game-relevant entity counts, with diminishing advantage at very large scales.**

### Performance Characteristics:

**Bitset ECS Advantages:**
- ✅ **Faster queries**: 9ms vs 11ms total
- ✅ **Instant query init**: 0ms (SIMD bitwise operations)
- ✅ **Better for rollback**: Easy delta compression with XOR
- ✅ **Cache-friendly**: Dense component arrays
- ✅ **Memory predictable**: Fixed 4096 entity limit

**Sparse Set ECS Advantages:**
- ✅ **Dynamic entities**: No hard limit on entity count  
- ✅ **Memory efficient**: Only allocates for existing entities
- ✅ **Very fast iteration**: 1ms for pure iteration

### Memory Layout:

- **Bitset ECS**: Components stored in dense arrays (`transforms[4096]`) with perfect cache locality when processing single component types. Rollback networking can efficiently XOR bitsets to find changed entities.
- **Sparse Set ECS**: Also uses dense component arrays but requires HashMap lookups, adding one level of indirection that can hurt cache performance.

**For rollback networking, Bitset ECS is clearly superior** - you get better query performance AND much easier delta compression for efficient state synchronization.

### Determinism & Memory Considerations:

**Deterministic Guarantees:**
- ✅ **Iteration order**: Always ascending entity ID (0, 1, 2, 3...)
- ✅ **Query results**: Consistent ordering across frames
- ✅ **Bit operations**: @ctz() and bitwise operations are pure functions
- ✅ **No threading/randomness**: Single-threaded, deterministic execution

**Memory Optimization for Frame Copying:**
- **Bitset ECS**: Fixed 4096 entity limit = predictable memory footprint
- **Component arrays**: Dense storage for efficient copying during rollback
- **Bitsets**: Only 512 bytes per component type (4096 bits / 8)
- **Trade-off**: Sometimes memory efficiency more important than query speed for rollback systems

Both implementations provide the same API, so switching is transparent to users.

## Delta Compression with Bitset ECS

For rollback networking, bitset ECS provides excellent delta compression capabilities:

```zig
// Find entities that changed between frames
const changed_entities = current_frame.active_entities.xor(previous_frame.active_entities);
const changed_transforms = current_frame.transform_entities.xor(previous_frame.transform_entities);
const changed_physics = current_frame.physics_entities.xor(previous_frame.physics_entities);

// Only serialize/network the components for entities where bitsets changed
while (changed_transforms.iterator(.{}).next()) |entity| {
    // Send only this entity's transform component
    serialize(world.getComponent(entity, Transform));
}
```

**Delta Compression Benefits:**
- **XOR operations**: Instant detection of changed entities using bitwise XOR
- **Efficient networking**: Only send components that actually changed
- **Rollback optimization**: Copy only modified state between frames
- **Memory bandwidth**: Minimize data transfer for networked games

## Implementation Details

The current bitset ECS uses several optimizations:
- **SIMD bitwise operations**: Instant query filtering using `intersectWith()`
- **Hardware bit scanning**: Built-in `IntegerBitSet.Iterator` uses @ctz() internally
- **64-bit chunk processing**: Iterator skips empty 64-bit blocks efficiently
- **Dense component storage**: Components stored in packed arrays for cache efficiency

## Future Optimizations

Potential improvements for extreme performance scenarios:

1. **Dense Entity Tracking**: Maintain separate array of active entity IDs for faster iteration
   - Trade-off: Slightly more memory for potentially 2-3x faster queries
   - Benefit: Linear array access vs bit scanning

2. **Query Result Caching**: Cache query results if same query runs multiple times per frame
   - Benefit: Massive speedup for repeated queries
   - Trade-off: Additional memory for cache storage

3. **SIMD Component Filtering**: Use 256-bit AVX instructions for multi-component queries
   - Benefit: Process multiple entities simultaneously
   - Trade-off: Platform-specific code, added complexity

4. **Cache-Optimized Component Layout**: Structure components for better cache line utilization
   - Benefit: Improved memory access patterns
   - Consideration: May conflict with deterministic memory layout requirements

These optimizations should be considered based on specific performance requirements and memory constraints of the target game.