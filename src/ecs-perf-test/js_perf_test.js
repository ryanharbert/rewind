const { ECS, EntityLimit } = require('./bitset-ecs.js');

// Component types (matching Zig test)
const Transform = Symbol('Transform');
const Velocity = Symbol('Velocity');
const Health = Symbol('Health');

// System that updates transforms based on velocity
function updateTransformSystem(ecs) {
    const query = ecs.query([Transform, Velocity]);
    
    let result;
    while ((result = query.next()) !== null) {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        
        // Update position
        transform.x += velocity.dx * ecs.currentFrame.deltaTime;
        transform.y += velocity.dy * ecs.currentFrame.deltaTime;
        transform.rotation += velocity.angular * ecs.currentFrame.deltaTime;
        
        // Keep rotation in bounds
        if (transform.rotation > 360.0) transform.rotation -= 360.0;
        if (transform.rotation < 0.0) transform.rotation += 360.0;
    }
}

// System that applies damage over time
function damageSystem(ecs) {
    const query = ecs.query([Health]);
    
    let result;
    while ((result = query.next()) !== null) {
        const health = result.get(Health);
        health.current -= 1;
        if (health.current < 0) health.current = health.max;
    }
}

function main() {
    console.log('=== JavaScript Bitset ECS Performance Test ===');
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
        
        // Create entities
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
        
        // Warm up
        for (let i = 0; i < 100; i++) {
            ecs.update({ deltaTime: 0.016 }, 0.016, 0.0);
            updateTransformSystem(ecs);
            damageSystem(ecs);
        }
        
        // Benchmark
        const benchStart = Date.now();
        
        for (let frameNum = 0; frameNum < frameCount; frameNum++) {
            ecs.update({ deltaTime: 0.016 }, 0.016, frameNum * 0.016);
            updateTransformSystem(ecs);
            damageSystem(ecs);
        }
        
        const benchTime = Date.now() - benchStart;
        const avgFrameTime = benchTime / frameCount;
        
        // Count entities with each component for verification
        const transformCount = ecs.query([Transform]).count();
        const velocityCount = ecs.query([Velocity]).count();
        const healthCount = ecs.query([Health]).count();
        
        console.log(`Setup time: ${setupTime}ms`);
        console.log(`Total benchmark time: ${benchTime}ms`);
        console.log(`Average frame time: ${avgFrameTime.toFixed(3)}ms`);
        console.log(`FPS: ${(1000.0 / avgFrameTime).toFixed(1)}`);
        console.log(`Entities - Transform: ${transformCount}, Velocity: ${velocityCount}, Health: ${healthCount}`);
    }
    
    console.log('\n=== End of JavaScript Performance Test ===');
}

// Run the test
main();