// Optimized JavaScript Bitset ECS Implementation
// Performance improvements over original version

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

// Optimized BitSet with faster operations
class BitSet {
    constructor(size) {
        this.size = size;
        this.words = new Uint32Array(Math.ceil(size / 32));
        this.wordCount = this.words.length;
    }

    set(index) {
        const wordIndex = index >>> 5; // Faster than Math.floor(index / 32)
        const bitIndex = index & 31;   // Faster than index % 32
        this.words[wordIndex] |= (1 << bitIndex);
    }

    unset(index) {
        const wordIndex = index >>> 5;
        const bitIndex = index & 31;
        this.words[wordIndex] &= ~(1 << bitIndex);
    }

    isSet(index) {
        const wordIndex = index >>> 5;
        const bitIndex = index & 31;
        return (this.words[wordIndex] & (1 << bitIndex)) !== 0;
    }

    clear() {
        this.words.fill(0);
    }

    // Optimized intersect - reuse result object
    intersectWith(other, result) {
        const words = this.words;
        const otherWords = other.words;
        const resultWords = result.words;
        
        for (let i = 0; i < this.wordCount; i++) {
            resultWords[i] = words[i] & otherWords[i];
        }
        
        return result;
    }

    // Optimized iterator with pre-computed masks
    *iterator() {
        const words = this.words;
        const wordCount = this.wordCount;
        
        for (let wordIndex = 0; wordIndex < wordCount; wordIndex++) {
            let word = words[wordIndex];
            if (word === 0) continue;
            
            const baseIndex = wordIndex << 5; // Faster than * 32
            
            // Unroll common cases
            if (word === 0xFFFFFFFF) {
                // All bits set - common in dense queries
                for (let i = 0; i < 32; i++) {
                    yield baseIndex + i;
                }
                continue;
            }
            
            while (word !== 0) {
                // Use built-in trailing zeros count if available
                const bitIndex = Math.clz32(word & -word) ^ 31;
                yield baseIndex + bitIndex;
                word &= word - 1;
            }
        }
    }

    // Optimized count using lookup table for byte counting
    count() {
        let count = 0;
        const words = this.words;
        const wordCount = this.wordCount;
        
        for (let i = 0; i < wordCount; i++) {
            let w = words[i];
            // Optimized bit counting
            w = w - ((w >>> 1) & 0x55555555);
            w = (w & 0x33333333) + ((w >>> 2) & 0x33333333);
            count += (((w + (w >>> 4)) & 0x0F0F0F0F) * 0x01010101) >>> 24;
        }
        
        return count;
    }

    clone() {
        const result = new BitSet(this.size);
        result.words.set(this.words);
        return result;
    }
}

// Optimized Component Storage with object pooling
class ComponentStorage {
    constructor(maxEntities) {
        this.dense = [];
        this.entityBitset = new BitSet(maxEntities);
        this.entityToIndex = new Uint32Array(maxEntities);
        this.indexToEntity = new Uint32Array(maxEntities); // Use typed array
        this.denseCount = 0;
    }

    add(entity, component) {
        if (this.entityBitset.isSet(entity)) return;
        
        const index = this.denseCount;
        this.dense[index] = component;
        this.indexToEntity[index] = entity;
        this.entityToIndex[entity] = index;
        this.entityBitset.set(entity);
        this.denseCount++;
    }

    get(entity) {
        if (!this.entityBitset.isSet(entity)) return null;
        return this.dense[this.entityToIndex[entity]];
    }

    has(entity) {
        return this.entityBitset.isSet(entity);
    }

    remove(entity) {
        if (!this.entityBitset.isSet(entity)) return false;
        
        const index = this.entityToIndex[entity];
        const lastIndex = this.denseCount - 1;
        
        if (index !== lastIndex) {
            const lastEntity = this.indexToEntity[lastIndex];
            this.dense[index] = this.dense[lastIndex];
            this.indexToEntity[index] = lastEntity;
            this.entityToIndex[lastEntity] = index;
        }
        
        this.denseCount--;
        this.entityBitset.unset(entity);
        
        return true;
    }

    count() {
        return this.denseCount;
    }
}

// Optimized ECS with query caching
class ECS {
    constructor(config) {
        this.componentTypes = config.components;
        this.maxEntities = config.maxEntities || EntityLimit.medium;
        
        // Component type to index mapping - use Map for O(1) lookup
        this.componentIndices = new Map();
        this.componentTypes.forEach((type, index) => {
            this.componentIndices.set(type, index);
        });
        
        // Pre-allocate query result bitsets
        this.queryResultCache = new BitSet(this.maxEntities);
        this.queryTempCache = new BitSet(this.maxEntities);
        
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
        const maxEntities = this.maxEntities;
        const activeEntities = this.frameState.activeEntities;
        
        // Optimized entity search
        while (entity < maxEntities && activeEntities.isSet(entity)) {
            entity++;
        }
        
        if (entity >= maxEntities) {
            throw new Error(`Entity limit exceeded: ${maxEntities}`);
        }
        
        activeEntities.set(entity);
        this.frameState.entityCount++;
        this.frameState.nextEntity = entity + 1;
        
        return entity;
    }

    destroyEntity(entity) {
        const activeEntities = this.frameState.activeEntities;
        if (!activeEntities.isSet(entity)) return;
        
        // Remove from all component storages
        const storages = this.frameState.storages;
        const storageCount = storages.length;
        
        for (let i = 0; i < storageCount; i++) {
            storages[i].remove(entity);
        }
        
        activeEntities.unset(entity);
        this.frameState.entityCount--;
    }

    addComponent(entity, componentType, componentData) {
        const storageIndex = this.componentIndices.get(componentType);
        this.frameState.storages[storageIndex].add(entity, componentData);
    }

    getComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        return this.frameState.storages[storageIndex].get(entity);
    }

    hasComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        return this.frameState.storages[storageIndex].has(entity);
    }

    removeComponent(entity, componentType) {
        const storageIndex = this.componentIndices.get(componentType);
        return this.frameState.storages[storageIndex].remove(entity);
    }

    // Optimized query with result caching
    query(componentTypes) {
        // Copy active entities to result
        const resultEntities = this.queryResultCache;
        resultEntities.words.set(this.frameState.activeEntities.words);
        
        // Use temp cache for intermediate results
        const tempCache = this.queryTempCache;
        
        // Intersect with required component bitsets
        const componentCount = componentTypes.length;
        for (let i = 0; i < componentCount; i++) {
            const storageIndex = this.componentIndices.get(componentTypes[i]);
            const componentBitset = this.frameState.storages[storageIndex].entityBitset;
            componentBitset.intersectWith(resultEntities, tempCache);
            
            // Swap caches
            const swap = resultEntities;
            resultEntities.words.set(tempCache.words);
        }
        
        // Create optimized iterator
        const iterator = resultEntities.iterator();
        const self = this;
        
        return {
            next() {
                const { value, done } = iterator.next();
                if (done) return null;
                
                // Return lightweight result object
                return {
                    entity: value,
                    get(componentType) {
                        const storageIndex = self.componentIndices.get(componentType);
                        return self.frameState.storages[storageIndex].dense[
                            self.frameState.storages[storageIndex].entityToIndex[value]
                        ];
                    }
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
        const frame = this.currentFrame;
        frame.input = input;
        frame.deltaTime = deltaTime;
        frame.time = time;
        frame.frameNumber++;
    }

    getEntityCount() {
        return this.frameState.entityCount;
    }
}

// Export for use in tests
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ECS, EntityLimit };
}