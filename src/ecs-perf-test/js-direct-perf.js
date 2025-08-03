// JavaScript Direct Access ECS Performance Test (C# equivalent)

const MAX_ENTITIES = 1024;

// High-performance bitset using Uint32Array
class BitSet {
    constructor(size) {
        this.size = size;
        this.words = new Uint32Array(Math.ceil(size / 32));
    }
    
    set(index) {
        if (index >= this.size) return;
        const wordIndex = Math.floor(index / 32);
        const bitIndex = index % 32;
        this.words[wordIndex] |= (1 << bitIndex);
    }
    
    unset(index) {
        if (index >= this.size) return;
        const wordIndex = Math.floor(index / 32);
        const bitIndex = index % 32;
        this.words[wordIndex] &= ~(1 << bitIndex);
    }
    
    isSet(index) {
        if (index >= this.size) return false;
        const wordIndex = Math.floor(index / 32);
        const bitIndex = index % 32;
        return (this.words[wordIndex] & (1 << bitIndex)) !== 0;
    }
    
    intersectWith(other) {
        const result = new BitSet(this.size);
        const minLen = Math.min(this.words.length, other.words.length);
        for (let i = 0; i < minLen; i++) {
            result.words[i] = this.words[i] & other.words[i];
        }
        return result;
    }
    
    // Direct iteration like C# foreach
    forEach(callback) {
        for (let wordIndex = 0; wordIndex < this.words.length; wordIndex++) {
            let word = this.words[wordIndex];
            if (word === 0) continue;
            
            const baseIndex = wordIndex * 32;
            while (word !== 0) {
                const bitIndex = Math.clz32((~word) & (word - 1)) ^ 31; // trailing zeros
                const entity = baseIndex + bitIndex;
                callback(entity);
                word &= word - 1; // Clear lowest bit
            }
        }
    }
}

// Component types
class Transform {
    constructor(x = 0, y = 0, rotation = 0) {
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }
}

class Velocity {
    constructor(dx = 0, dy = 0, angular = 0) {
        this.dx = dx;
        this.dy = dy;
        this.angular = angular;
    }
}

class Health {
    constructor(current = 100, max = 100) {
        this.current = current;
        this.max = max;
    }
}

// Direct access component storage (like C# version)
class ComponentStorage {
    constructor() {
        this.denseArray = []; // Direct array like C#
        this.entityBitset = new BitSet(MAX_ENTITIES);
        this.entityToIndex = new Uint32Array(MAX_ENTITIES);
        this.indexToEntity = [];
        this.count = 0;
    }
    
    add(entity, component) {
        if (this.entityBitset.isSet(entity)) return;
        
        const index = this.count;
        this.denseArray.push(component); // Direct append like C#
        this.indexToEntity.push(entity);
        this.entityToIndex[entity] = index;
        this.entityBitset.set(entity);
        this.count++;
    }
    
    // Direct access to dense array element (like C# ref access)
    getDirect(entity) {
        if (!this.entityBitset.isSet(entity)) return null;
        const index = this.entityToIndex[entity];
        return this.denseArray[index];
    }
}

// Direct access ECS (like C# version)
class DirectECS {
    constructor() {
        this.transforms = new ComponentStorage();
        this.velocities = new ComponentStorage();
        this.healths = new ComponentStorage();
        this.activeEntities = new BitSet(MAX_ENTITIES);
        this.nextEntity = 0;
        this.entityCount = 0;
        this.deltaTime = 0.0;
    }
    
    createEntity() {
        let entity = this.nextEntity;
        while (entity < MAX_ENTITIES && this.activeEntities.isSet(entity)) {
            entity++;
        }
        
        if (entity >= MAX_ENTITIES) {
            throw new Error('Entity limit exceeded');
        }
        
        this.activeEntities.set(entity);
        this.entityCount++;
        this.nextEntity = entity + 1;
        
        return entity;
    }
    
    addTransform(entity, component) {
        this.transforms.add(entity, component);
    }
    
    addVelocity(entity, component) {
        this.velocities.add(entity, component);
    }
    
    addHealth(entity, component) {
        this.healths.add(entity, component);
    }
    
    // Query with bitset intersection (like C#)
    queryTransformVelocity() {
        const result = this.activeEntities.intersectWith(this.transforms.entityBitset);
        return result.intersectWith(this.velocities.entityBitset);
    }
    
    queryHealth() {
        return this.activeEntities.intersectWith(this.healths.entityBitset);
    }
    
    update(deltaTime) {
        this.deltaTime = deltaTime;
    }
}

