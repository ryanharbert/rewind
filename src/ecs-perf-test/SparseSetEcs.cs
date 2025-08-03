using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace EcsPerformanceTest
{
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
}