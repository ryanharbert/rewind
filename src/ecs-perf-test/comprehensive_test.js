const { ECS, EntityLimit } = require('./bitset-ecs-optimized.js');

// Component types
const Transform = Symbol('Transform');
const Velocity = Symbol('Velocity');
const Health = Symbol('Health');
const Collider = Symbol('Collider');
const AI = Symbol('AI');
const Renderable = Symbol('Renderable');

// Test scenarios
class TestScenario {
    constructor(name, setup, systems) {
        this.name = name;
        this.setup = setup;
        this.systems = systems;
    }
}

// Scenario 1: Heavy Query Test - Many small queries
function setupHeavyQuery(ecs, entityCount) {
    for (let i = 0; i < entityCount; i++) {
        const entity = ecs.createEntity();
        ecs.addComponent(entity, Transform, { x: i, y: 0, rotation: 0 });
        
        // Diverse component distribution
        if (i % 2 === 0) ecs.addComponent(entity, Velocity, { dx: 1, dy: 0, angular: 0 });
        if (i % 3 === 0) ecs.addComponent(entity, Health, { current: 100, max: 100 });
        if (i % 4 === 0) ecs.addComponent(entity, Collider, { radius: 10, layer: 1 });
        if (i % 5 === 0) ecs.addComponent(entity, AI, { state: 0, target: null });
        if (i % 6 === 0) ecs.addComponent(entity, Renderable, { spriteId: i, zOrder: 0 });
    }
}

function heavyQuerySystem(ecs) {
    // Multiple different queries per frame
    let q1 = ecs.query([Transform, Velocity]);
    while (q1.next()) {}
    
    let q2 = ecs.query([Transform, Health, Collider]);
    while (q2.next()) {}
    
    let q3 = ecs.query([Transform, AI]);
    while (q3.next()) {}
    
    let q4 = ecs.query([Transform, Renderable]);
    while (q4.next()) {}
    
    let q5 = ecs.query([Velocity, Collider, Health]);
    while (q5.next()) {}
}

// Scenario 2: Cache Miss Test - Random access patterns
function setupCacheMiss(ecs, entityCount) {
    for (let i = 0; i < entityCount; i++) {
        const entity = ecs.createEntity();
        ecs.addComponent(entity, Transform, { x: i, y: 0, rotation: 0 });
        ecs.addComponent(entity, Velocity, { dx: 1, dy: 0, angular: 0 });
        if (i % 3 === 0) ecs.addComponent(entity, Health, { current: 100, max: 100 });
    }
}

function cacheMissSystem(ecs) {
    const query = ecs.query([Transform, Velocity]);
    let seed = 42;
    
    // Simple pseudo-random number generator
    function random() {
        seed = (seed * 1664525 + 1013904223) >>> 0;
        return (seed >>> 0) / 0xFFFFFFFF;
    }
    
    let result;
    while ((result = query.next()) !== null) {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        
        // Simulate random memory access patterns
        const jump = Math.floor(random() * 11);
        for (let i = 0; i < jump; i++) {
            transform.x += velocity.dx * 0.001;
            transform.y += velocity.dy * 0.001;
        }
    }
}

// Scenario 3: Component Add/Remove Test
function setupDynamic(ecs, entityCount) {
    for (let i = 0; i < entityCount; i++) {
        const entity = ecs.createEntity();
        ecs.addComponent(entity, Transform, { x: i, y: 0, rotation: 0 });
    }
}

function dynamicSystem(ecs) {
    const query = ecs.query([Transform]);
    let count = 0;
    
    let result;
    while ((result = query.next()) !== null) {
        // Add/remove components dynamically
        if (count % 10 === 0) {
            if (!ecs.hasComponent(result.entity, Velocity)) {
                ecs.addComponent(result.entity, Velocity, { dx: 1, dy: 1, angular: 0 });
            } else {
                ecs.removeComponent(result.entity, Velocity);
            }
        }
        count++;
    }
}

// Scenario 4: Simple Transform Update (baseline)
function setupBaseline(ecs, entityCount) {
    for (let i = 0; i < entityCount; i++) {
        const entity = ecs.createEntity();
        ecs.addComponent(entity, Transform, { x: i, y: 0, rotation: 0 });
        ecs.addComponent(entity, Velocity, { dx: 1, dy: 1, angular: 1 });
    }
}

function baselineSystem(ecs) {
    const query = ecs.query([Transform, Velocity]);
    const deltaTime = ecs.currentFrame.deltaTime;
    
    let result;
    while ((result = query.next()) !== null) {
        const transform = result.get(Transform);
        const velocity = result.get(Velocity);
        transform.x += velocity.dx * deltaTime;
        transform.y += velocity.dy * deltaTime;
        transform.rotation += velocity.angular * deltaTime;
    }
}

function runScenario(scenario, entityCount, frameCount) {
    console.log(`\n  Scenario: ${scenario.name}`);
    
    const ecs = new ECS({
        components: [Transform, Velocity, Health, Collider, AI, Renderable],
        maxEntities: EntityLimit.large
    });
    
    // Setup
    const setupStart = Date.now();
    scenario.setup(ecs, entityCount);
    const setupTime = Date.now() - setupStart;
    
    // Warmup
    for (let i = 0; i < 100; i++) {
        ecs.update({ deltaTime: 0.016 }, 0.016, 0.0);
        for (const system of scenario.systems) {
            system(ecs);
        }
    }
    
    // Force GC if available
    if (global.gc) global.gc();
    
    // Benchmark
    const benchStart = process.hrtime.bigint();
    
    for (let i = 0; i < frameCount; i++) {
        ecs.update({ deltaTime: 0.016 }, 0.016, 0.0);
        for (const system of scenario.systems) {
            system(ecs);
        }
    }
    
    const benchEnd = process.hrtime.bigint();
    const benchTimeMs = Number(benchEnd - benchStart) / 1_000_000;
    const avgFrameTime = benchTimeMs / frameCount;
    
    console.log(`    Setup: ${setupTime}ms, Total: ${benchTimeMs.toFixed(0)}ms, Avg frame: ${avgFrameTime.toFixed(3)}ms, FPS: ${(1000.0 / avgFrameTime).toFixed(1)}`);
}

function main() {
    console.log('=== Comprehensive ECS Performance Test (JavaScript) ===');
    
    const scenarios = [
        new TestScenario('Baseline (Transform+Velocity)', setupBaseline, [baselineSystem]),
        new TestScenario('Heavy Queries (5 different queries)', setupHeavyQuery, [heavyQuerySystem]),
        new TestScenario('Cache Miss Pattern', setupCacheMiss, [cacheMissSystem]),
        new TestScenario('Dynamic Add/Remove', setupDynamic, [dynamicSystem]),
    ];
    
    const entityCounts = [100, 500, 1000];
    const frameCount = 5000;
    
    for (const entityCount of entityCounts) {
        console.log(`\n--- ${entityCount} Entities, ${frameCount} Frames ---`);
        
        for (const scenario of scenarios) {
            runScenario(scenario, entityCount, frameCount);
        }
    }
    
    console.log('\n=== End of Comprehensive Test ===');
}

main();