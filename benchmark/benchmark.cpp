// benchmark_schedulable.cpp
// Uses regular C++ code that LLVM can actually reschedule

#include <benchmark/benchmark.h>
#include <cstdint>
#include <vector>

// Helper function to prevent complete optimization
__attribute__((noinline))
uint32_t func(const uint32_t* data) {
    // Load 4 values
    uint32_t a = data[0];
    uint32_t b = data[1];
    uint32_t c = data[2];
    uint32_t d = data[3];
    
    // Perform independent computations
    // These can be reordered by the scheduler
    uint32_t t1 = a * 3;
    uint32_t t2 = b * 5;
    uint32_t t3 = c * 7;
    uint32_t t4 = d * 2;
    
    // More operations on each
    t1 = t1 + 7;
    t2 = t2 - 3;
    t3 = t3 + 11;
    t4 = t4 + 13;
    
    // Final operations
    t1 = t1 >> 1;
    t2 = t2 >> 2;
    t3 = t3 >> 1;
    t4 = t4 >> 3;
    
    // Sum them up
    return t1 + t2 + t3 + t4;
}

static void BM_Schedulable(benchmark::State& state) {
    const size_t N = 1024;
    std::vector<uint32_t> data(N);
    
    for (size_t i = 0; i < N; ++i) {
        data[i] = i + 1;
    }
    
    for (auto _ : state) {
        uint32_t sum = 0;
        
        for (size_t i = 0; i < N; i += 4) {
            sum += func(&data[i]);
        }
        
        benchmark::DoNotOptimize(sum);
    }
    
    state.SetBytesProcessed(state.iterations() * N * sizeof(uint32_t));
}

BENCHMARK(BM_Schedulable);
BENCHMARK_MAIN();