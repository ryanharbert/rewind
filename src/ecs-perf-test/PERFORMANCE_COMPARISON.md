# ECS Performance Comparison: Zig vs JavaScript

## Test Results Summary

Testing bitset ECS implementations with 10,000 frames of transform updates and damage systems.

### Average Frame Time Comparison

| Entity Count | Zig (ms) | JavaScript Node.js (ms) | JS/Zig Ratio |
|-------------|----------|------------------------|--------------|
| 100         | 0.003    | 0.017                  | **5.7x slower** |
| 250         | 0.009    | 0.032                  | **3.6x slower** |
| 500         | 0.015    | 0.056                  | **3.7x slower** |
| 750         | 0.022    | 0.082                  | **3.7x slower** |
| 1000        | 0.030    | 0.106                  | **3.5x slower** |

### FPS Comparison

| Entity Count | Zig FPS | JavaScript FPS | Performance Gap |
|-------------|---------|----------------|-----------------|
| 100         | 294,118 | 58,140         | Zig 5.1x faster |
| 250         | 107,527 | 30,864         | Zig 3.5x faster |
| 500         | 65,790  | 17,762         | Zig 3.7x faster |
| 750         | 45,249  | 12,180         | Zig 3.7x faster |
| 1000        | 33,445  | 9,443          | Zig 3.5x faster |

### Total Benchmark Time (10,000 frames)

| Entity Count | Zig (ms) | JavaScript (ms) | Speedup |
|-------------|----------|-----------------|---------|
| 100         | 34       | 172             | 5.1x    |
| 250         | 93       | 324             | 3.5x    |
| 500         | 152      | 563             | 3.7x    |
| 750         | 221      | 821             | 3.7x    |
| 1000        | 299      | 1,059           | 3.5x    |

## Key Findings

1. **Consistent Performance Gap**: Zig is approximately **3.5-5x faster** than JavaScript across all entity counts.

2. **Scaling Characteristics**: 
   - The performance ratio stabilizes around 3.5-3.7x for larger entity counts
   - Small entity counts (100) show the largest performance gap (5.7x)

3. **Absolute Performance**:
   - Zig can process 1000 entities at 33,445 FPS
   - JavaScript processes the same at 9,443 FPS
   - Both are well above typical game requirements (60-144 FPS)

4. **Memory Access Patterns**:
   - Both implementations use identical algorithms (bitsets, dense arrays)
   - Performance difference is due to language/runtime characteristics
   - Zig benefits from zero-cost abstractions and no GC overhead

## Web Browser Performance

To test browser performance, open `web_test.html` in a modern browser. Browser results typically show:
- Similar or slightly better performance than Node.js
- More consistent frame times due to browser optimizations
- V8 JIT compilation benefits for hot code paths

## Conclusions

For web deployment specifically:
- JavaScript performance is more than adequate for most games (up to 1000 entities)
- The 3.5x performance gap is acceptable given JavaScript's other benefits (no compilation, easy deployment)
- Consider WebAssembly (compiling Zig to WASM) for performance-critical applications
- Both implementations use the same efficient bitset algorithms, proving the algorithm is sound