package main

import (
	"fmt"
	"math/bits"
	"time"
	"unsafe"
)

const InvalidEntity uint32 = 0xFFFFFFFF
const EntityLimitLarge = 1024

// High-performance bitset
type BitSet struct {
	size  uint32
	words []uint64
}

func NewBitSet(size uint32) *BitSet {
	wordCount := (size + 63) / 64
	return &BitSet{
		size:  size,
		words: make([]uint64, wordCount),
	}
}

func (b *BitSet) Set(index uint32) {
	if index >= b.size {
		return
	}
	wordIndex := index / 64
	bitIndex := index % 64
	b.words[wordIndex] |= 1 << bitIndex
}

func (b *BitSet) Unset(index uint32) {
	if index >= b.size {
		return
	}
	wordIndex := index / 64
	bitIndex := index % 64
	b.words[wordIndex] &^= 1 << bitIndex
}

func (b *BitSet) IsSet(index uint32) bool {
	if index >= b.size {
		return false
	}
	wordIndex := index / 64
	bitIndex := index % 64
	return (b.words[wordIndex] & (1 << bitIndex)) != 0
}

func (b *BitSet) IntersectWith(other *BitSet) *BitSet {
	result := NewBitSet(b.size)
	minLen := len(b.words)
	if len(other.words) < minLen {
		minLen = len(other.words)
	}
	
	for i := 0; i < minLen; i++ {
		result.words[i] = b.words[i] & other.words[i]
	}
	
	return result
}

func (b *BitSet) Count() int {
	count := 0
	for _, word := range b.words {
		count += bits.OnesCount64(word)
	}
	return count
}

// BitSet iterator for direct iteration (like C# foreach)
func (b *BitSet) ForEach(fn func(uint32)) {
	for wordIndex, word := range b.words {
		if word == 0 {
			continue
		}
		
		baseIndex := uint32(wordIndex * 64)
		for word != 0 {
			bitIndex := bits.TrailingZeros64(word)
			entity := baseIndex + uint32(bitIndex)
			fn(entity)
			word &= word - 1 // Clear lowest bit
		}
	}
}

// Direct access component storage (like C# version)
type ComponentStorage struct {
	dense         []unsafe.Pointer // Direct memory access
	entityBitset  *BitSet
	entityToIndex []uint32
	indexToEntity []uint32
	count         int
	maxEntities   uint32
	componentSize uintptr
}

func NewComponentStorage(maxEntities uint32, componentSize uintptr) *ComponentStorage {
	return &ComponentStorage{
		dense:         make([]unsafe.Pointer, 0, 64),
		entityBitset:  NewBitSet(maxEntities),
		entityToIndex: make([]uint32, maxEntities),
		indexToEntity: make([]uint32, 0, 64),
		count:         0,
		maxEntities:   maxEntities,
		componentSize: componentSize,
	}
}

func (s *ComponentStorage) Add(entity uint32, component unsafe.Pointer) {
	if s.entityBitset.IsSet(entity) {
		return
	}
	
	// Allocate memory for component
	ptr := unsafe.Pointer(&make([]byte, s.componentSize)[0])
	// Copy component data
	*(*uintptr)(ptr) = *(*uintptr)(component)
	copy((*[256]byte)(ptr)[:s.componentSize], (*[256]byte)(component)[:s.componentSize])
	
	index := uint32(s.count)
	s.dense = append(s.dense, ptr)
	s.indexToEntity = append(s.indexToEntity, entity)
	s.entityToIndex[entity] = index
	s.entityBitset.Set(entity)
	s.count++
}

func (s *ComponentStorage) GetDirect(entity uint32) unsafe.Pointer {
	if !s.entityBitset.IsSet(entity) {
		return nil
	}
	index := s.entityToIndex[entity]
	return s.dense[index]
}

// Components (matching other implementations)
type Transform struct {
	X, Y, Rotation float32
}

