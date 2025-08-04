package main

import (
	"fmt"
	"math/bits"
	"time"
	"unsafe"
)

// Component types
type Transform struct {
	X, Y, Z                 float32
	RotationX, RotationY, RotationZ float32
}

type Velocity struct {
	DX, DY, DZ float32
}

type Health struct {
	Value float32
}

// Ultra-optimized BitSet using bit shifts
type UltraOptimizedBitSet struct {
	words []uint64
	size  uint32
}

func NewUltraOptimizedBitSet(size uint32) *UltraOptimizedBitSet {
	wordCount := (size + 63) >> 6 // Bit shift instead of division
	return &UltraOptimizedBitSet{
		words: make([]uint64, wordCount),
		size:  size,
	}
}

func (b *UltraOptimizedBitSet) Set(index uint32) {
	if index >= b.size {
		return
	}
	wordIndex := index >> 6 // Bit shift instead of division
	bitIndex := index & 63  // Bit mask instead of modulus
	b.words[wordIndex] |= 1 << bitIndex
}

func (b *UltraOptimizedBitSet) IsSet(index uint32) bool {
	if index >= b.size {
		return false
	}
	wordIndex := index >> 6
	bitIndex := index & 63
	return (b.words[wordIndex] & (1 << bitIndex)) != 0
}

func (b *UltraOptimizedBitSet) Clear() {
	for i := range b.words {
		b.words[i] = 0
	}
}

// Triple intersection with manual operation
func (b *UltraOptimizedBitSet) TripleIntersection(set1, set2, set3 *UltraOptimizedBitSet) {
	minLen := len(b.words)
	if len(set1.words) < minLen {
		minLen = len(set1.words)
	}
	if len(set2.words) < minLen {
		minLen = len(set2.words)
	}
	if len(set3.words) < minLen {
		minLen = len(set3.words)
	}

	// Manual triple intersection
	for i := 0; i < minLen; i++ {
		b.words[i] = set1.words[i] & set2.words[i] & set3.words[i]
	}
	
	// Clear remaining words
	for i := minLen; i < len(b.words); i++ {
		b.words[i] = 0
	}
}

// Ultra-optimized component storage using generics
type UltraOptimizedComponentStorage[T any] struct {
	dense         []T
	entityBitset  *UltraOptimizedBitSet
	entityToIndex []uint32
	indexToEntity []uint32
	count         uint32
}

func NewUltraOptimizedComponentStorage[T any](maxEntities int) *UltraOptimizedComponentStorage[T] {
	return &UltraOptimizedComponentStorage[T]{
		dense:         make([]T, 0, maxEntities),
		entityBitset:  NewUltraOptimizedBitSet(uint32(maxEntities)),
		entityToIndex: make([]uint32, maxEntities),
		indexToEntity: make([]uint32, 0, maxEntities),
		count:         0,
	}
}

func (s *UltraOptimizedComponentStorage[T]) Add(entity uint32, component T) {
	if s.entityBitset.IsSet(entity) {
		return
	}

	index := s.count
	s.dense = append(s.dense, component)
	s.indexToEntity = append(s.indexToEntity, entity)
	s.entityToIndex[entity] = index
	s.entityBitset.Set(entity)
	s.count++
}

// Direct unsafe access for maximum performance
func (s *UltraOptimizedComponentStorage[T]) GetDirectUnsafe(entity uint32) *T {
	index := s.entityToIndex[entity]
	return &s.dense[index]
}

// Ultra-optimized ECS
type UltraOptimizedECS struct {
	transforms    *UltraOptimizedComponentStorage[Transform]
	velocities    *UltraOptimizedComponentStorage[Velocity]
	healths       *UltraOptimizedComponentStorage[Health]
	activeEntities *UltraOptimizedBitSet
	queryResult   *UltraOptimizedBitSet
	nextEntity    uint32
}

func NewUltraOptimizedECS(maxEntities int) *UltraOptimizedECS {
	return &UltraOptimizedECS{
		transforms:    NewUltraOptimizedComponentStorage[Transform](maxEntities),
		velocities:    NewUltraOptimizedComponentStorage[Velocity](maxEntities),
		healths:       NewUltraOptimizedComponentStorage[Health](maxEntities),
		activeEntities: NewUltraOptimizedBitSet(uint32(maxEntities)),
		queryResult:   NewUltraOptimizedBitSet(uint32(maxEntities)),
		nextEntity:    0,
	}
}

func (ecs *UltraOptimizedECS) CreateEntity() uint32 {
	entity := ecs.nextEntity
	ecs.nextEntity++
	ecs.activeEntities.Set(entity)
	return entity
}

func (ecs *UltraOptimizedECS) AddTransform(entity uint32, transform Transform) {
	ecs.transforms.Add(entity, transform)
}

func (ecs *UltraOptimizedECS) AddVelocity(entity uint32, velocity Velocity) {
	ecs.velocities.Add(entity, velocity)
}

func (ecs *UltraOptimizedECS) AddHealth(entity uint32, health Health) {
	ecs.healths.Add(entity, health)
}

