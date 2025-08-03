using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Diagnostics;

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

    // Ultra-fast C# implementation using manual bitset iteration
    public unsafe class CSharpUltraFast
    {
        
        // Direct component storage arrays
        private Transform* _transforms;
        private Velocity* _velocities;
        private Health* _healths;
        
        // Bitsets using raw pointers
        private ulong* _activeBits;
        private ulong* _transformBits;
        private ulong* _velocityBits;
        private ulong* _healthBits;
        private ulong* _queryBits;
        
        // Entity mapping
        private uint* _transformEntityToIndex;
        private uint* _velocityEntityToIndex;
        private uint* _healthEntityToIndex;
        
        private readonly int _maxEntities;
        private readonly int _wordCount;
        private uint _nextEntity;
        private uint _transformCount;
        private uint _velocityCount;
        private uint _healthCount;

        public CSharpUltraFast(int maxEntities)
        {
            _maxEntities = maxEntities;
            _wordCount = (maxEntities + 63) / 64;
            
            // Allocate component arrays
            _transforms = (Transform*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(Transform)));
            _velocities = (Velocity*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(Velocity)));
            _healths = (Health*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(Health)));
            
            // Allocate bitset arrays
            _activeBits = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
            _transformBits = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
            _velocityBits = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
            _healthBits = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
            _queryBits = (ulong*)NativeMemory.AllocZeroed((nuint)(_wordCount * sizeof(ulong)));
            
            // Allocate entity mapping arrays
            _transformEntityToIndex = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            _velocityEntityToIndex = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            _healthEntityToIndex = (uint*)NativeMemory.Alloc((nuint)(maxEntities * sizeof(uint)));
            
            _nextEntity = 0;
            _transformCount = 0;
            _velocityCount = 0;
            _healthCount = 0;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private void SetBit(ulong* bits, uint index)
        {
            int wordIndex = (int)(index >> 6);
            int bitIndex = (int)(index & 63);
            bits[wordIndex] |= 1UL << bitIndex;
        }

        public uint CreateEntity()
        {
            uint entity = _nextEntity++;
            SetBit(_activeBits, entity);
            return entity;
        }

        public void AddTransform(uint entity, Transform transform)
        {
            uint index = _transformCount++;
            _transforms[index] = transform;
            _transformEntityToIndex[entity] = index;
            SetBit(_transformBits, entity);
        }

        public void AddVelocity(uint entity, Velocity velocity)
        {
            uint index = _velocityCount++;
            _velocities[index] = velocity;
            _velocityEntityToIndex[entity] = index;
            SetBit(_velocityBits, entity);
        }

        public void AddHealth(uint entity, Health health)
        {
            uint index = _healthCount++;
            _healths[index] = health;
            _healthEntityToIndex[entity] = index;
            SetBit(_healthBits, entity);
        }

        // Ultra-fast system using manual bitset iteration (Zig-style)
        [MethodImpl(MethodImplOptions.AggressiveOptimization)]
        public void UpdateTransformSystem()
        {
            // Triple intersection manually
            for (int i = 0; i < _wordCount; i++)
            {
                _queryBits[i] = _activeBits[i] & _transformBits[i] & _velocityBits[i];
            }
            
            // Manual word iteration for maximum performance
            for (int wordIndex = 0; wordIndex < _wordCount; wordIndex++)
            {
                ulong word = _queryBits[wordIndex];
                if (word == 0) continue;
                
                uint baseEntity = (uint)(wordIndex * 64);
                
                while (word != 0)
                {
                    int bitIndex = BitOperations.TrailingZeroCount(word);
                    uint entity = baseEntity + (uint)bitIndex;
                    
                    // Direct unsafe array access
                    uint transformIndex = _transformEntityToIndex[entity];
                    uint velocityIndex = _velocityEntityToIndex[entity];
                    
                    Transform* transform = &_transforms[transformIndex];
                    Velocity* velocity = &_velocities[velocityIndex];
                    
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
            // Intersection for health entities
            for (int i = 0; i < _wordCount; i++)
            {
                _queryBits[i] = _activeBits[i] & _healthBits[i];
            }
            
            for (int wordIndex = 0; wordIndex < _wordCount; wordIndex++)
            {
                ulong word = _queryBits[wordIndex];
                if (word == 0) continue;
                
                uint baseEntity = (uint)(wordIndex * 64);
                
                while (word != 0)
                {
                    int bitIndex = BitOperations.TrailingZeroCount(word);
                    uint entity = baseEntity + (uint)bitIndex;
                    
                    uint healthIndex = _healthEntityToIndex[entity];
                    Health* health = &_healths[healthIndex];
                    
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
            NativeMemory.Free(_transforms);
            NativeMemory.Free(_velocities);
            NativeMemory.Free(_healths);
            NativeMemory.Free(_activeBits);
            NativeMemory.Free(_transformBits);
            NativeMemory.Free(_velocityBits);
            NativeMemory.Free(_healthBits);
            NativeMemory.Free(_queryBits);
            NativeMemory.Free(_transformEntityToIndex);
            NativeMemory.Free(_velocityEntityToIndex);
            NativeMemory.Free(_healthEntityToIndex);
        }
    }

    // Test program
    class CSharpUltraFastTest
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== C# Ultra-Fast ECS Performance Test ===");
            Console.WriteLine("Testing with manual bitset iteration and unsafe operations\n");

            int[] entityCounts = { 100, 250, 500, 750, 1000, 2000, 4000 };
            int frames = 10000;
            int warmupFrames = 100;

            foreach (var entityCount in entityCounts)
            {
                Console.WriteLine($"\n--- Testing {entityCount} entities for {frames} frames ---");

                var setupSw = Stopwatch.StartNew();
                var ecs = new CSharpUltraFast(entityCount + 100);

                // Create entities
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

                    // 60% get velocity
                    if (i % 5 < 3)
                    {
                        ecs.AddVelocity(entity, new Velocity
                        {
                            DX = 1.0f,
                            DY = 0.5f,
                            DZ = 0.25f
                        });
                    }

                    // 40% get health
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

                ecs.Dispose();
            }

            Console.WriteLine("\n=== End of C# Ultra-Fast Performance Test ===");
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}