type Velocity struct {
	DX, DY, Angular float32
}

type Health struct {
	Current, Max int32
}

// Direct access ECS (like C# version)
type DirectECS struct {
	transforms    *ComponentStorage
	velocities    *ComponentStorage
	healths       *ComponentStorage
	activeEntities *BitSet
	nextEntity    uint32
	entityCount   uint32
	maxEntities   uint32
	deltaTime     float32
}

func NewDirectECS(maxEntities uint32) *DirectECS {
	return &DirectECS{
		transforms:    NewComponentStorage(maxEntities, unsafe.Sizeof(Transform{})),
		velocities:    NewComponentStorage(maxEntities, unsafe.Sizeof(Velocity{})),
		healths:       NewComponentStorage(maxEntities, unsafe.Sizeof(Health{})),
		activeEntities: NewBitSet(maxEntities),
		nextEntity:    0,
		entityCount:   0,
		maxEntities:   maxEntities,
	}
}

func (ecs *DirectECS) CreateEntity() (uint32, error) {
	entity := ecs.nextEntity
	for entity < ecs.maxEntities && ecs.activeEntities.IsSet(entity) {
		entity++
	}
	
	if entity >= ecs.maxEntities {
		return InvalidEntity, fmt.Errorf("entity limit exceeded: %d", ecs.maxEntities)
	}
	
	ecs.activeEntities.Set(entity)
	ecs.entityCount++
	ecs.nextEntity = entity + 1
	
	return entity, nil
}

func (ecs *DirectECS) AddTransform(entity uint32, component *Transform) {
	ecs.transforms.Add(entity, unsafe.Pointer(component))
}

func (ecs *DirectECS) AddVelocity(entity uint32, component *Velocity) {
	ecs.velocities.Add(entity, unsafe.Pointer(component))
}

func (ecs *DirectECS) AddHealth(entity uint32, component *Health) {
	ecs.healths.Add(entity, unsafe.Pointer(component))
}

// Query with direct bitset access (like C#)
func (ecs *DirectECS) QueryTransformVelocity() *BitSet {
	result := ecs.activeEntities.IntersectWith(ecs.transforms.entityBitset)
	return result.IntersectWith(ecs.velocities.entityBitset)
}

func (ecs *DirectECS) QueryHealth() *BitSet {
	return ecs.activeEntities.IntersectWith(ecs.healths.entityBitset)
}

func (ecs *DirectECS) Update(deltaTime float32) {
	ecs.deltaTime = deltaTime
}

// Direct access systems (like C# version)
func DirectUpdateTransformSystem(ecs *DirectECS) {
	queryBitset := ecs.QueryTransformVelocity()
	deltaTime := ecs.deltaTime
	
	// Direct iteration like C# foreach
	queryBitset.ForEach(func(entity uint32) {
		// Direct pointer access (like C# ref)
		transformPtr := (*Transform)(ecs.transforms.GetDirect(entity))
		velocityPtr := (*Velocity)(ecs.velocities.GetDirect(entity))
		
		if transformPtr != nil && velocityPtr != nil {
			// Direct modification (like C# ref access)
			transformPtr.X += velocityPtr.DX * deltaTime
			transformPtr.Y += velocityPtr.DY * deltaTime
			transformPtr.Rotation += velocityPtr.Angular * deltaTime
			
			// Keep rotation in bounds
			if transformPtr.Rotation > 360.0 {
				transformPtr.Rotation -= 360.0
			} else if transformPtr.Rotation < 0.0 {
				transformPtr.Rotation += 360.0
			}
		}
	})
}

func DirectDamageSystem(ecs *DirectECS) {
	queryBitset := ecs.QueryHealth()
	
	queryBitset.ForEach(func(entity uint32) {
		healthPtr := (*Health)(ecs.healths.GetDirect(entity))
		
		if healthPtr != nil {
			healthPtr.Current--
			if healthPtr.Current < 0 {
				healthPtr.Current = healthPtr.Max
			}
		}
	})
}

