package main

import (
	"fmt"
	"math/bits"
	"time"
)

const InvalidEntity uint32 = 0xFFFFFFFF

// EntityLimit enum
const (
	EntityLimitTiny    = 64
	EntityLimitSmall   = 256
	EntityLimitMedium  = 512
	EntityLimitLarge   = 1024
	EntityLimitHuge    = 2048
	EntityLimitMassive = 4096
)

// BitSet implementation
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

func (b *BitSet) Clear() {
	for i := range b.words {
		b.words[i] = 0
	}
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

func (b *BitSet) Clone() *BitSet {
	result := NewBitSet(b.size)
	copy(result.words, b.words)
	return result
}

// BitSet iterator
type BitSetIterator struct {
	bitset     *BitSet
	wordIndex  int
	currentWord uint64
}

func (b *BitSet) Iterator() *BitSetIterator {
	iter := &BitSetIterator{
		bitset:    b,
		wordIndex: 0,
	}
	
	// Find first non-zero word
	for iter.wordIndex < len(b.words) && b.words[iter.wordIndex] == 0 {
		iter.wordIndex++
	}
	
	if iter.wordIndex < len(b.words) {
		iter.currentWord = b.words[iter.wordIndex]
	}
	
	return iter
}

func (iter *BitSetIterator) Next() (uint32, bool) {
	for iter.wordIndex < len(iter.bitset.words) {
		if iter.currentWord != 0 {
			// Find the index of the least significant set bit
			bitIndex := bits.TrailingZeros64(iter.currentWord)
			entity := uint32(iter.wordIndex*64 + bitIndex)
			
			// Clear the least significant set bit
			iter.currentWord &= iter.currentWord - 1
			
			return entity, true
		}
		
		// Move to next word
		iter.wordIndex++
		if iter.wordIndex < len(iter.bitset.words) {
			iter.currentWord = iter.bitset.words[iter.wordIndex]
		}
	}
	
	return 0, false
}

// Component Storage
type ComponentStorage struct {
	dense         []interface{}
	entityBitset  *BitSet
	entityToIndex []uint32
	indexToEntity []uint32
	maxEntities   uint32
}

func NewComponentStorage(maxEntities uint32) *ComponentStorage {
	return &ComponentStorage{
		dense:         make([]interface{}, 0),
		entityBitset:  NewBitSet(maxEntities),
		entityToIndex: make([]uint32, maxEntities),
		indexToEntity: make([]uint32, 0),
		maxEntities:   maxEntities,
	}
}

func (s *ComponentStorage) Add(entity uint32, component interface{}) {
	if s.entityBitset.IsSet(entity) {
		return // Already exists
	}
	
	index := uint32(len(s.dense))
	s.dense = append(s.dense, component)
	s.indexToEntity = append(s.indexToEntity, entity)
	s.entityToIndex[entity] = index
	s.entityBitset.Set(entity)
}

func (s *ComponentStorage) Get(entity uint32) interface{} {
	if !s.entityBitset.IsSet(entity) {
		return nil
	}
	index := s.entityToIndex[entity]
	return s.dense[index]
}

func (s *ComponentStorage) Has(entity uint32) bool {
	return s.entityBitset.IsSet(entity)
}

func (s *ComponentStorage) Remove(entity uint32) bool {
	if !s.entityBitset.IsSet(entity) {
		return false
	}
	
	index := s.entityToIndex[entity]
	lastIndex := len(s.dense) - 1
	
	// Swap with last element for O(1) removal
	if int(index) != lastIndex {
		lastEntity := s.indexToEntity[lastIndex]
		s.dense[index] = s.dense[lastIndex]
		s.indexToEntity[index] = lastEntity
		s.entityToIndex[lastEntity] = index
	}
	
	s.dense = s.dense[:lastIndex]
	s.indexToEntity = s.indexToEntity[:lastIndex]
	s.entityBitset.Unset(entity)
	
	return true
}

func (s *ComponentStorage) Count() int {
	return len(s.dense)
}

// Component type registry
type ComponentType int

const (
	ComponentTransform ComponentType = iota
	ComponentVelocity
	ComponentHealth
	ComponentCount // Always last
)

// Components
type Transform struct {
	X, Y, Rotation float32
}

type Velocity struct {
	DX, DY, Angular float32
}

type Health struct {
	Current, Max int32
}

// Frame State
type FrameState struct {
	storages      []*ComponentStorage
	activeEntities *BitSet
	nextEntity    uint32
	entityCount   uint32
	maxEntities   uint32
}

// Query Result
type QueryResult struct {
	entity uint32
	state  *FrameState
}

func (r *QueryResult) GetTransform() *Transform {
	comp := r.state.storages[ComponentTransform].Get(r.entity)
	if comp != nil {
		return comp.(*Transform)
	}
	return nil
}

func (r *QueryResult) GetVelocity() *Velocity {
	comp := r.state.storages[ComponentVelocity].Get(r.entity)
	if comp != nil {
		return comp.(*Velocity)
	}
	return nil
}

func (r *QueryResult) GetHealth() *Health {
	comp := r.state.storages[ComponentHealth].Get(r.entity)
	if comp != nil {
		return comp.(*Health)
	}
	return nil
}

// Query
type Query struct {
	resultEntities *BitSet
	iterator       *BitSetIterator
	state          *FrameState
}

func (q *Query) Next() *QueryResult {
	entity, ok := q.iterator.Next()
	if !ok {
		return nil
	}
	
	return &QueryResult{
		entity: entity,
		state:  q.state,
	}
}

func (q *Query) Count() int {
	return q.resultEntities.Count()
}

// ECS
type ECS struct {
	state    *FrameState
	deltaTime float32
}

func NewECS(maxEntities uint32) *ECS {
	storages := make([]*ComponentStorage, ComponentCount)
	for i := range storages {
		storages[i] = NewComponentStorage(maxEntities)
	}
	
	return &ECS{
		state: &FrameState{
			storages:       storages,
			activeEntities: NewBitSet(maxEntities),
			nextEntity:     0,
			entityCount:    0,
			maxEntities:    maxEntities,
		},
	}
}

func (ecs *ECS) CreateEntity() (uint32, error) {
	entity := ecs.state.nextEntity
	for entity < ecs.state.maxEntities && ecs.state.activeEntities.IsSet(entity) {
		entity++
	}
	
	if entity >= ecs.state.maxEntities {
		return InvalidEntity, fmt.Errorf("entity limit exceeded: %d", ecs.state.maxEntities)
	}
	
	ecs.state.activeEntities.Set(entity)
	ecs.state.entityCount++
	ecs.state.nextEntity = entity + 1
	
	return entity, nil
}

func (ecs *ECS) DestroyEntity(entity uint32) {
	if !ecs.state.activeEntities.IsSet(entity) {
		return
	}
	
	// Remove from all component storages
	for _, storage := range ecs.state.storages {
		storage.Remove(entity)
	}
	
	ecs.state.activeEntities.Unset(entity)
	ecs.state.entityCount--
}

func (ecs *ECS) AddTransform(entity uint32, component *Transform) {
	ecs.state.storages[ComponentTransform].Add(entity, component)
}

func (ecs *ECS) AddVelocity(entity uint32, component *Velocity) {
	ecs.state.storages[ComponentVelocity].Add(entity, component)
}

func (ecs *ECS) AddHealth(entity uint32, component *Health) {
	ecs.state.storages[ComponentHealth].Add(entity, component)
}

func (ecs *ECS) Query(componentTypes ...ComponentType) *Query {
	// Start with active entities
	resultEntities := ecs.state.activeEntities.Clone()
	
	// Intersect with required component bitsets
	for _, compType := range componentTypes {
		componentBitset := ecs.state.storages[compType].entityBitset
		resultEntities = resultEntities.IntersectWith(componentBitset)
	}
	
	return &Query{
		resultEntities: resultEntities,
		iterator:       resultEntities.Iterator(),
		state:          ecs.state,
	}
}

func (ecs *ECS) Update(deltaTime float32) {
	ecs.deltaTime = deltaTime
}

// System functions
func UpdateTransformSystem(ecs *ECS) {
	query := ecs.Query(ComponentTransform, ComponentVelocity)
	
	for {
		result := query.Next()
		if result == nil {
			break
		}
		
		transform := result.GetTransform()
		velocity := result.GetVelocity()
		
		transform.X += velocity.DX * ecs.deltaTime
		transform.Y += velocity.DY * ecs.deltaTime
		transform.Rotation += velocity.Angular * ecs.deltaTime
		
		// Keep rotation in bounds
		if transform.Rotation > 360.0 {
			transform.Rotation -= 360.0
		} else if transform.Rotation < 0.0 {
			transform.Rotation += 360.0
		}
	}
}

func DamageSystem(ecs *ECS) {
	query := ecs.Query(ComponentHealth)
	
	for {
		result := query.Next()
		if result == nil {
			break
		}
		
		health := result.GetHealth()
		health.Current--
		if health.Current < 0 {
			health.Current = health.Max
		}
	}
}

// Performance test
func main() {
	fmt.Println("=== Go Bitset ECS Performance Test ===")
	fmt.Println("Testing with transform updates and damage system\n")
	
	entityCounts := []int{100, 250, 500, 750, 1000}
	frameCount := 10000
	
	for _, entityCount := range entityCounts {
		fmt.Printf("\n--- Testing %d entities for %d frames ---\n", entityCount, frameCount)
		
		// Initialize ECS
		ecs := NewECS(EntityLimitLarge)
		
		setupStart := time.Now()
		
		// Create entities
		for i := 0; i < entityCount; i++ {
			entity, err := ecs.CreateEntity()
			if err != nil {
				panic(err)
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
			UpdateTransformSystem(ecs)
			DamageSystem(ecs)
		}
		
		// Benchmark
		benchStart := time.Now()
		
		for i := 0; i < frameCount; i++ {
			ecs.Update(0.016)
			UpdateTransformSystem(ecs)
			DamageSystem(ecs)
		}
		
		benchTime := time.Since(benchStart)
		avgFrameTime := float64(benchTime.Nanoseconds()) / float64(frameCount) / 1_000_000.0
		
		// Count entities with each component for verification
		transformCount := ecs.state.storages[ComponentTransform].Count()
		velocityCount := ecs.state.storages[ComponentVelocity].Count()
		healthCount := ecs.state.storages[ComponentHealth].Count()
		
		fmt.Printf("Setup time: %v\n", setupTime)
		fmt.Printf("Total benchmark time: %v\n", benchTime)
		fmt.Printf("Average frame time: %.3fms\n", avgFrameTime)
		fmt.Printf("FPS: %.1f\n", 1000.0/avgFrameTime)
		fmt.Printf("Entities - Transform: %d, Velocity: %d, Health: %d\n",
			transformCount, velocityCount, healthCount)
	}
	
	fmt.Println("\n=== End of Go Performance Test ===")
}