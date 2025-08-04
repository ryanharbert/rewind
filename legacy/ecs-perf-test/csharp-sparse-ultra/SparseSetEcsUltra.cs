using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Diagnostics;

namespace SparseSetEcsUltra
{
    // Component definitions
    public struct Transform
    {
        public float X;
        public float Y;
        public float Z;
        public float RotationX;
        public float RotationY;
        public float RotationZ;
    }

    public struct Velocity
    {
        public float DX;
        public float DY;
        public float DZ;
    }

    public struct Health
    {
        public float Value;
    }

    // Component type IDs for masking
    public static class ComponentTypes
    {
        public const ulong TRANSFORM = 1UL << 0;
        public const ulong VELOCITY = 1UL << 1;
        public const ulong HEALTH = 1UL << 2;
    }

    // Ultra-fast sparse set component storage
    public unsafe class UltraSparseComponentStorage<T> where T : unmanaged
    {
        // Dense array for component data
        private T* _dense;
        
        // Sparse array for entity-to-index mapping (direct array instead of dictionary)
        private uint* _sparse;
        
        // Dense-to-entity mapping for removals
        private uint* _denseToEntity;
        
        private uint _count;
        private readonly uint _maxEntities;

        public UltraSparseComponentStorage(uint maxEntities)
        {
            _maxEntities = maxEntities;
            
            // Allocate dense component storage
            _dense = (T*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(T)));
            
            // Allocate sparse array (entity ID -> dense index)
            _sparse = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            
            // Initialize sparse array to invalid indices
            for (uint i = 0; i < maxEntities; i++)
            {
                _sparse[i] = uint.MaxValue;
            }
            