// Ultra-fast system with manual bitset iteration (Zig-style)
func (ecs *UltraOptimizedECS) UpdateTransformSystem() {
	// Triple intersection
	ecs.queryResult.TripleIntersection(ecs.activeEntities, ecs.transforms.entityBitset, ecs.velocities.entityBitset)
	
	// Manual word iteration for maximum performance
	words := ecs.queryResult.words
	transformsSlice := ecs.transforms.dense
	velocitiesSlice := ecs.velocities.dense
	transformEntityToIndex := ecs.transforms.entityToIndex
	velocityEntityToIndex := ecs.velocities.entityToIndex
	
	for wordIndex, word := range words {
		if word == 0 {
			continue
		}
		
		baseEntity := uint32(wordIndex << 6) // Bit shift for multiplication
		
		for word != 0 {
			bitIndex := bits.TrailingZeros64(word)
			entity := baseEntity + uint32(bitIndex)
			
			// Direct slice access for maximum performance
			transformIndex := transformEntityToIndex[entity]
			velocityIndex := velocityEntityToIndex[entity]
			
			// Use unsafe pointers for even faster access
			transformPtr := (*Transform)(unsafe.Pointer(&transformsSlice[transformIndex]))
			velocityPtr := (*Velocity)(unsafe.Pointer(&velocitiesSlice[velocityIndex]))
			
			// Inline math operations
			transformPtr.X += velocityPtr.DX
			transformPtr.Y += velocityPtr.DY
			transformPtr.Z += velocityPtr.DZ
			transformPtr.RotationX += 0.01
			transformPtr.RotationY += 0.02
			transformPtr.RotationZ += 0.03
			
			word &= word - 1 // Clear lowest bit
		}
	}
}

func (ecs *UltraOptimizedECS) UpdateDamageSystem() {
	// Intersection for health entities
	ecs.queryResult.TripleIntersection(ecs.activeEntities, ecs.healths.entityBitset, ecs.healths.entityBitset)
	
	words := ecs.queryResult.words
	healthsSlice := ecs.healths.dense
	healthEntityToIndex := ecs.healths.entityToIndex
	
	for wordIndex, word := range words {
		if word == 0 {
			continue
		}
		
		baseEntity := uint32(wordIndex << 6)
		
		for word != 0 {
			bitIndex := bits.TrailingZeros64(word)
			entity := baseEntity + uint32(bitIndex)
			
			healthIndex := healthEntityToIndex[entity]
			healthPtr := (*Health)(unsafe.Pointer(&healthsSlice[healthIndex]))
			
			healthPtr.Value -= 1.0
			if healthPtr.Value <= 0 {
				healthPtr.Value = 100.0
			}
			
			word &= word - 1
		}
	}
}

func main() {
	fmt.Println("=== Go Ultra-Optimized Bitset ECS Performance Test ===")
	fmt.Println("Testing with manual bitset iteration and unsafe operations\n")
	
	entityCounts := []int{100, 250, 500, 750, 1000}
	frameCount := 10000
	
	for _, entityCount := range entityCounts {
		fmt.Printf("\n--- Testing %d entities for %d frames ---\n", entityCount, frameCount)
		
		// Initialize ECS
		ecs := NewUltraOptimizedECS(entityCount + 100)
		
		setupStart := time.Now()
		
		// Create entities
		for i := 0; i < entityCount; i++ {
			entity := ecs.CreateEntity()
			
			// All entities get transform
			ecs.AddTransform(entity, Transform{
				X: float32(i % 100),
				Y: float32(i / 100),
				Z: 0,
				RotationX: 0,
				RotationY: 0,
				RotationZ: 0,
			})
			
			// 60% get velocity (moving entities)
			if i%5 < 3 {
				ecs.AddVelocity(entity, Velocity{
					DX: 1.0,
					DY: 0.5,
					DZ: 0.25,
				})
			}
			
			// 40% get health
			if i%5 < 2 {
				ecs.AddHealth(entity, Health{Value: 100.0})
			}
		}
		
		setupTime := time.Since(setupStart)
		
		// Warmup
		for i := 0; i < 100; i++ {
			ecs.UpdateTransformSystem()
			ecs.UpdateDamageSystem()
		}
		
		// Benchmark
		benchmarkStart := time.Now()
		for i := 0; i < frameCount; i++ {
			ecs.UpdateTransformSystem()
			ecs.UpdateDamageSystem()
		}
		benchmarkTime := time.Since(benchmarkStart)
		
		avgFrameTime := float64(benchmarkTime.Nanoseconds()) / float64(frameCount) / 1e6
		fps := 1000.0 / avgFrameTime
		
		fmt.Printf("Setup time: %v\n", setupTime)
		fmt.Printf("Total benchmark time: %v\n", benchmarkTime)
		fmt.Printf("Average frame time: %.3fms\n", avgFrameTime)
		fmt.Printf("FPS: %.1f\n", fps)
	}
	
	fmt.Println("\n=== End of Go Ultra-Optimized Performance Test ===")
}