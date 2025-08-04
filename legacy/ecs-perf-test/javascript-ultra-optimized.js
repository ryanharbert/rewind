// Ultra-optimized JavaScript ECS implementation using Structure of Arrays and TypedArrays

class UltraOptimizedBitSet {
    constructor(size) {
        this.size = size;
        this.words = new Uint32Array(Math.ceil(size / 32));
        this.wordCount = this.words.length;
    }

    set(index) {
        if (index >= this.size) return;
        const wordIndex = index >>> 5; // Bit shift instead of division by 32
        const bitIndex = index & 31;   // Bit mask instead of modulus 32
        this.words[wordIndex] |= 1 << bitIndex;
    }

    isSet(index) {
        if (index >= this.size) return false;
        const wordIndex = index >>> 5;
        const bitIndex = index & 31;
        return (this.words[wordIndex] & (1 << bitIndex)) !== 0;
    }

    clear() {
        this.words.fill(0);
    }

    // Triple intersection with manual bit operations
    tripleIntersection(set1, set2, set3) {
        const minLen = Math.min(this.wordCount, set1.wordCount, set2.wordCount, set3.wordCount);
        
        for (let i = 0; i < minLen; i++) {
            this.words[i] = set1.words[i] & set2.words[i] & set3.words[i];
        }
        
        // Clear remaining words
        for (let i = minLen; i < this.wordCount; i++) {
            this.words[i] = 0;
        }
    }

    // Manual word iteration for maximum performance (Zig-style)
    forEachEntityFast(callback) {
        const words = this.words;
        const wordCount = this.wordCount;
        
        for (let wordIndex = 0; wordIndex < wordCount; wordIndex++) {
            let word = words[wordIndex];
            if (word === 0) continue;
            
            const baseEntity = wordIndex << 5; // Multiply by 32
            
            // Manual bit scanning using bit manipulation tricks
            while (word !== 0) {
                // Find trailing zero count using Math.clz32 trick
                const bitIndex = 31 - Math.clz32((~word) & (word - 1));
                callback(baseEntity + bitIndex);
                word &= word - 1; // Clear lowest bit
            }
        }
    }
}

// Ultra-optimized ECS using Structure of Arrays
class UltraOptimizedECS {
    constructor(maxEntities) {
        this.maxEntities = maxEntities;
        this.nextEntity = 0;
        
        // Structure of Arrays for better cache performance
        // Transform components
        this.transform_x = new Float32Array(maxEntities);
        this.transform_y = new Float32Array(maxEntities);
        this.transform_z = new Float32Array(maxEntities);
        this.transform_rotationX = new Float32Array(maxEntities);
        this.transform_rotationY = new Float32Array(maxEntities);
        this.transform_rotationZ = new Float32Array(maxEntities);
        
        // Velocity components
        this.velocity_dx = new Float32Array(maxEntities);
        this.velocity_dy = new Float32Array(maxEntities);
        this.velocity_dz = new Float32Array(maxEntities);
        
        // Health components
        this.health_value = new Float32Array(maxEntities);
        
        // Bitsets for component presence
        this.activeBitset = new UltraOptimizedBitSet(maxEntities);
        this.transformBitset = new UltraOptimizedBitSet(maxEntities);
        this.velocityBitset = new UltraOptimizedBitSet(maxEntities);
        this.healthBitset = new UltraOptimizedBitSet(maxEntities);
        
        // Pre-allocated query cache
        this.queryCache = new UltraOptimizedBitSet(maxEntities);
    }

    createEntity() {
        const entity = this.nextEntity++;
        this.activeBitset.set(entity);
        return entity;
    }

    addTransform(entity, x, y, z, rotX = 0, rotY = 0, rotZ = 0) {
        this.transform_x[entity] = x;
        this.transform_y[entity] = y;
        this.transform_z[entity] = z;
        this.transform_rotationX[entity] = rotX;
        this.transform_rotationY[entity] = rotY;
        this.transform_rotationZ[entity] = rotZ;
        this.transformBitset.set(entity);
    }

    addVelocity(entity, dx, dy, dz) {
        this.velocity_dx[entity] = dx;
        this.velocity_dy[entity] = dy;
        this.velocity_dz[entity] = dz;
        this.velocityBitset.set(entity);
    }

    addHealth(entity, value) {
        this.health_value[entity] = value;
        this.healthBitset.set(entity);
    }