// Direct access systems (exactly like C# and Go versions)
function directUpdateTransformSystem(ecs) {
    const queryBitset = ecs.queryTransformVelocity();
    const deltaTime = ecs.deltaTime;
    
    // Direct iteration like C# foreach
    queryBitset.forEach((entity) => {
        // Direct access to dense arrays (like C# ref)
        const transform = ecs.transforms.getDirect(entity);
        const velocity = ecs.velocities.getDirect(entity);
        
        if (transform && velocity) {
            // Direct modification (like C# ref access) 
            transform.x += velocity.dx * deltaTime;
            transform.y += velocity.dy * deltaTime;
            transform.rotation += velocity.angular * deltaTime;
            
            // Keep rotation in bounds
            if (transform.rotation > 360.0) transform.rotation -= 360.0;
            else if (transform.rotation < 0.0) transform.rotation += 360.0;
        }
    });
}

function directDamageSystem(ecs) {
    const queryBitset = ecs.queryHealth();
    
    queryBitset.forEach((entity) => {
        const health = ecs.healths.getDirect(entity);
        
        if (health) {
            health.current--;
            if (health.current < 0) health.current = health.max;
        }
    });
}

// Performance test
function runPerformanceTest() {
    console.log('=== JavaScript Bitset ECS Performance Test (Direct Access - C# Style) ===');
    console.log('Testing with direct component access and bitset iteration\n');
    
    const entityCounts = [100, 250, 500, 750, 1000];
    const frameCount = 10000;
    
    for (const entityCount of entityCounts) {
        console.log(`\n--- Testing ${entityCount} entities for ${frameCount} frames ---`);
        
        const ecs = new DirectECS();
        
        const setupStart = performance.now();
        
        let firstEntity = -1;
        
        // Create entities
        for (let i = 0; i < entityCount; i++) {
            const entity = ecs.createEntity();
            if (i === 0) firstEntity = entity;
            
            // All entities get transform
            ecs.addTransform(entity, new Transform(
                i % 100,
                Math.floor(i / 100),
                0.0
            ));
            
            // 60% get velocity (moving entities)
            if (i % 5 < 3) {
                ecs.addVelocity(entity, new Velocity(
                    ((i % 10) - 5) * 10.0,
                    ((i % 7) - 3) * 10.0,
                    i % 360
                ));
            }
            
            // 40% get health
            if (i % 5 < 2) {
                ecs.addHealth(entity, new Health(100, 100));
            }
        }
        
        const setupTime = performance.now() - setupStart;
        
        // Warm up
        for (let i = 0; i < 100; i++) {
            ecs.update(0.016);
            directUpdateTransformSystem(ecs);
            directDamageSystem(ecs);
        }
        
        // Get initial values for verification
        const initialTransform = ecs.transforms.getDirect(firstEntity);
        const initialHealth = ecs.healths.getDirect(firstEntity);
        
        const initialX = initialTransform ? initialTransform.x : -999.0;
        const initialHealthVal = initialHealth ? initialHealth.current : -1;
        
        // Benchmark
        const benchStart = performance.now();
        
        for (let i = 0; i < frameCount; i++) {
            ecs.update(0.016);
            directUpdateTransformSystem(ecs);
            directDamageSystem(ecs);
        }
        
        const benchTime = performance.now() - benchStart;
        const avgFrameTime = benchTime / frameCount;
        
        // Get final values for verification
        const finalTransform = ecs.transforms.getDirect(firstEntity);
        const finalHealth = ecs.healths.getDirect(firstEntity);
        
        const finalX = finalTransform ? finalTransform.x : -999.0;
        const finalHealthVal = finalHealth ? finalHealth.current : -1;
        
        console.log(`Setup time: ${setupTime.toFixed(2)}ms`);
        console.log(`Total benchmark time: ${benchTime.toFixed(2)}ms`);
        console.log(`Average frame time: ${avgFrameTime.toFixed(3)}ms`);
        console.log(`FPS: ${(1000.0 / avgFrameTime).toFixed(1)}`);
        
        // Verification
        console.log(`Transform verification - Initial X: ${initialX.toFixed(2)}, Final X: ${finalX.toFixed(2)}, Delta: ${(finalX - initialX).toFixed(2)}`);
        if (initialHealthVal >= 0) {
            console.log(`Health verification - Initial: ${initialHealthVal}, Final: ${finalHealthVal}`);
        }
    }
    
    console.log('\n=== End of JavaScript Direct Access Performance Test ===');
}

// Run the test
runPerformanceTest();