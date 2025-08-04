using System;
using System.Collections.Generic;
using System.Diagnostics;

// Component types matching Zig version
public struct Transform
{
    public float x, y, rotation;
    
    public Transform(float x, float y, float rotation)
    {
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }
}

public struct Velocity
{
    public float dx, dy, angular;
    
    public Velocity(float dx, float dy, float angular)
    {
        this.dx = dx;
        this.dy = dy;
        this.angular = angular;
    }
}

public struct Health
{
    public int current, max;
    
    public Health(int current, int max)
    {
        this.current = current;
        this.max = max;
    }
}

// Simple ECS-like structure for rollback testing
public class GameState
{
    public List<Transform> transforms = new List<Transform>();
    public List<Velocity> velocities = new List<Velocity>();
    public List<Health> healths = new List<Health>();
    public List<bool> hasTransform = new List<bool>();
    public List<bool> hasVelocity = new List<bool>();
    public List<bool> hasHealth = new List<bool>();
    public int entityCount = 0;
    
    public void AddEntity(bool withTransform, bool withVelocity, bool withHealth,
                         Transform transform = default, Velocity velocity = default, Health health = default)
    {
        transforms.Add(withTransform ? transform : default);
        velocities.Add(withVelocity ? velocity : default);
        healths.Add(withHealth ? health : default);
        hasTransform.Add(withTransform);
        hasVelocity.Add(withVelocity);
        hasHealth.Add(withHealth);
        entityCount++;
    }
    
    // Deep copy for rollback
    public GameState DeepCopy()
    {
        var copy = new GameState();
        copy.entityCount = entityCount;
        
        // Copy all lists
        copy.transforms.AddRange(transforms);
        copy.velocities.AddRange(velocities);
        copy.healths.AddRange(healths);
        copy.hasTransform.AddRange(hasTransform);
        copy.hasVelocity.AddRange(hasVelocity);
        copy.hasHealth.AddRange(hasHealth);
        
        return copy;
    }
    
    // Restore from another state
    public void RestoreFrom(GameState other)
    {
        entityCount = other.entityCount;
        
        transforms.Clear();
        velocities.Clear();
        healths.Clear();
        hasTransform.Clear();
        hasVelocity.Clear();
        hasHealth.Clear();
        
        transforms.AddRange(other.transforms);
        velocities.AddRange(other.velocities);
        healths.AddRange(other.healths);
        hasTransform.AddRange(other.hasTransform);
        hasVelocity.AddRange(other.hasVelocity);
        hasHealth.AddRange(other.hasHealth);
    }
}

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("=== C# Rollback Performance Comparison ===");
        
        int[] entityCounts = { 100, 500, 1000 };
        int frameCount = 1000;
        
        foreach (int entityCount in entityCounts)
        {
            Console.WriteLine($"\n--- {entityCount} Entities ---");
            
            // Create game state
            var gameState = new GameState();
            
            // Create entities with components (matching Zig pattern)
            for (int i = 0; i < entityCount; i++)
            {
                bool hasTransform = true;
                bool hasVelocity = (i % 5 < 4); // 80% get velocity
                bool hasHealth = (i % 5 < 3);   // 60% get health
                
                var transform = new Transform(i % 100, i / 100, 0.0f);
                var velocity = new Velocity((i % 10 - 5) * 2.0f, (i % 7 - 3) * 2.0f, i % 180);
                var health = new Health(100, 100);
                
                gameState.AddEntity(hasTransform, hasVelocity, hasHealth, transform, velocity, health);
            }
            
            // Test copying performance
            var savedStates = new List<GameState>();
            var sw = Stopwatch.StartNew();
            
            for (int i = 0; i < frameCount; i++)
            {
                var copied = gameState.DeepCopy();
                savedStates.Add(copied);
            }
            
            sw.Stop();
            double copyTimeMs = sw.Elapsed.TotalMilliseconds;
            double avgCopyTimeUs = (copyTimeMs * 1000.0) / frameCount;
            
            // Test restoration performance
            sw.Restart();
            
            for (int i = 0; i < frameCount; i++)
            {
                int frameIndex = i % savedStates.Count;
                gameState.RestoreFrom(savedStates[frameIndex]);
            }
            
            sw.Stop();
            double restoreTimeMs = sw.Elapsed.TotalMilliseconds;
            double avgRestoreTimeUs = (restoreTimeMs * 1000.0) / frameCount;
            
            // Calculate memory usage (rough estimate)
            int transformCount = entityCount;
            int velocityCount = (entityCount * 4) / 5;
            int healthCount = (entityCount * 3) / 5;
            double totalMemoryKb = (
                transformCount * 12 + // Transform: 3 floats = 12 bytes
                velocityCount * 12 +  // Velocity: 3 floats = 12 bytes  
                healthCount * 8 +     // Health: 2 ints = 8 bytes
                entityCount * 5       // 5 bools per entity = 5 bytes
            ) / 1024.0;
            
            Console.WriteLine($"Copy time: {avgCopyTimeUs:F1}μs avg ({copyTimeMs:F2}ms total)");
            Console.WriteLine($"Restore time: {avgRestoreTimeUs:F1}μs avg ({restoreTimeMs:F2}ms total)");
            Console.WriteLine($"Memory per frame: ~{totalMemoryKb:F1}KB");
            Console.WriteLine($"Components: {transformCount} Transform, {velocityCount} Velocity, {healthCount} Health");
        }
        
        Console.WriteLine("\n=== End C# Rollback Test ===");
    }
}