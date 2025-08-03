using System;
using System.Diagnostics;

namespace EcsPerformanceTest
{
    class EcsComparisonTest
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
            var ecs = new BitsetECS();
            
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