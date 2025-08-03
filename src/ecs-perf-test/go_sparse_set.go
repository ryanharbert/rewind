package main

import (
	"fmt"
	"time"
)

const InvalidEntity uint32 = 0xFFFFFFFF
const EntityLimitLarge = 1024

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

// Component masks for fast queries (like the Zig sparse set version)
const (
	TransformMask uint64 = 1 << 0
	VelocityMask  uint64 = 1 << 1
	HealthMask    uint64 = 1 << 2
)

// Sparse Set ECS (like the Zig implementation)
type SparseSetECS struct {
	// Dense arrays for components
	transforms []Transform
	velocities []Velocity
	healths    []Health
	
	// Entity -> component index mappings (sparse sets)
	entityToTransform map[uint32]uint32
	entityToVelocity  map[uint32]uint32
	entityToHealth    map[uint32]uint32
	
	// Component masks for fast queries
	componentMasks map[uint32]uint64
	
	// Entity management
	nextEntity  uint32
	entityCount uint32
	maxEntities uint32
	deltaTime   float32
}

func NewSparseSetECS(maxEntities uint32) *SparseSetECS {
	return &SparseSetECS{
		// Initialize dense arrays
		transforms: make([]Transform, 0, 64),
		velocities: make([]Velocity, 0, 64),
		healths:    make([]Health, 0, 64),
		
		// Initialize sparse maps
		entityToTransform: make(map[uint32]uint32),
		entityToVelocity:  make(map[uint32]uint32),
		entityToHealth:    make(map[uint32]uint32),
		
		// Component masks
		componentMasks: make(map[uint32]uint64),
		
		// Entity management
		nextEntity:  0,
		entityCount: 0,
		maxEntities: maxEntities,
	}
}

func (ecs *SparseSetECS) CreateEntity() (uint32, error) {
	entity := ecs.nextEntity
	for entity < ecs.maxEntities {
		// Check if entity exists in component masks
		if _, exists := ecs.componentMasks[entity]; !exists {
			break
		}
		entity++
	}
	
	if entity >= ecs.maxEntities {
		return InvalidEntity, fmt.Errorf("entity limit exceeded: %d", ecs.maxEntities)
	}
	
	// Initialize with empty component mask
	ecs.componentMasks[entity] = 0
	ecs.entityCount++
	ecs.nextEntity = entity + 1
	
	return entity, nil
}

func (ecs *SparseSetECS) AddTransform(entity uint32, component Transform) {
	// Check if entity exists
	if _, exists := ecs.componentMasks[entity]; !exists {
		return
	}
	
	// Check if already has component
	if _, hasComponent := ecs.entityToTransform[entity]; hasComponent {
		return
	}
	
	// Add to dense array
	index := uint32(len(ecs.transforms))
	ecs.transforms = append(ecs.transforms, component)
	ecs.entityToTransform[entity] = index
	
	// Update component mask
	ecs.componentMasks[entity] |= TransformMask
}

func (ecs *SparseSetECS) AddVelocity(entity uint32, component Velocity) {
	if _, exists := ecs.componentMasks[entity]; !exists {
		return
	}
	
	if _, hasComponent := ecs.entityToVelocity[entity]; hasComponent {
		return
	}
	
	index := uint32(len(ecs.velocities))
	ecs.velocities = append(ecs.velocities, component)
	ecs.entityToVelocity[entity] = index
	
	ecs.componentMasks[entity] |= VelocityMask
}

func (ecs *SparseSetECS) AddHealth(entity uint32, component Health) {
	if _, exists := ecs.componentMasks[entity]; !exists {
		return
	}
	
	if _, hasComponent := ecs.entityToHealth[entity]; hasComponent {
		return
	}
	
	index := uint32(len(ecs.healths))
	ecs.healths = append(ecs.healths, component)
	ecs.entityToHealth[entity] = index
	
	ecs.componentMasks[entity] |= HealthMask
}

func (ecs *SparseSetECS) GetTransform(entity uint32) *Transform {
	if index, exists := ecs.entityToTransform[entity]; exists {
		return &ecs.transforms[index]
	}
	return nil
}

func (ecs *SparseSetECS) GetVelocity(entity uint32) *Velocity {
	if index, exists := ecs.entityToVelocity[entity]; exists {
		return &ecs.velocities[index]
	}
	return nil
}

func (ecs *SparseSetECS) GetHealth(entity uint32) *Health {
	if index, exists := ecs.entityToHealth[entity]; exists {
		return &ecs.healths[index]
	}
	return nil
}

func (ecs *SparseSetECS) HasComponent(entity uint32, mask uint64) bool {
	if componentMask, exists := ecs.componentMasks[entity]; exists {  
		return (componentMask & mask) != 0
	}
	return false
}

// Query entities with both Transform and Velocity components
func (ecs *SparseSetECS) QueryTransformVelocity() []uint32 {
	requiredMask := TransformMask | VelocityMask
	var results []uint32
	
	// Iterate through all entities with component masks
	for entity, mask := range ecs.componentMasks {
		if (mask & requiredMask) == requiredMask {
			results = append(results, entity)
		}
	}
	
	return results
}

