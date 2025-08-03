// JavaScript Bitset ECS Implementation
// Mirrors the Zig implementation for performance comparison

const INVALID_ENTITY = 0xFFFFFFFF;

// Entity limits (same as Zig)
const EntityLimit = {
    tiny: 64,
    small: 256,
    medium: 512,
    large: 1024,
    huge: 2048,
    massive: 4096
};

// BitSet implementation for JavaScript
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

    clear() {
        this.words.fill(0);
    }

    // Intersect with another bitset (for queries)
    intersectWith(other) {
        const result = new BitSet(this.size);
        for (let i = 0; i < this.words.length; i++) {
            result.words[i] = this.words[i] & other.words[i];
        }
        return result;
    }

    // Iterator for set bits
    *iterator() {
        for (let wordIndex = 0; wordIndex < this.words.length; wordIndex++) {
            let word = this.words[wordIndex];
            if (word === 0) continue;
            
            let baseIndex = wordIndex * 32;
            while (word !== 0) {
                // Find the index of the least significant set bit
                const bitIndex = Math.clz32(word & -word) ^ 31;
                yield baseIndex + bitIndex;
                // Clear the least significant set bit
                word &= word - 1;
            }
        }
    }

    count() {
        let count = 0;
        for (const word of this.words) {
            // Brian Kernighan's algorithm for counting set bits
            let w = word;
            while (w) {
                w &= w - 1;
                count++;
            }
        }
        return count;
    }

    clone() {
        const result = new BitSet(this.size);
        result.words.set(this.words);
        return result;
    }
}

// Component Storage
class ComponentStorage {
    constructor(maxEntities) {
        this.dense = [];
        this.entityBitset = new BitSet(maxEntities);
        this.entityToIndex = new Uint32Array(maxEntities);
        this.indexToEntity = [];
    }

    add(entity, component) {
        if (this.entityBitset.isSet(entity)) return; // Already exists
        
        const index = this.dense.length;
        this.dense.push(component);
        this.indexToEntity.push(entity);
        this.entityToIndex[entity] = index;
        this.entityBitset.set(entity);
    }

    get(entity) {
        if (!this.entityBitset.isSet(entity)) return null;
        const index = this.entityToIndex[entity];
        return this.dense[index];
    }

    has(entity) {
        return this.entityBitset.isSet(entity);
    }

    remove(entity) {
        if (!this.entityBitset.isSet(entity)) return false;
        
        const index = this.entityToIndex[entity];
        const lastIndex = this.dense.length - 1;
        
        // Swap with last element for O(1) removal
        if (index !== lastIndex) {
            const lastEntity = this.indexToEntity[lastIndex];
            this.dense[index] = this.dense[lastIndex];
            this.indexToEntity[index] = lastEntity;
            this.entityToIndex[lastEntity] = index;
        }
        
        this.dense.pop();
        this.indexToEntity.pop();
        this.entityBitset.unset(entity);
        
        return true;
    }

    count() {
        return this.dense.length;
    }
}

// ECS Implementation
class ECS {
    constructor(config) {
        this.componentTypes = config.components;
        this.maxEntities = config.maxEntities || EntityLimit.medium;
        
        // Component type to index mapping
        this.componentIndices = new Map();
        this.componentTypes.forEach((type, index) => {
            this.componentIndices.set(type, index);
        });
        
        // Initialize frame state
        this.frameState = {
            storages: this.componentTypes.map(() => new ComponentStorage(this.maxEntities)),
            activeEntities: new BitSet(this.maxEntities),
            nextEntity: 0,
            entityCount: 0
        };
        
        // Frame data
        this.currentFrame = {
            state: this.frameState,
            input: {},
            deltaTime: 0,
            time: 0,
            frameNumber: 0
        };
    }

    createEntity() {
        let entity = this.frameState.nextEntity;
        while (entity < this.maxEntities && this.frameState.activeEntities.isSet(entity)) {
            entity++;
        }
        
        if (entity >= this.maxEntities) {
            throw new Error(`Entity limit exceeded: ${this.maxEntities}`);
        }
        
        this.frameState.activeEntities.set(entity);
        this.frameState.entityCount++;
        this.frameState.nextEntity = entity + 1;
        
        return entity;
    }

    destroyEntity(entity) {
        if (!this.frameState.activeEntities.isSet(entity)) return;
        
        // Remove from all component storages
        for (const storage of this.frameState.storages) {
            storage.remove(entity);
        }
        
        this.frameState.activeEntities.unset(entity);
        this.frameState.entityCount--;
    }

    addComponent(entity, componentType, componentData) {
        if (!this.frameState.activeEntities.isSet(entity)) {
            throw new Error(`Entity ${entity} does not exist`);
        }
        
        const storageIndex = this.componentIndices.get(componentType);
        if (storageIndex === undefined) {
            throw new Error(`Component type not registered`);
        }
        
        this.frameState.storages[storageIndex].add(entity, componentData);
    }

    getComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        if (storageIndex === undefined) return null;
        
        return this.frameState.storages[storageIndex].get(entity);
    }

    hasComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        if (storageIndex === undefined) return false;
        
        return this.frameState.storages[storageIndex].has(entity);
    }

    removeComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        if (storageIndex === undefined) return false;
        
        return this.frameState.storages[storageIndex].remove(entity);
    }

    query(componentTypes) {
        // Start with active entities
        let resultEntities = this.frameState.activeEntities.clone();
        
        // Intersect with required component bitsets
        for (const componentType of componentTypes) {
            const storageIndex = this.componentIndices.get(componentType);
            if (storageIndex === undefined) {
                throw new Error(`Component type not registered`);
            }
            const componentBitset = this.frameState.storages[storageIndex].entityBitset;
            resultEntities = resultEntities.intersectWith(componentBitset);
        }
        
        // Return query result object
        const iterator = resultEntities.iterator();
        return {
            next: () => {
                const { value, done } = iterator.next();
                if (done) return null;
                
                return {
                    entity: value,
                    get: (componentType) => this.getComponent(value, componentType)
                };
            },
            count: () => resultEntities.count(),
            reset: () => {
                // Recreate iterator
                iterator = resultEntities.iterator();
            }
        };
    }

    update(input, deltaTime, time) {
        this.currentFrame.input = input;
        this.currentFrame.deltaTime = deltaTime;
        this.currentFrame.time = time;
        this.currentFrame.frameNumber++;
    }

    getEntityCount() {
        return this.frameState.entityCount;
    }
}

// Export for use in tests
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ECS, EntityLimit };
}