            // Allocate dense-to-entity mapping
            _denseToEntity = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            
            _count = 0;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Add(uint entity, in T component)
        {
            if (entity >= _maxEntities || HasComponent(entity)) return;
            
            uint denseIndex = _count++;
            _dense[denseIndex] = component;
            _sparse[entity] = denseIndex;
            _denseToEntity[denseIndex] = entity;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public bool HasComponent(uint entity)
        {
            return entity < _maxEntities && _sparse[entity] != uint.MaxValue;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public T* GetComponentUnsafe(uint entity)
        {
            uint denseIndex = _sparse[entity];
            return &_dense[denseIndex];
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Remove(uint entity)
        {
            if (!HasComponent(entity)) return;
            
            uint denseIndex = _sparse[entity];
            uint lastIndex = _count - 1;
            
            if (denseIndex != lastIndex)
            {
                // Move last element to removed position
                _dense[denseIndex] = _dense[lastIndex];
                uint lastEntity = _denseToEntity[lastIndex];
                _denseToEntity[denseIndex] = lastEntity;
                _sparse[lastEntity] = denseIndex;
            }
            
            _sparse[entity] = uint.MaxValue;
            _count--;
        }

        public void Dispose()
        {
            NativeMemory.Free(_dense);
            NativeMemory.Free(_sparse);
            NativeMemory.Free(_denseToEntity);
        }

        public uint Count => _count;
        public T* DenseArray => _dense;
        public uint* DenseToEntityArray => _denseToEntity;
        public uint* SparseArray => _sparse;
    }

    // Ultra-optimized sparse set ECS
    public unsafe class UltraSparseSetECS : IDisposable
    {
        private UltraSparseComponentStorage<Transform> _transforms;
        private UltraSparseComponentStorage<Velocity> _velocities;
        private UltraSparseComponentStorage<Health> _healths;
        
        // Component masks for each entity (bitset for component presence)
        private ulong* _componentMasks;
        
        // Pre-allocated query result buffers to avoid allocations
        private uint* _queryResults;
        private uint _queryResultCapacity;
        
        private uint _nextEntity;
        private readonly uint _maxEntities;

        public UltraSparseSetECS(uint maxEntities)
        {
            _maxEntities = maxEntities;
            
            _transforms = new UltraSparseComponentStorage<Transform>(maxEntities);
            _velocities = new UltraSparseComponentStorage<Velocity>(maxEntities);
            _healths = new UltraSparseComponentStorage<Health>(maxEntities);
            
            // Allocate component masks
            _componentMasks = (ulong*)NativeMemory.AllocZeroed((nuint)(maxEntities * sizeof(ulong)));
            
            // Pre-allocate query results buffer
            _queryResultCapacity = maxEntities;
            _queryResults = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            
            _nextEntity = 0;
        }

        public uint CreateEntity()
        {
            return _nextEntity++;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddTransform(uint entity, Transform transform)
        {
            _transforms.Add(entity, transform);
            _componentMasks[entity] |= ComponentTypes.TRANSFORM;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddVelocity(uint entity, Velocity velocity)
        {
            _velocities.Add(entity, velocity);
            _componentMasks[entity] |= ComponentTypes.VELOCITY;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddHealth(uint entity, Health health)
        {
            _healths.Add(entity, health);
            _componentMasks[entity] |= ComponentTypes.HEALTH;
        }

        // Ultra-fast query system using component masks and dense iteration
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        private uint QueryEntitiesWithMask(ulong requiredMask)
        {
            uint resultCount = 0;
            
            // Iterate through all created entities (could be optimized with active entity tracking)
            for (uint entity = 0; entity < _nextEntity; entity++)
            {
                if ((_componentMasks[entity] & requiredMask) == requiredMask)
                {
                    _queryResults[resultCount++] = entity;
                }
            }
            
            return resultCount;
        }

        // Transform system - requires Transform + Velocity
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void UpdateTransformSystem()
        {
            const ulong requiredMask = ComponentTypes.TRANSFORM | ComponentTypes.VELOCITY;
            uint entityCount = QueryEntitiesWithMask(requiredMask);
            
            // Process entities using direct unsafe access
            for (uint i = 0; i < entityCount; i++)
            {
                uint entity = _queryResults[i];
                
                Transform* transform = _transforms.GetComponentUnsafe(entity);
                Velocity* velocity = _velocities.GetComponentUnsafe(entity);
                
                // Inline math operations
                transform->X += velocity->DX;
                transform->Y += velocity->DY;
                transform->Z += velocity->DZ;
                transform->RotationX += 0.01f;
                transform->RotationY += 0.02f;
                transform->RotationZ += 0.03f;
            }
        }

        // Damage system - requires Health
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void UpdateDamageSystem()
        {
            const ulong requiredMask = ComponentTypes.HEALTH;
            uint entityCount = QueryEntitiesWithMask(requiredMask);
            
            for (uint i = 0; i < entityCount; i++)
            {
                uint entity = _queryResults[i];
                
                Health* health = _healths.GetComponentUnsafe(entity);
                
                health->Value -= 1.0f;
                if (health->Value <= 0)
                {
                    health->Value = 100.0f;
                }
            }
        }

        public void Dispose()
        {
            _transforms?.Dispose();
            _velocities?.Dispose();
            _healths?.Dispose();
            
            NativeMemory.Free(_componentMasks);
            NativeMemory.Free(_queryResults);
        }

        public uint ActiveEntityCount => _nextEntity;
        public uint TransformCount => _transforms.Count;
        public uint VelocityCount => _velocities.Count;
        public uint HealthCount => _healths.Count;
    }

    // Performance test comparing sparse set vs bitset
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== C# Ultra-Optimized Sparse Set ECS Performance Test ===");
            Console.WriteLine("Testing sparse set with component masks and dense storage\n");

            int[] entityCounts = { 100, 250, 500, 750, 1000, 2000, 4000 };
            int frames = 10000;
            int warmupFrames = 100;

            foreach (var entityCount in entityCounts)
            {
                Console.WriteLine($"\n--- Testing {entityCount} entities for {frames} frames ---");

                var setupSw = Stopwatch.StartNew();
                var ecs = new UltraSparseSetECS((uint)(entityCount + 100));

                // Create entities with same distribution as bitset test
                for (int i = 0; i < entityCount; i++)
                {
                    uint entity = ecs.CreateEntity();

                    // All entities get transform
                    ecs.AddTransform(entity, new Transform
                    {
                        X = i * 10.0f,
                        Y = i * 5.0f,
                        Z = i * 2.0f,
                        RotationX = 0.0f,
                        RotationY = 0.0f,
                        RotationZ = 0.0f
                    });

                    // 60% get velocity (3 out of 5)
                    if (i % 5 < 3)
                    {
                        ecs.AddVelocity(entity, new Velocity
                        {
                            DX = 1.0f,
                            DY = 0.5f,
                            DZ = 0.25f
                        });
                    }

                    // 40% get health (2 out of 5)
                    if (i % 5 < 2)
                    {
                        ecs.AddHealth(entity, new Health { Value = 100.0f });
                    }
                }
                setupSw.Stop();

                // Warmup
                for (int i = 0; i < warmupFrames; i++)
                {
                    ecs.UpdateTransformSystem();
                    ecs.UpdateDamageSystem();
                }

                // Benchmark
                var sw = Stopwatch.StartNew();
                for (int i = 0; i < frames; i++)
                {
                    ecs.UpdateTransformSystem();
                    ecs.UpdateDamageSystem();
                }
                sw.Stop();

                var avgFrameTime = (double)sw.ElapsedMilliseconds / frames;
                var fps = 1000.0 / avgFrameTime;

                Console.WriteLine($"Setup time: {setupSw.ElapsedMilliseconds}ms");
                Console.WriteLine($"Total benchmark time: {sw.ElapsedMilliseconds}ms");
                Console.WriteLine($"Average frame time: {avgFrameTime:F3}ms");
                Console.WriteLine($"FPS: {fps:F1}");
                Console.WriteLine($"Component counts - Transform: {ecs.TransformCount}, Velocity: {ecs.VelocityCount}, Health: {ecs.HealthCount}");

                ecs.Dispose();
            }

            Console.WriteLine("\n=== End of Sparse Set Performance Test ===");
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}