// Query entities with Health component
func (ecs *SparseSetECS) QueryHealth() []uint32 {
	requiredMask := HealthMask
	var results []uint32
	
	for entity, mask := range ecs.componentMasks {
		if (mask & requiredMask) == requiredMask {
			results = append(results, entity)
		}
	}
	
	return results
}

func (ecs *SparseSetECS) Update(deltaTime float32) {
	ecs.deltaTime = deltaTime
}

// Sparse Set systems (using HashMap lookups instead of bitset iteration)
func SparseSetUpdateTransformSystem(ecs *SparseSetECS) {
	entities := ecs.QueryTransformVelocity()
	deltaTime := ecs.deltaTime
	
	// Iterate through query results
	for _, entity := range entities {
		// Direct access via HashMap lookups
		transform := ecs.GetTransform(entity)
		velocity := ecs.GetVelocity(entity)
		
		if transform != nil && velocity != nil {
			// Direct modification
			transform.X += velocity.DX * deltaTime
			transform.Y += velocity.DY * deltaTime
			transform.Rotation += velocity.Angular * deltaTime
			
			// Keep rotation in bounds
			if transform.Rotation > 360.0 {
				transform.Rotation -= 360.0
			} else if transform.Rotation < 0.0 {
				transform.Rotation += 360.0
			}
		}
	}
}

func SparseSetDamageSystem(ecs *SparseSetECS) {
	entities := ecs.QueryHealth()
	
	for _, entity := range entities {
		health := ecs.GetHealth(entity)
		
		if health != nil {
			health.Current--
			if health.Current < 0 {
				health.Current = health.Max
			}
		}
	}
}

func main() {
	fmt.Println("=== Go Sparse Set ECS Performance Test ===")
	fmt.Println("Testing with HashMap entity->index mapping and dense arrays\\n")
	
	entityCounts := []int{100, 250, 500, 750, 1000}
	frameCount := 10000
	
	for _, entityCount := range entityCounts {
		fmt.Printf("\\n--- Testing %d entities for %d frames ---\\n", entityCount, frameCount)
		
		ecs := NewSparseSetECS(EntityLimitLarge)
		
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
			ecs.AddTransform(entity, Transform{
				X:        float32(i % 100),
				Y:        float32(i / 100),
				Rotation: 0.0,
			})
			
			// 60% get velocity (moving entities)
			if i%5 < 3 {
				ecs.AddVelocity(entity, Velocity{
					DX:      float32((i%10)-5) * 10.0,
					DY:      float32((i%7)-3) * 10.0,
					Angular: float32(i % 360),
				})
			}
			
			// 40% get health
			if i%5 < 2 {
				ecs.AddHealth(entity, Health{
					Current: 100,
					Max:     100,
				})
			}
		}
		
		setupTime := time.Since(setupStart)
		
		// Warm up
		for i := 0; i < 100; i++ {
			ecs.Update(0.016)
			SparseSetUpdateTransformSystem(ecs)
			SparseSetDamageSystem(ecs)
		}
		
		// Get initial values for verification
		initialTransform := ecs.GetTransform(firstEntity)
		initialHealth := ecs.GetHealth(firstEntity)
		
		var initialX float32 = -999.0
		var initialHealthVal int32 = -1
		
		if initialTransform != nil {
			initialX = initialTransform.X
		}
		if initialHealth != nil {
			initialHealthVal = initialHealth.Current
		}
		
		// Benchmark
		benchStart := time.Now()
		
		for i := 0; i < frameCount; i++ {
			ecs.Update(0.016)
			SparseSetUpdateTransformSystem(ecs)
			SparseSetDamageSystem(ecs)
		}
		
		benchTime := time.Since(benchStart)
		avgFrameTime := float64(benchTime.Nanoseconds()) / float64(frameCount) / 1_000_000.0
		
		// Get final values for verification
		finalTransform := ecs.GetTransform(firstEntity)
		finalHealth := ecs.GetHealth(firstEntity)
		
		var finalX float32 = -999.0
		var finalHealthVal int32 = -1
		
		if finalTransform != nil {
			finalX = finalTransform.X
		}
		if finalHealth != nil {
			finalHealthVal = finalHealth.Current
		}
		
		fmt.Printf("Setup time: %v\\n", setupTime)
		fmt.Printf("Total benchmark time: %v\\n", benchTime)
		fmt.Printf("Average frame time: %.3fms\\n", avgFrameTime)
		fmt.Printf("FPS: %.1f\\n", 1000.0/avgFrameTime)
		
		// Query statistics
		transformVelocityCount := len(ecs.QueryTransformVelocity())
		healthCount := len(ecs.QueryHealth())
		fmt.Printf("Entities - Transform+Velocity: %d, Health: %d\\n", transformVelocityCount, healthCount)
		
		// Verification
		fmt.Printf("Transform verification - Initial X: %.2f, Final X: %.2f, Delta: %.2f\\n", 
			initialX, finalX, finalX-initialX)
		if initialHealthVal >= 0 {
			fmt.Printf("Health verification - Initial: %d, Final: %d\\n", initialHealthVal, finalHealthVal)
		}
	}
	
	fmt.Println("\\n=== End of Go Sparse Set Performance Test ===")
}