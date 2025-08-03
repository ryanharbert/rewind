const { ECS, EntityLimit } = require('./bitset-ecs-optimized.js');

// Component types (matching Zig test)
const Transform = Symbol('Transform');
const Velocity = Symbol('Velocity');
const Health = Symbol('Health');

// Optimized system that updates transforms based on velocity
function updateTransformSystem(ecs) {
    const query = ecs.query([Transform, Velocity]);
    const deltaTime = ecs.currentFrame.deltaTime;
    
    let result;
    while ((result = query.next()) !== null) {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        
        // Update position
        transform.x += velocity.dx * deltaTime;
        transform.y += velocity.dy * deltaTime;
        transform.rotation += velocity.angular * deltaTime;
        
        // Keep rotation in bounds (optimized)
        if (transform.rotation > 360.0) {
            transform.rotation -= 360.0;
        } else if (transform.rotation < 0.0) {
            transform.rotation += 360.0;
        }
    }
}

// Optimized damage system
function damageSystem(ecs) {
    const query = ecs.query([Health]);
    
    let result;
    while ((result = query.next()) !== null) {
        const health = result.get(Health);
        health.current--;
        if (health.current < 0) {
            health.current = health.max;
        }
    }
}

function main() {
    console.log('=== JavaScript Optimized Bitset ECS Performance Test ===');
    console.log('Testing with transform updates and damage system\n');
    
    // Test different entity counts (matching Zig test)
    const entityCounts = [100, 250, 500, 750, 1000];
    const frameCount = 10000; // Number of frames to simulate
    
    for (const entityCount of entityCounts) {
        console.log(`\n--- Testing ${entityCount} entities for ${frameCount} frames ---`);
        
        // Initialize ECS
        const ecs = new ECS({
            components: [Transform, Velocity, Health],
            maxEntities: EntityLimit.large // 1024 entities
        });
        
        const setupStart = Date.now();
        
        // Create entities with pre-allocated objects
        for (let i = 0; i < entityCount; i++) {
            const entity = ecs.createEntity();
            
            // All entities get transform
            ecs.addComponent(entity, Transform, {
                x: i % 100,
                y: Math.floor(i / 100),
                rotation: 0.0
            });
            
            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                ecs.addComponent(entity, Velocity, {
                    dx: ((i % 10) - 5) * 10.0,
                    dy: ((i % 7) - 3) * 10.0,
                    angular: i % 360
                });
            }
            
            // 40% get health
            if (i % 5 < 2) {
                ecs.addComponent(entity, Health, {
                    current: 100,
                    max: 100
                });
            }
        }
        
        const setupTime = Date.now() - setupStart;
        
        // Warm up with more iterations for JIT optimization
        for (let i = 0; i < 1000; i++) {
            ecs.update({ deltaTime: 0.016 }, 0.016, 0.0);
            updateTransformSystem(ecs);
            damageSystem(ecs);
        }
        
        // Force garbage collection before benchmark if available
        if (global.gc) {
            global.gc();
        }
        
        // Benchmark with high-resolution timer
        const benchStart = process.hrtime.bigint();
        
        for (let frameNum = 0; frameNum < frameCount; frameNum++) {
            ecs.update({ deltaTime: 0.016 }, 0.016, frameNum * 0.016);
            updateTransformSystem(ecs);
            damageSystem(ecs);
        }
        
        const benchEnd = process.hrtime.bigint();
        const benchTimeNs = benchEnd - benchStart;
        const benchTimeMs = Number(benchTimeNs) / 1_000_000;
        const avgFrameTime = benchTimeMs / frameCount;
        
        // Count entities with each component for verification
        const transformCount = ecs.query([Transform]).count();
        const velocityCount = ecs.query([Velocity]).count();
        const healthCount = ecs.query([Health]).count();
        
        console.log(`Setup time: ${setupTime}ms`);
        console.log(`Total benchmark time: ${benchTimeMs.toFixed(2)}ms`);
        console.log(`Average frame time: ${avgFrameTime.toFixed(3)}ms`);
        console.log(`FPS: ${(1000.0 / avgFrameTime).toFixed(1)}`);
        console.log(`Entities - Transform: ${transformCount}, Velocity: ${velocityCount}, Health: ${healthCount}`);
    }
    
    console.log('\n=== End of JavaScript Optimized Performance Test ===');
}

// Run the test
main();