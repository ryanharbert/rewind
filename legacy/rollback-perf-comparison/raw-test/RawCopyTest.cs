using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

// Raw frame data structures matching Zig version
[StructLayout(LayoutKind.Sequential)]
public struct Transform
{
    public float x, y, rotation;
}

[StructLayout(LayoutKind.Sequential)]
public struct Velocity
{
    public float dx, dy, angular;
}

[StructLayout(LayoutKind.Sequential)]
public struct Health
{
    public int current, max;
}

// Fixed-size frame data - exactly matching Zig layout
[StructLayout(LayoutKind.Sequential)]
public unsafe struct RawFrameData
{
    public const int MAX_ENTITIES = 1024;
    public const int BITSET_SIZE = MAX_ENTITIES / 64; // 16 u64s
    
    // Entity data
    public fixed ulong active_entities[BITSET_SIZE];
    public uint entity_count;
    
    // Component data - fixed size arrays
    public fixed byte transform_data[MAX_ENTITIES * 12]; // Transform is 12 bytes
    public fixed byte velocity_data[MAX_ENTITIES * 12];  // Velocity is 12 bytes
    public fixed byte health_data[MAX_ENTITIES * 8];     // Health is 8 bytes
    
    // Component masks
    public fixed ulong has_transform[BITSET_SIZE];
    public fixed ulong has_velocity[BITSET_SIZE];
    public fixed ulong has_health[BITSET_SIZE];
    
    // Component counts
    public uint transform_count;
    public uint velocity_count;
    public uint health_count;
    
    public static int CalculateCopySize(uint entityCount, uint transformCount, uint velocityCount, uint healthCount)
    {
        return sizeof(RawFrameData); // Everything is fixed size
    }
    
    public void CopyFrom(ref RawFrameData other)
    {
        // Raw memory copy using unsafe pointer arithmetic
        fixed (RawFrameData* thisPtr = &this)
        fixed (RawFrameData* otherPtr = &other)
        {
            Buffer.MemoryCopy(otherPtr, thisPtr, sizeof(RawFrameData), sizeof(RawFrameData));
        }
    }
    
    public void SetTransform(int index, Transform transform)
    {
        fixed (byte* ptr = transform_data)
        {
            var transformPtr = (Transform*)(ptr + index * sizeof(Transform));
            *transformPtr = transform;
        }
    }
    
    public void SetVelocity(int index, Velocity velocity)
    {
        fixed (byte* ptr = velocity_data)
        {
            var velocityPtr = (Velocity*)(ptr + index * sizeof(Velocity));
            *velocityPtr = velocity;
        }
    }
    
    public void SetHealth(int index, Health health)
    {
        fixed (byte* ptr = health_data)
        {
            var healthPtr = (Health*)(ptr + index * sizeof(Health));
            *healthPtr = health;
        }
    }
}

class Program
{
    static unsafe void Main(string[] args)
    {
        Console.WriteLine("=== C# Raw Memory Copy Performance Test ===");
        
        int[] entityCounts = { 100, 500, 1000 };
        int frameCount = 10000; // Match Zig test
        
        foreach (int entityCount in entityCounts)
        {
            Console.WriteLine($"\n--- {entityCount} Entities ---");
            
            // Create source frame data
            var sourceFrame = new RawFrameData();
            sourceFrame.entity_count = (uint)entityCount;
            
            // Fill with realistic data
            uint transformCount = (uint)entityCount;
            uint velocityCount = (uint)((entityCount * 4) / 5); // 80%
            uint healthCount = (uint)((entityCount * 3) / 5);   // 60%
            
            sourceFrame.transform_count = transformCount;
            sourceFrame.velocity_count = velocityCount;
            sourceFrame.health_count = healthCount;
            
            // Fill transforms
            for (int i = 0; i < transformCount; i++)
            {
                sourceFrame.SetTransform(i, new Transform
                {
                    x = i % 100,
                    y = i / 100,
                    rotation = 0.0f
                });
            }
            
            // Fill velocities
            for (int i = 0; i < velocityCount; i++)
            {
                sourceFrame.SetVelocity(i, new Velocity
                {
                    dx = (i % 10 - 5) * 2.0f,
                    dy = (i % 7 - 3) * 2.0f,
                    angular = i % 180
                });
            }
            
            // Fill healths
            for (int i = 0; i < healthCount; i++)
            {
                sourceFrame.SetHealth(i, new Health
                {
                    current = 100,
                    max = 100
                });
            }
            
            // Set up bitsets (simplified)
            for (int i = 0; i < entityCount; i++)
            {
                int wordIndex = i / 64;
                int bitIndex = i % 64;
                ulong mask = 1UL << bitIndex;
                
                sourceFrame.active_entities[wordIndex] |= mask;
                sourceFrame.has_transform[wordIndex] |= mask;
                
                if (i < velocityCount)
                    sourceFrame.has_velocity[wordIndex] |= mask;
                if (i < healthCount)
                    sourceFrame.has_health[wordIndex] |= mask;
            }
            
            // Pre-allocate destination frames
            var destFrames = new RawFrameData[frameCount];
            
            // Test raw memory copying
            var sw = Stopwatch.StartNew();
            for (int i = 0; i < frameCount; i++)
            {
                destFrames[i].CopyFrom(ref sourceFrame);
            }
            sw.Stop();
            double copyTimeMs = sw.Elapsed.TotalMilliseconds;
            
            // Test restoration (copy back)
            sw.Restart();
            for (int i = 0; i < frameCount; i++)
            {
                int frameIndex = i % destFrames.Length;
                sourceFrame.CopyFrom(ref destFrames[frameIndex]);
            }
            sw.Stop();
            double restoreTimeMs = sw.Elapsed.TotalMilliseconds;
            
            // Calculate metrics
            double avgCopyTimeUs = (copyTimeMs * 1000.0) / frameCount;
            double avgRestoreTimeUs = (restoreTimeMs * 1000.0) / frameCount;
            
            int copySize = sizeof(RawFrameData);
            double copySizeKb = copySize / 1024.0;
            
            double copyBandwidthMBs = (copySizeKb / 1024.0) / (avgCopyTimeUs / 1_000_000.0);
            
            Console.WriteLine($"Raw copy time: {avgCopyTimeUs:F2}μs avg ({copyTimeMs:F2}ms total)");
            Console.WriteLine($"Raw restore time: {avgRestoreTimeUs:F2}μs avg ({restoreTimeMs:F2}ms total)");
            Console.WriteLine($"Frame size: {copySizeKb:F1}KB ({copySize} bytes)");
            Console.WriteLine($"Copy bandwidth: {copyBandwidthMBs:F1}MB/s");
            Console.WriteLine($"Components: {transformCount} Transform, {velocityCount} Velocity, {healthCount} Health");
        }
        
        Console.WriteLine("\n=== End C# Raw Copy Test ===");
    }
}