    // Ultra-fast transform system with manual bitset iteration
    updateTransformSystem() {
        // Triple intersection directly into cache
        this.queryCache.tripleIntersection(
            this.activeBitset,
            this.transformBitset,
            this.velocityBitset
        );

        // Cache array references for maximum performance
        const words = this.queryCache.words;
        const wordCount = this.queryCache.wordCount;
        const transform_x = this.transform_x;
        const transform_y = this.transform_y;
        const transform_z = this.transform_z;
        const transform_rotationX = this.transform_rotationX;
        const transform_rotationY = this.transform_rotationY;
        const transform_rotationZ = this.transform_rotationZ;
        const velocity_dx = this.velocity_dx;
        const velocity_dy = this.velocity_dy;
        const velocity_dz = this.velocity_dz;

        // Manual word iteration for maximum speed
        for (let wordIndex = 0; wordIndex < wordCount; wordIndex++) {
            let word = words[wordIndex];
            if (word === 0) continue;

            const baseEntity = wordIndex << 5;

            while (word !== 0) {
                const bitIndex = 31 - Math.clz32((~word) & (word - 1));
                const entity = baseEntity + bitIndex;

                // Direct array access - maximum performance
                transform_x[entity] += velocity_dx[entity];
                transform_y[entity] += velocity_dy[entity];
                transform_z[entity] += velocity_dz[entity];
                transform_rotationX[entity] += 0.01;
                transform_rotationY[entity] += 0.02;
                transform_rotationZ[entity] += 0.03;

                word &= word - 1;
            }
        }
    }

    // Ultra-fast damage system
    updateDamageSystem() {
        // Intersection for health entities
        this.queryCache.tripleIntersection(
            this.activeBitset,
            this.healthBitset,
            this.healthBitset
        );

        const words = this.queryCache.words;
        const wordCount = this.queryCache.wordCount;
        const health_value = this.health_value;

        for (let wordIndex = 0; wordIndex < wordCount; wordIndex++) {
            let word = words[wordIndex];
            if (word === 0) continue;

            const baseEntity = wordIndex << 5;

            while (word !== 0) {
                const bitIndex = 31 - Math.clz32((~word) & (word - 1));
                const entity = baseEntity + bitIndex;

                health_value[entity] -= 1.0;
                if (health_value[entity] <= 0) {
                    health_value[entity] = 100.0;
                }

                word &= word - 1;
            }
        }
    }
}

// Performance test function
function runPerformanceTest() {
    console.log("=== JavaScript Ultra-Optimized ECS Performance Test ===");
    console.log("Testing with Structure of Arrays and manual bitset iteration\n");

    const entityCounts = [100, 250, 500, 750, 1000];
    const frameCount = 10000;

    for (const entityCount of entityCounts) {
        console.log(`\n--- Testing ${entityCount} entities for ${frameCount} frames ---`);

        // Setup
        const setupStart = performance.now();
        const ecs = new UltraOptimizedECS(entityCount + 100);

        // Create entities
        for (let i = 0; i < entityCount; i++) {
            const entity = ecs.createEntity();

            // All entities get transform
            ecs.addTransform(entity, i % 100, Math.floor(i / 100), 0, 0, 0, 0);

            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                ecs.addVelocity(entity, 1.0, 0.5, 0.25);
            }

            // 40% get health
            if (i % 5 < 2) {
                ecs.addHealth(entity, 100.0);
            }
        }

        const setupTime = performance.now() - setupStart;

        // Warmup
        for (let i = 0; i < 100; i++) {
            ecs.updateTransformSystem();
            ecs.updateDamageSystem();
        }

        // Benchmark
        const benchmarkStart = performance.now();
        for (let i = 0; i < frameCount; i++) {
            ecs.updateTransformSystem();
            ecs.updateDamageSystem();
        }
        const benchmarkTime = performance.now() - benchmarkStart;

        const avgFrameTime = benchmarkTime / frameCount;
        const fps = 1000 / avgFrameTime;

        console.log(`Setup time: ${setupTime.toFixed(2)}ms`);
        console.log(`Total benchmark time: ${benchmarkTime.toFixed(2)}ms`);
        console.log(`Average frame time: ${avgFrameTime.toFixed(3)}ms`);
        console.log(`FPS: ${fps.toFixed(1)}`);
    }

    console.log("\n=== End of JavaScript Ultra-Optimized Performance Test ===");
}

// Run the test if this script is executed directly
if (typeof window === 'undefined') {
    // Node.js environment
    runPerformanceTest();
} else {
    // Browser environment - expose functions globally
    window.UltraOptimizedECS = UltraOptimizedECS;
    window.runPerformanceTest = runPerformanceTest;
    console.log("Ultra-optimized ECS loaded. Call runPerformanceTest() to run the benchmark.");
}