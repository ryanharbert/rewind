using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Runtime.Intrinsics;
using System.Runtime.Intrinsics.X86;

namespace EcsPerformanceTest
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

    // Ultra-optimized C# ECS implementation
    public unsafe struct UltraOptimizedBitSet
    {
        private readonly ulong* _words;
        private readonly int _wordCount;
        private readonly int _size;

        public UltraOptimizedBitSet(int size)
        {
            _size = size;
            _wordCount = (size + 63) / 64;
            _words = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Set(int index)
        {
            if ((uint)index >= (uint)_size) return;
            int wordIndex = index >> 6;
            int bitIndex = index & 63;
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

        // SIMD-optimized triple intersection
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void TripleIntersection(in UltraOptimizedBitSet set1, in UltraOptimizedBitSet set2, in UltraOptimizedBitSet set3)
        {
            int minCount = Math.Min(_wordCount, Math.Min(set1._wordCount, Math.Min(set2._wordCount, set3._wordCount)));
            
            if (Avx2.IsSupported && minCount >= 4)
            {
                int vectorCount = minCount / 4;
                for (int i = 0; i < vectorCount; i++)
                {
                    int offset = i * 4;
                    var vec1 = Avx2.LoadVector256(&set1._words[offset]);
                    var vec2 = Avx2.LoadVector256(&set2._words[offset]);
                    var vec3 = Avx2.LoadVector256(&set3._words[offset]);
                    var result = Avx2.And(Avx2.And(vec1, vec2), vec3);
                    Avx2.Store(&_words[offset], result);
                }
                
                // Handle remaining words
                for (int i = vectorCount * 4; i < minCount; i++)
                {
                    _words[i] = set1._words[i] & set2._words[i] & set3._words[i];
                }
            }
            else
            {
                // Fallback scalar
                for (int i = 0; i < minCount; i++)
                {
                    _words[i] = set1._words[i] & set2._words[i] & set3._words[i];
                }
            }
            
            // Clear remaining words
            for (int i = minCount; i < _wordCount; i++)
            {
                _words[i] = 0;
            }
        }

        public void Clear()
        {
            var span = new Span<ulong>(_words, _wordCount);
            span.Clear();
        }

        public void Dispose()
        {
            if (_words != null)
            {
                NativeMemory.Free(_words);
            }
        }

        public ulong* Words => _words;
        public int WordCount => _wordCount;
    }

    // Ultra-optimized component storage
    public unsafe class UltraOptimizedComponentStorage<T> where T : unmanaged
    {
        private T* _dense;
        private uint* _entityToIndex;
        private uint* _indexToEntity;
        private UltraOptimizedBitSet _entityBitset;
        private uint _count;
        private uint _capacity;

        public UltraOptimizedComponentStorage(int maxEntities)
        {
            _capacity = (uint)maxEntities;
            _dense = (T*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(T)));
            _entityToIndex = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            _indexToEntity = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            _entityBitset = new UltraOptimizedBitSet(maxEntities);
            _count = 0;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void Add(uint entity, in T component)
        {
            if (_entityBitset.IsSet((int)entity)) return;
            
            uint index = _count;
            _dense[index] = component;
            _entityToIndex[entity] = index;
            _indexToEntity[index] = entity;
            _entityBitset.Set((int)entity);
            _count++;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public T* GetDirectUnsafe(uint entity)
        {
            uint index = _entityToIndex[entity];
            return &_dense[index];
        }

        public void Dispose()
        {
            NativeMemory.Free(_dense);
            NativeMemory.Free(_entityToIndex);
            NativeMemory.Free(_indexToEntity);
            _entityBitset.Dispose();
        }

        public ref UltraOptimizedBitSet EntityBitset => ref _entityBitset;
        public T* DenseArray => _dense;
        public uint* EntityToIndexArray => _entityToIndex;
        public uint Count => _count;
    }

    public unsafe class UltraOptimizedECS : IDisposable
    {
        private UltraOptimizedComponentStorage<Transform> _transforms;
        private UltraOptimizedComponentStorage<Velocity> _velocities;
        private UltraOptimizedComponentStorage<Health> _healths;
        private UltraOptimizedBitSet _activeEntities;
        private UltraOptimizedBitSet _queryResult;
        private uint _nextEntity;
        private readonly int _maxEntities;

        public UltraOptimizedECS(int maxEntities)
        {
            _maxEntities = maxEntities;
            _transforms = new UltraOptimizedComponentStorage<Transform>(maxEntities);
            _velocities = new UltraOptimizedComponentStorage<Velocity>(maxEntities);
            _healths = new UltraOptimizedComponentStorage<Health>(maxEntities);
            _activeEntities = new UltraOptimizedBitSet(maxEntities);
            _queryResult = new UltraOptimizedBitSet(maxEntities);
            _nextEntity = 0;
        }

        public uint CreateEntity()
        {
            uint entity = _nextEntity++;
            _activeEntities.Set((int)entity);
            return entity;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddTransform(uint entity, Transform transform)
        {
            _transforms.Add(entity, transform);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddVelocity(uint entity, Velocity velocity)
        {
            _velocities.Add(entity, velocity);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public void AddHealth(uint entity, Health health)
        {
            _healths.Add(entity, health);
        }

        // Ultra-fast system with manual bitset iteration (Zig-style)
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void UpdateTransformSystem()
        {
            // Triple intersection using SIMD
            _queryResult.TripleIntersection(_activeEntities, _transforms.EntityBitset, _velocities.EntityBitset);
            
            // Manual word iteration for maximum performance
            ulong* words = _queryResult.Words;
            int wordCount = _queryResult.WordCount;
            
            T* transforms = _transforms.DenseArray;
            Velocity* velocities = _velocities.DenseArray;
            uint* transformEntityToIndex = _transforms.EntityToIndexArray;
            uint* velocityEntityToIndex = _velocities.EntityToIndexArray;
            
            for (int wordIndex = 0; wordIndex < wordCount; wordIndex++)
            {
                ulong word = words[wordIndex];
                if (word == 0) continue;
                
                uint baseEntity = (uint)(wordIndex * 64);
                
                while (word != 0)
                {
                    int bitIndex = BitOperations.TrailingZeroCount(word);
                    uint entity = baseEntity + (uint)bitIndex;
                    
                    // Direct unsafe array access
                    uint transformIndex = transformEntityToIndex[entity];
                    uint velocityIndex = velocityEntityToIndex[entity];
                    
                    Transform* transform = &transforms[transformIndex];
                    Velocity* velocity = &velocities[velocityIndex];
                    
                    // Inline math operations
                    transform->X += velocity->DX;
                    transform->Y += velocity->DY;
                    transform->Z += velocity->DZ;
                    transform->RotationX += 0.01f;
                    transform->RotationY += 0.02f;
                    transform->RotationZ += 0.03f;
                    
                    word &= word - 1; // Clear lowest bit
                }
            }
        }

        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void UpdateDamageSystem()
        {
            // Intersection using SIMD
            _queryResult.TripleIntersection(_activeEntities, _healths.EntityBitset, _healths.EntityBitset);
            
            ulong* words = _queryResult.Words;
            int wordCount = _queryResult.WordCount;
            
            Health* healths = _healths.DenseArray;
            uint* healthEntityToIndex = _healths.EntityToIndexArray;
            
            for (int wordIndex = 0; wordIndex < wordCount; wordIndex++)
            {
                ulong word = words[wordIndex];
                if (word == 0) continue;
                
                uint baseEntity = (uint)(wordIndex * 64);
                
                while (word != 0)
                {
                    int bitIndex = BitOperations.TrailingZeroCount(word);
                    uint entity = baseEntity + (uint)bitIndex;
                    
                    uint healthIndex = healthEntityToIndex[entity];
                    Health* health = &healths[healthIndex];
                    
                    health->Value -= 1.0f;
                    if (health->Value <= 0)
                    {
                        health->Value = 100.0f;
                    }
                    
                    word &= word - 1;
                }
            }
        }

        public void Dispose()
        {
            _transforms?.Dispose();
            _velocities?.Dispose();
            _healths?.Dispose();
            _activeEntities.Dispose();
            _queryResult.Dispose();
        }

        public int ActiveEntityCount => (int)_transforms.Count;
    }
}