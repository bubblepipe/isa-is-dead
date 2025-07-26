// benchmark.cpp
// 使用标量指令展示指令重排对不同微架构的影响
// 同一份代码，通过 LLVM 编译选项控制是否进行指令重排

#include <benchmark/benchmark.h>
#include <cstdint>
#include <vector>

// 核心测试：设计有多条独立计算路径的函数
// 编译器可以重排这些独立的操作以提高流水线利用率
static void BM_ScalarCompute(benchmark::State& state) {
    const size_t N = 1024;
    std::vector<uint32_t> data(N);
    
    // 初始化数据
    for (size_t i = 0; i < N; ++i) {
        data[i] = i + 1;
    }
    
    for (auto _ : state) {
        uint32_t sum1 = 0, sum2 = 0, sum3 = 0, sum4 = 0;
        
        // 四条独立的计算路径，编译器和CPU都可以重排
        for (size_t i = 0; i < N; i += 4) {
            // 加载数据 - 这些是独立的
            uint32_t a = data[i];
            uint32_t b = data[i + 1];
            uint32_t c = data[i + 2];
            uint32_t d = data[i + 3];
            
            // 路径1: a的处理
            uint32_t t1 = a * 3;
            t1 = t1 + 7;
            t1 = t1 >> 1;
            sum1 += t1;
            
            // 路径2: b的处理（独立于路径1）
            uint32_t t2 = b * 5;
            t2 = t2 - 3;
            t2 = t2 >> 2;
            sum2 += t2;
            
            // 路径3: c的处理（独立于路径1和2）
            uint32_t t3 = c * 7;
            t3 = t3 + 11;
            t3 = t3 >> 1;
            sum3 += t3;
            
            // 路径4: d的处理（独立于其他路径）
            uint32_t t4 = d * 2;
            t4 = t4 + 13;
            t4 = t4 >> 3;
            sum4 += t4;
        }
        
        // 最终合并结果
        uint32_t result = sum1 + sum2 + sum3 + sum4;
        benchmark::DoNotOptimize(result);
    }
    
    state.SetBytesProcessed(state.iterations() * N * sizeof(uint32_t));
}

BENCHMARK(BM_ScalarCompute);
BENCHMARK_MAIN();