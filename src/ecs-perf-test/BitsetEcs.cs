using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Numerics;

namespace BitsetEcs
{
    public static class EntityConstants
    {
        public const uint InvalidEntity = 0xFFFFFFFF;
        public const int EntityLimitLarge = 1024;
    }

    // High-performance bitset using Span<ulong>
    public unsafe struct BitSet
    {
        private readonly ulong* _words;
        private readonly int _wordCount;
        private readonly int _size;

        public BitSet(int size)
        {
            _size = size;
            _wordCount = (size + 63) / 64;
            _words = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Set(int index)
        {
            if ((uint)index >= (uint)_size) return;
            int wordIndex = index >> 6; // / 64
            int bitIndex = index & 63;  // % 64
            _words[wordIndex] |= 1UL << bitIndex;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Unset(int index)
        {
            if ((uint)index >= (uint)_size) return;
            int wordIndex = index >> 6;
            int bitIndex = index & 63;
            _words[wordIndex] &= ~(1UL << bitIndex);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public bool IsSet(int index)
        {
            if ((uint)index >= (uint)_size) return false;
            int wordIndex = index >> 6;
            int bitIndex = index & 63;
            return (_words[wordIndex] & (1UL << bitIndex)) != 0;
        }

        public void Clear()
        {
            var span = new Span<ulong>(_words, _wordCount);
            span.Clear();
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void IntersectWith(in BitSet other, ref BitSet result)
        {
            int minCount = Math.Min(_wordCount, other._wordCount);
            for (int i = 0; i < minCount; i++)
            {
                result._words[i] = _words[i] & other._words[i];
            }
            // Clear remaining words in result
            for (int i = minCount; i < result._wordCount; i++)
            {
                result._words[i] = 0;
            }
        }

        public int Count()
        {
            int count = 0;
            for (int i = 0; i < _wordCount; i++)
            {
                count += BitOperations.PopCount(_words[i]);
            }
            return count;
        }

        public BitSetEnumerator GetEnumerator() => new BitSetEnumerator(this);

        public void Dispose()
        {
            if (_words != null)
            {
                NativeMemory.Free(_words);
            }
        }

        public ref struct BitSetEnumerator
        {
            private readonly ulong* _words;
            private readonly int _wordCount;
            private int _wordIndex;
            private ulong _currentWord;
            private int _baseIndex;

            internal BitSetEnumerator(BitSet bitset)
            {
                _words = bitset._words;
                _wordCount = bitset._wordCount;
                _wordIndex = 0;
                _currentWord = 0;
                _baseIndex = 0;
                
                // Find first non-zero word
                while (_wordIndex < _wordCount && _words[_wordIndex] == 0)
                {
                    _wordIndex++;
                }
                
                if (_wordIndex < _wordCount)
                {
                    _currentWord = _words[_wordIndex];
                    _baseIndex = _wordIndex * 64;
                }
            }

            public int Current { get; private set; }

            public bool MoveNext()
            {
                while (_wordIndex < _wordCount)
                {
                    if (_currentWord != 0)
                    {
                        int bitIndex = BitOperations.TrailingZeroCount(_currentWord);
                        Current = _baseIndex + bitIndex;
                        _currentWord &= _currentWord - 1; // Clear lowest bit
                        return true;
                    }

                    _wordIndex++;
                    if (_wordIndex < _wordCount)
                    {
                        _currentWord = _words[_wordIndex];
                        _baseIndex = _wordIndex * 64;
                    }
                }
                return false;
            }
        }
    }

    // Component storage using spans for maximum performance
    public class ComponentStorage<T> where T : struct
    {
        private T[] _dense;
        private BitSet _entityBitset;
        private uint[] _entityToIndex;
        private uint[] _indexToEntity;
        private int _count;
        private readonly int _maxEntities;

        public ComponentStorage(int maxEntities)
        {
            _maxEntities = maxEntities;
            _dense = new T[64]; // Start small, will grow
            _entityBitset = new BitSet(maxEntities);
            _entityToIndex = new uint[maxEntities];
            _indexToEntity = new uint[maxEntities];
            _count = 0;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Add(uint entity, in T component)
        {
            if (_entityBitset.IsSet((int)entity)) return;

            if (_count >= _dense.Length)
            {
                Array.Resize(ref _dense, _dense.Length * 2);
            }

            uint index = (uint)_count;
            _dense[index] = component;
            _indexToEntity[index] = entity;
            _entityToIndex[entity] = index;
            _entityBitset.Set((int)entity);
            _count++;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public ref T Get(uint entity)
        {
            return ref _dense[_entityToIndex[entity]];
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public bool Has(uint entity)
        {
            return _entityBitset.IsSet((int)entity);
        }

        public bool Remove(uint entity)
        {
            if (!_entityBitset.IsSet((int)entity)) return false;

            uint index = _entityToIndex[entity];
            int lastIndex = _count - 1;

            if (index != lastIndex)
            {
                uint lastEntity = _indexToEntity[lastIndex];
                _dense[index] = _dense[lastIndex];
                _indexToEntity[index] = lastEntity;
                _entityToIndex[lastEntity] = index;
            }

            _count--;
            _entityBitset.Unset((int)entity);
            return true;
        }

        public int Count => _count;
        public ref BitSet EntityBitset => ref _entityBitset;
        public Span<T> DenseSpan => _dense.AsSpan(0, _count);

        public void Dispose()
        {
            _entityBitset.Dispose();
        }
    }

    // Components
    public struct Transform
    {
        public float X;
        public float Y;
        public float Rotation;
    }

    public struct Velocity
    {
        public float DX;
        public float DY;
        public float Angular;
    }

    public struct Health
    {
        public int Current;
        public int Max;
    }

    // ECS implementation
    public class ECS : IDisposable
    {
        private ComponentStorage<Transform> _transforms;
        private ComponentStorage<Velocity> _velocities;
        private ComponentStorage<Health> _healths;
        private BitSet _activeEntities;
        private uint _nextEntity;
        private uint _entityCount;
        private readonly int _maxEntities;
        
        // Reusable bitsets for queries
        private BitSet _queryResult;
        private BitSet _queryTemp;

        public float DeltaTime { get; set; }

        public ECS(int maxEntities)
        {
            _maxEntities = maxEntities;
            _transforms = new ComponentStorage<Transform>(maxEntities);
            _velocities = new ComponentStorage<Velocity>(maxEntities);
            _healths = new ComponentStorage<Health>(maxEntities);
            _activeEntities = new BitSet(maxEntities);
            _queryResult = new BitSet(maxEntities);
            _queryTemp = new BitSet(maxEntities);
            _nextEntity = 0;
            _entityCount = 0;
        }

        public uint CreateEntity()
        {
            uint entity = _nextEntity;
            while (entity < _maxEntities && _activeEntities.IsSet((int)entity))
            {
                entity++;
            }

            if (entity >= _maxEntities)
            {
                throw new InvalidOperationException($"Entity limit exceeded: {_maxEntities}");
            }

            _activeEntities.Set((int)entity);
            _entityCount++;
            _nextEntity = entity + 1;

            return entity;
        }

        public void DestroyEntity(uint entity)
        {
            if (!_activeEntities.IsSet((int)entity)) return;

            _transforms.Remove(entity);
            _velocities.Remove(entity);
            _healths.Remove(entity);

            _activeEntities.Unset((int)entity);
            _entityCount--;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddTransform(uint entity, in Transform component)
        {
            _transforms.Add(entity, component);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddVelocity(uint entity, in Velocity component)
        {
            _velocities.Add(entity, component);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddHealth(uint entity, in Health component)
        {
            _healths.Add(entity, component);
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

        // Query for Transform + Velocity
        public TransformVelocityQuery QueryTransformVelocity()
        {
            // Copy active entities to result
            _activeEntities.IntersectWith(_activeEntities, ref _queryResult);
            
            // Intersect with transforms
            _transforms.EntityBitset.IntersectWith(_queryResult, ref _queryTemp);
            (_queryResult, _queryTemp) = (_queryTemp, _queryResult);
            
            // Intersect with velocities
            _velocities.EntityBitset.IntersectWith(_queryResult, ref _queryTemp);
            (_queryResult, _queryTemp) = (_queryTemp, _queryResult);

            return new TransformVelocityQuery(this, _queryResult);
        }

        // Query for Health only
        public HealthQuery QueryHealth()
        {
            _activeEntities.IntersectWith(_healths.EntityBitset, ref _queryResult);
            return new HealthQuery(this, _queryResult);
        }

        public void Update(float deltaTime)
        {
            DeltaTime = deltaTime;
        }

        public void Dispose()
        {
            _transforms?.Dispose();
            _velocities?.Dispose();
            _healths?.Dispose();
            _activeEntities.Dispose();
            _queryResult.Dispose();
            _queryTemp.Dispose();
        }

        public ref struct TransformVelocityQuery
        {
            private readonly ECS _ecs;
            private BitSet.BitSetEnumerator _enumerator;

            public TransformVelocityQuery(ECS ecs, BitSet bitset)
            {
                _ecs = ecs;
                _enumerator = bitset.GetEnumerator();
            }

            public bool MoveNext(out uint entity, out Transform transform, out Velocity velocity)
            {
                if (_enumerator.MoveNext())
                {
                    entity = (uint)_enumerator.Current;
                    transform = _ecs._transforms.Get(entity);
                    velocity = _ecs._velocities.Get(entity);
                    return true;
                }
                entity = 0;
                transform = default;
                velocity = default;
                return false;
            }
        }

        public ref struct HealthQuery
        {
            private readonly ECS _ecs;
            private BitSet.BitSetEnumerator _enumerator;

            public HealthQuery(ECS ecs, BitSet bitset)
            {
                _ecs = ecs;
                _enumerator = bitset.GetEnumerator();
            }

            public bool MoveNext(out uint entity, out Health health)
            {
                if (_enumerator.MoveNext())
                {
                    entity = (uint)_enumerator.Current;
                    health = _ecs._healths.Get(entity);
                    return true;
                }
                entity = 0;
                health = default;
                return false;
            }
        }
    }

    // Systems
    public static class Systems
    {
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public static void UpdateTransformSystem(ECS ecs)
        {
            var query = ecs.QueryTransformVelocity();
            float deltaTime = ecs.DeltaTime;

            while (query.MoveNext(out uint entity, out Transform transform, out Velocity velocity))
            {
                transform.X += velocity.DX * deltaTime;
                transform.Y += velocity.DY * deltaTime;
                transform.Rotation += velocity.Angular * deltaTime;

                if (transform.Rotation > 360.0f)
                    transform.Rotation -= 360.0f;
                else if (transform.Rotation < 0.0f)
                    transform.Rotation += 360.0f;

                ecs.GetTransform(entity) = transform;
            }
        }

        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public static void DamageSystem(ECS ecs)
        {
            var query = ecs.QueryHealth();

            while (query.MoveNext(out uint entity, out Health health))
            {
                health.Current--;
                if (health.Current < 0)
                    health.Current = health.Max;

                ecs.GetHealth(entity) = health;
            }
        }
    }

    // Performance test
    class Program
    {
        static void Main()
        {
            Console.WriteLine("=== C# Bitset ECS Performance Test (with Spans) ===");
            Console.WriteLine("Testing with transform updates and damage system\n");

            int[] entityCounts = { 100, 250, 500, 750, 1000 };
            const int frameCount = 10000;

            foreach (int entityCount in entityCounts)
            {
                Console.WriteLine($"\n--- Testing {entityCount} entities for {frameCount} frames ---");

                using var ecs = new ECS(EntityConstants.EntityLimitLarge);

                var setupTimer = Stopwatch.StartNew();

                // Create entities
                for (int i = 0; i < entityCount; i++)
                {
                    uint entity = ecs.CreateEntity();

                    // All entities get transform
                    ecs.AddTransform(entity, new Transform
                    {
                        X = i % 100,
                        Y = i / 100,
                        Rotation = 0.0f
                    });

                    // 60% get velocity (moving entities)
                    if (i % 5 < 3)
                    {
                        ecs.AddVelocity(entity, new Velocity
                        {
                            DX = ((i % 10) - 5) * 10.0f,
                            DY = ((i % 7) - 3) * 10.0f,
                            Angular = i % 360
                        });
                    }

                    // 40% get health
                    if (i % 5 < 2)
                    {
                        ecs.AddHealth(entity, new Health
                        {
                            Current = 100,
                            Max = 100
                        });
                    }
                }

                setupTimer.Stop();

                // Warm up
                for (int i = 0; i < 100; i++)
                {
                    ecs.Update(0.016f);
                    Systems.UpdateTransformSystem(ecs);
                    Systems.DamageSystem(ecs);
                }

                // Force GC before benchmark
                GC.Collect();
                GC.WaitForPendingFinalizers();
                GC.Collect();

                // Benchmark
                var benchTimer = Stopwatch.StartNew();

                for (int i = 0; i < frameCount; i++)
                {
                    ecs.Update(0.016f);
                    Systems.UpdateTransformSystem(ecs);
                    Systems.DamageSystem(ecs);
                }

                benchTimer.Stop();

                double avgFrameTime = benchTimer.Elapsed.TotalMilliseconds / frameCount;

                Console.WriteLine($"Setup time: {setupTimer.ElapsedMilliseconds}ms");
                Console.WriteLine($"Total benchmark time: {benchTimer.ElapsedMilliseconds}ms");
                Console.WriteLine($"Average frame time: {avgFrameTime:F3}ms");
                Console.WriteLine($"FPS: {1000.0 / avgFrameTime:F1}");
            }

            Console.WriteLine("\n=== End of C# Performance Test ===");
        }
    }
}