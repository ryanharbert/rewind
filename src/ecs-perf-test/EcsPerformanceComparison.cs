using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace EcsPerformanceTest
{
    // Shared component definitions
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

    // Sparse Set ECS Implementation
    public class SparseSetComponentStorage<T> where T : struct
    {
        private T[] _dense;
        private Dictionary<uint, uint> _sparse;
        private uint[] _entities;
        private uint _count;

        public SparseSetComponentStorage(int capacity)
        {
            _dense = new T[capacity];
            _sparse = new Dictionary<uint, uint>(capacity);
            _entities = new uint[capacity];
            _count = 0;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Add(uint entity, T component)
        {
            if (!_sparse.ContainsKey(entity))
            {
                uint index = _count;
                _sparse[entity] = index;
                _entities[index] = entity;
                _dense[index] = component;
                _count++;
            }
            else
            {
                _dense[_sparse[entity]] = component;
            }
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public ref T Get(uint entity)
        {
            return ref _dense[_sparse[entity]];
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public bool Has(uint entity)
        {
            return _sparse.ContainsKey(entity);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Remove(uint entity)
        {
            if (_sparse.TryGetValue(entity, out uint index))
            {
                uint lastIndex = _count - 1;
                if (index != lastIndex)
                {
                    _dense[index] = _dense[lastIndex];
                    uint lastEntity = _entities[lastIndex];
                    _entities[index] = lastEntity;
                    _sparse[lastEntity] = index;
                }
                _sparse.Remove(entity);
                _count--;
            }
        }

        public uint Count => _count;
        public T[] DenseArray => _dense;
        public uint[] EntityArray => _entities;
    }

    public class SparseSetECS
    {
        private const int InitialCapacity = 1024;
        private const ulong TransformMask = 1UL << 0;
        private const ulong VelocityMask = 1UL << 1;
        private const ulong HealthMask = 1UL << 2;

        private Dictionary<uint, ulong> _componentMasks;
        private SparseSetComponentStorage<Transform> _transforms;
        private SparseSetComponentStorage<Velocity> _velocities;
        private SparseSetComponentStorage<Health> _healths;
        private uint _nextEntityId;
        private HashSet<uint> _activeEntities;

        public SparseSetECS()
        {
            _componentMasks = new Dictionary<uint, ulong>(InitialCapacity);
            _transforms = new SparseSetComponentStorage<Transform>(InitialCapacity);
            _velocities = new SparseSetComponentStorage<Velocity>(InitialCapacity);
            _healths = new SparseSetComponentStorage<Health>(InitialCapacity);
            _nextEntityId = 0;
            _activeEntities = new HashSet<uint>(InitialCapacity);
        }

        public uint CreateEntity()
        {
            uint entity = _nextEntityId++;
            _componentMasks[entity] = 0;
            _activeEntities.Add(entity);
            return entity;
        }

        public void DestroyEntity(uint entity)
        {
            if (_activeEntities.Remove(entity))
            {
                _transforms.Remove(entity);
                _velocities.Remove(entity);
                _healths.Remove(entity);
                _componentMasks.Remove(entity);
            }
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddTransform(uint entity, Transform transform)
        {
            _transforms.Add(entity, transform);
            _componentMasks[entity] |= TransformMask;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddVelocity(uint entity, Velocity velocity)
        {
            _velocities.Add(entity, velocity);
            _componentMasks[entity] |= VelocityMask;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddHealth(uint entity, Health health)
        {
            _healths.Add(entity, health);
            _componentMasks[entity] |= HealthMask;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public ref Transform GetTransform(uint entity)
        {
            return ref _transforms.Get(entity);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public ref Velocity GetVelocity(uint entity)
        {
            return ref _velocities.Get(entity);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public ref Health GetHealth(uint entity)
        {
            return ref _healths.Get(entity);
        }

        public List<uint> QueryTransformVelocity()
        {
            ulong requiredMask = TransformMask | VelocityMask;
            var results = new List<uint>();
            
            foreach (var entity in _activeEntities)
            {
                if ((_componentMasks[entity] & requiredMask) == requiredMask)
                {
                    results.Add(entity);
                }
            }
            
            return results;
        }

        public List<uint> QueryHealth()
        {
            var results = new List<uint>();
            
            foreach (var entity in _activeEntities)
            {
                if ((_componentMasks[entity] & HealthMask) == HealthMask)
                {
                    results.Add(entity);
                }
            }
            
            return results;
        }

        public void UpdateTransformSystem()
        {
            var entities = QueryTransformVelocity();
            foreach (var entity in entities)
            {
                ref var transform = ref GetTransform(entity);
                ref var velocity = ref GetVelocity(entity);
                
                transform.X += velocity.DX;
                transform.Y += velocity.DY;
                transform.Z += velocity.DZ;
                
                transform.RotationX += 0.01f;
                transform.RotationY += 0.02f;
                transform.RotationZ += 0.03f;
            }
        }

        public void UpdateDamageSystem()
        {
            var entities = QueryHealth();
            foreach (var entity in entities)
            {
                ref var health = ref GetHealth(entity);
                health.Value -= 1.0f;
                
                if (health.Value <= 0)
                {
                    health.Value = 100.0f;
                }
            }
        }

        public int ActiveEntityCount => _activeEntities.Count;
    }

    // Main test program
    class EcsPerformanceComparison
    {
        static void Main(string[] args)
        {
            Console.WriteLine("ECS Performance Comparison: Bitset vs Sparse Set");
            Console.WriteLine("================================================\n");

            int[] entityCounts = { 100, 250, 500, 750, 1000 };
            int frames = 10000;
            int warmupFrames = 100;

            foreach (var entityCount in entityCounts)
            {
                Console.WriteLine($"\nTesting with {entityCount} entities ({frames} frames):");
                Console.WriteLine("----------------------------------------");

                // Test Bitset ECS
                var bitsetTime = TestBitsetEcs(entityCount, frames, warmupFrames);
                
                // Force garbage collection between tests
                GC.Collect();
                GC.WaitForPendingFinalizers();
                GC.Collect();

                // Test Sparse Set ECS
                var sparseSetTime = TestSparseSetEcs(entityCount, frames, warmupFrames);

                // Compare results
                double speedup = bitsetTime / sparseSetTime;
                string faster = speedup > 1 ? "Sparse Set" : "Bitset";
                double percentage = Math.Abs(speedup - 1) * 100;

                Console.WriteLine($"\nComparison:");
                Console.WriteLine($"  Bitset:     {bitsetTime:F2} ms");
                Console.WriteLine($"  Sparse Set: {sparseSetTime:F2} ms");
                Console.WriteLine($"  {faster} is {percentage:F1}% faster");
            }

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }

        static double TestBitsetEcs(int entityCount, int frames, int warmupFrames)
        {
            Console.Write("  Bitset ECS: ");
            
            // Setup
            var setupSw = Stopwatch.StartNew();
            var ecs = new BitsetEcs.ECS(entityCount + 100); // Add some buffer
            
            // Create entities with pattern: 100% Transform, 60% Velocity, 40% Health
            for (int i = 0; i < entityCount; i++)
            {
                uint entity = ecs.CreateEntity();
                
                // All entities get Transform
                ecs.AddTransform(entity, new BitsetEcs.Transform 
                { 
                    X = i * 10.0f, 
                    Y = i * 5.0f, 
                    Rotation = 0.0f
                });

                // 60% get Velocity (3 out of 5)
                if (i % 5 < 3)
                {
                    ecs.AddVelocity(entity, new BitsetEcs.Velocity 
                    { 
                        DX = 1.0f, 
                        DY = 0.5f, 
                        Angular = 0.25f 
                    });
                }

                // 40% get Health (2 out of 5)
                if (i % 5 < 2)
                {
                    ecs.AddHealth(entity, new BitsetEcs.Health { Current = 100, Max = 100 });
                }
            }
            setupSw.Stop();

            // Warmup
            for (int i = 0; i < warmupFrames; i++)
            {
                // Transform system
                var transformQuery = ecs.QueryTransformVelocity();
                while (transformQuery.MoveNext(out uint entity, out BitsetEcs.Transform transform, out BitsetEcs.Velocity velocity))
                {
                    transform.X += velocity.DX;
                    transform.Y += velocity.DY;
                    transform.Rotation += velocity.Angular;
                    ecs.GetTransform(entity) = transform;
                }

                // Damage system
                var healthQuery = ecs.QueryHealth();
                while (healthQuery.MoveNext(out uint entity, out BitsetEcs.Health health))
                {
                    health.Current -= 1;
                    
                    if (health.Current <= 0)
                    {
                        health.Current = health.Max;
                    }
                    ecs.GetHealth(entity) = health;
                }
            }

            // Actual benchmark
            var sw = Stopwatch.StartNew();
            for (int i = 0; i < frames; i++)
            {
                // Transform system
                var transformQuery = ecs.QueryTransformVelocity();
                while (transformQuery.MoveNext(out uint entity, out BitsetEcs.Transform transform, out BitsetEcs.Velocity velocity))
                {
                    transform.X += velocity.DX;
                    transform.Y += velocity.DY;
                    transform.Rotation += velocity.Angular;
                    ecs.GetTransform(entity) = transform;
                }

                // Damage system
                var healthQuery = ecs.QueryHealth();
                while (healthQuery.MoveNext(out uint entity, out BitsetEcs.Health health))
                {
                    health.Current -= 1;
                    
                    if (health.Current <= 0)
                    {
                        health.Current = health.Max;
                    }
                    ecs.GetHealth(entity) = health;
                }
            }
            sw.Stop();

            ecs.Dispose();

            Console.WriteLine($"Setup: {setupSw.ElapsedMilliseconds}ms, Run: {sw.ElapsedMilliseconds}ms");
            return sw.Elapsed.TotalMilliseconds;
        }

        static double TestSparseSetEcs(int entityCount, int frames, int warmupFrames)
        {
            Console.Write("  Sparse Set ECS: ");
            
            // Setup
            var setupSw = Stopwatch.StartNew();
            var ecs = new SparseSetECS();
            
            // Create entities with pattern: 100% Transform, 60% Velocity, 40% Health
            for (int i = 0; i < entityCount; i++)
            {
                uint entity = ecs.CreateEntity();
                
                // All entities get Transform
                ecs.AddTransform(entity, new Transform 
                { 
                    X = i * 10.0f, 
                    Y = i * 5.0f, 
                    Z = i * 2.0f,
                    RotationX = 0.0f,
                    RotationY = 0.0f,
                    RotationZ = 0.0f
                });

                // 60% get Velocity (3 out of 5)
                if (i % 5 < 3)
                {
                    ecs.AddVelocity(entity, new Velocity 
                    { 
                        DX = 1.0f, 
                        DY = 0.5f, 
                        DZ = 0.25f 
                    });
                }

                // 40% get Health (2 out of 5)
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

            // Actual benchmark
            var sw = Stopwatch.StartNew();
            for (int i = 0; i < frames; i++)
            {
                ecs.UpdateTransformSystem();
                ecs.UpdateDamageSystem();
            }
            sw.Stop();

            Console.WriteLine($"Setup: {setupSw.ElapsedMilliseconds}ms, Run: {sw.ElapsedMilliseconds}ms");
            return sw.Elapsed.TotalMilliseconds;
        }
    }
}