func main() {
	fmt.Println("=== Go Bitset ECS Performance Test (Direct Access - C# Style) ===")
	fmt.Println("Testing with direct component access and bitset iteration\n")
	
	entityCounts := []int{100, 250, 500, 750, 1000}
	frameCount := 10000
	
	for _, entityCount := range entityCounts {
		fmt.Printf("\n--- Testing %d entities for %d frames ---\n", entityCount, frameCount)
		
		ecs := NewDirectECS(EntityLimitLarge)
		
		setupStart := time.Now()
		
		var firstEntity uint32
		
		// Create entities
		for i := 0; i < entityCount; i++ {
			entity, err := ecs.CreateEntity()
			if err != nil {
				panic(err)
			}
			if i == 0 {
				firstEntity = entity
			}
			
			// All entities get transform
			ecs.AddTransform(entity, &Transform{
				X:        float32(i % 100),
				Y:        float32(i / 100),
				Rotation: 0.0,
			})
			
			// 60% get velocity (moving entities)
			if i%5 < 3 {
				ecs.AddVelocity(entity, &Velocity{
					DX:      float32((i%10)-5) * 10.0,
					DY:      float32((i%7)-3) * 10.0,
					Angular: float32(i % 360),
				})
			}
			
			// 40% get health
			if i%5 < 2 {
				ecs.AddHealth(entity, &Health{
					Current: 100,
					Max:     100,
				})
			}
		}
		
		setupTime := time.Since(setupStart)
		
		// Warm up
		for i := 0; i < 100; i++ {
			ecs.Update(0.016)
			DirectUpdateTransformSystem(ecs)
			DirectDamageSystem(ecs)
		}
		
		// Get initial values for verification
		initialTransformPtr := (*Transform)(ecs.transforms.GetDirect(firstEntity))
		initialHealthPtr := (*Health)(ecs.healths.GetDirect(firstEntity))
		
		var initialX float32 = -999.0
		var initialHealth int32 = -1
		
		if initialTransformPtr != nil {
			initialX = initialTransformPtr.X
		}
		if initialHealthPtr != nil {
			initialHealth = initialHealthPtr.Current
		}
		
		// Benchmark
		benchStart := time.Now()
		
		for i := 0; i < frameCount; i++ {
			ecs.Update(0.016)
			DirectUpdateTransformSystem(ecs)
			DirectDamageSystem(ecs)
		}
		
		benchTime := time.Since(benchStart)
		avgFrameTime := float64(benchTime.Nanoseconds()) / float64(frameCount) / 1_000_000.0
		
		// Get final values for verification
		finalTransformPtr := (*Transform)(ecs.transforms.GetDirect(firstEntity))
		finalHealthPtr := (*Health)(ecs.healths.GetDirect(firstEntity))
		
		var finalX float32 = -999.0
		var finalHealth int32 = -1
		
		if finalTransformPtr != nil {
			finalX = finalTransformPtr.X
		}
		if finalHealthPtr != nil {
			finalHealth = finalHealthPtr.Current
		}
		
		fmt.Printf("Setup time: %v\n", setupTime)
		fmt.Printf("Total benchmark time: %v\n", benchTime)
		fmt.Printf("Average frame time: %.3fms\n", avgFrameTime)
		fmt.Printf("FPS: %.1f\n", 1000.0/avgFrameTime)
		
		// Verification
		fmt.Printf("Transform verification - Initial X: %.2f, Final X: %.2f, Delta: %.2f\n", 
			initialX, finalX, finalX-initialX)
		if initialHealth >= 0 {
			fmt.Printf("Health verification - Initial: %d, Final: %d\n", initialHealth, finalHealth)
		}
	}
	
	fmt.Println("\n=== End of Go Direct Access Performance Test ===")
}