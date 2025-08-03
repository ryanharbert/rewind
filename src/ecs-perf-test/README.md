# ECS Performance Test: Zig vs JavaScript

This directory contains performance comparison tests between the Zig bitset ECS implementation and an equivalent JavaScript implementation.

## Test Overview

Both implementations test the same scenario:
- Creating entities with Transform, Velocity, and Health components
- Running two systems per frame:
  - Transform update system (applies velocity to position)
  - Damage system (decrements health)
- Testing with 100, 250, 500, 750, and 1000 entities
- Running 10,000 frames per test

## Files

- `zig_perf_test.zig` - Zig performance test using src/rewind/ecs.zig
- `bitset-ecs.js` - JavaScript implementation of bitset ECS (mirrors Zig version)
- `js_perf_test.js` - Node.js performance test
- `web_test.html` - Browser-based performance test
- `build.zig` - Build configuration for Zig test

## Running the Tests

### Zig Test (Release Mode)
```bash
cd src/ecs-perf-test
zig build -Doptimize=ReleaseFast
zig-out/bin/zig_perf_test
```

### JavaScript Test (Node.js)
```bash
cd src/ecs-perf-test
node js_perf_test.js
```

### JavaScript Test (Web Browser)
1. Open `web_test.html` in a modern web browser
2. Click "Run Performance Test"
3. Results will be displayed on the page

## Key Differences to Note

1. **Memory Management**: Zig uses explicit allocation with cleanup, JavaScript uses garbage collection
2. **Type Safety**: Zig has compile-time type checking, JavaScript is dynamically typed
3. **Optimization**: Zig ReleaseFast mode enables aggressive optimizations similar to C++
4. **Precision**: JavaScript uses `Date.now()` or `performance.now()` vs Zig's `milliTimestamp()`

## Expected Results

Based on the previous analysis, we expect:
- Zig to be significantly faster in ReleaseFast mode
- JavaScript performance to vary between Node.js and browser environments
- The performance gap to be most noticeable with higher entity counts

## Implementation Details

Both implementations use:
- Bitsets for entity tracking (Uint32Array in JavaScript)
- Dense arrays for component storage
- Fixed entity-to-component index mapping
- Bitwise AND operations for query filtering
- O(1) component addition/removal