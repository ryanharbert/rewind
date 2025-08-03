using System;
using System.Diagnostics;

namespace EcsPerformanceTest
{
    class CSharpOptimizedTest
    {
        static void Main(string[] args)
        {
            Console.WriteLine("C# ECS Optimization Comparison: Original vs Ultra-Optimized");
            Console.WriteLine("===========================================================\n");

            int[] entityCounts = { 100, 250, 500, 750, 1000 };
            int frames = 10000;
            int warmupFrames = 100;

            foreach (var entityCount in entityCounts)
            {
                Console.WriteLine($"\nTesting with {entityCount} entities ({frames} frames):");
                Console.WriteLine("----------------------------------------");

                // Test Original C# Bitset ECS
                var originalTime = TestOriginalBitsetEcs(entityCount, frames, warmupFrames);
                
                // Force garbage collection between tests
                GC.Collect();
                GC.WaitForPendingFinalizers();
                GC.Collect();

                // Test Ultra-Optimized C# ECS
                var optimizedTime = TestUltraOptimizedEcs(entityCount, frames, warmupFrames);

                // Compare results
                double speedup = originalTime / optimizedTime;
                double percentage = (speedup - 1) * 100;

                Console.WriteLine($"\nComparison:");
                Console.WriteLine($"  Original:    {originalTime:F2} ms");
                Console.WriteLine($"  Optimized:   {optimizedTime:F2} ms");
                Console.WriteLine($"  Speedup:     {speedup:F2}x ({percentage:F1}% faster)");
            }

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }

        static double TestOriginalBitsetEcs(int entityCount, int frames, int warmupFrames)
        {
            Console.Write("  Original ECS: ");
            
            var setupSw = Stopwatch.StartNew();
            var ecs = new BitsetEcs.ECS(entityCount + 100);
            
            for (int i = 0; i < entityCount; i++)
            {
                uint entity = ecs.CreateEntity();
                
                ecs.AddTransform(entity, new BitsetEcs.Transform 
                { 
                    X = i * 10.0f, 
                    Y = i * 5.0f, 
                    Rotation = 0.0f
                });

                if (i % 5 < 3)
                {
                    ecs.AddVelocity(entity, new BitsetEcs.Velocity 
                    { 
                        DX = 1.0f, 
                        DY = 0.5f, 
                        Angular = 0.25f 
                    });
                }

                if (i % 5 < 2)
                {
                    ecs.AddHealth(entity, new BitsetEcs.Health { Current = 100, Max = 100 });
                }
            }
            setupSw.Stop();

            // Warmup
            for (int i = 0; i < warmupFrames; i++)
            {
                foreach (var entity in ecs.QueryTransformVelocity())
                {
                    ref var transform = ref ecs.GetTransform(entity);
                    ref var velocity = ref ecs.GetVelocity(entity);
                    
                    transform.X += velocity.DX;
                    transform.Y += velocity.DY;
                    transform.Rotation += velocity.Angular;
                }

                foreach (var entity in ecs.QueryHealth())
                {
                    ref var health = ref ecs.GetHealth(entity);
                    health.Current -= 1;
                    
                    if (health.Current <= 0)
                    {
                        health.Current = health.Max;
                    }
                }
            }

            var sw = Stopwatch.StartNew();
            for (int i = 0; i < frames; i++)
            {
                foreach (var entity in ecs.QueryTransformVelocity())
                {
                    ref var transform = ref ecs.GetTransform(entity);
                    ref var velocity = ref ecs.GetVelocity(entity);
                    
                    transform.X += velocity.DX;
                    transform.Y += velocity.DY;
                    transform.Rotation += velocity.Angular;
                }

                foreach (var entity in ecs.QueryHealth())
                {
                    ref var health = ref ecs.GetHealth(entity);
                    health.Current -= 1;
                    
                    if (health.Current <= 0)
                    {
                        health.Current = health.Max;
                    }
                }
            }
            sw.Stop();

            ecs.Dispose();

            Console.WriteLine($"Setup: {setupSw.ElapsedMilliseconds}ms, Run: {sw.ElapsedMilliseconds}ms");
            return sw.Elapsed.TotalMilliseconds;
        }

        static double TestUltraOptimizedEcs(int entityCount, int frames, int warmupFrames)
        {
            Console.Write("  Ultra-Optimized ECS: ");
            
            var setupSw = Stopwatch.StartNew();
            var ecs = new UltraOptimizedECS(entityCount + 100);
            
            for (int i = 0; i < entityCount; i++)
            {
                uint entity = ecs.CreateEntity();
                
                ecs.AddTransform(entity, new Transform 
                { 
                    X = i * 10.0f, 
                    Y = i * 5.0f, 
                    Z = i * 2.0f,
                    RotationX = 0.0f,
                    RotationY = 0.0f,
                    RotationZ = 0.0f
                });

                if (i % 5 < 3)
                {
                    ecs.AddVelocity(entity, new Velocity 
                    { 
                        DX = 1.0f, 
                        DY = 0.5f, 
                        DZ = 0.25f 
                    });
                }

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

            var sw = Stopwatch.StartNew();
            for (int i = 0; i < frames; i++)
            {
                ecs.UpdateTransformSystem();
                ecs.UpdateDamageSystem();
            }
            sw.Stop();

            ecs.Dispose();

            Console.WriteLine($"Setup: {setupSw.ElapsedMilliseconds}ms, Run: {sw.ElapsedMilliseconds}ms");
            return sw.Elapsed.TotalMilliseconds;
        }
    }
}