#!/bin/bash
# 运行指令重排实验

echo "=== 标量指令重排实验 ==="
echo ""
echo "实验目的："
echo "1. 展示编译器指令调度对性能的影响"
echo "2. 对比在不同微架构上的表现差异"
echo ""

# 系统信息
echo "=== 系统信息 ==="
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS 系统 (预期是乱序执行架构)"
    sysctl -n machdep.cpu.brand_string
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux 系统"
    if grep -q "Cortex-A53" /proc/cpuinfo; then
        echo "检测到 Cortex-A53 (顺序双发架构)"
    fi
    grep "model name" /proc/cpuinfo | head -1
fi
echo ""

# 编译
echo "=== 编译基准测试 ==="
make clean
make all
echo ""

# 查看汇编差异
echo "=== 汇编代码分析 ==="
echo "查看 BM_ScalarCompute 中的主循环..."
echo ""

echo "1. 禁用指令调度时的指令顺序："
echo "   (指令按源代码顺序排列)"
grep -A 50 "_Z16BM_ScalarCompute" benchmark_no_schedule.s | grep -E "(mul|add|sub|lsr|ldr)" | head -20

echo ""
echo "2. 启用指令调度时的指令顺序："
echo "   (编译器重排了指令以提高流水线效率)"
grep -A 50 "_Z16BM_ScalarCompute" benchmark_with_schedule.s | grep -E "(mul|add|sub|lsr|ldr)" | head -20

echo ""
echo "=== 运行性能测试 ==="
echo ""

# 运行基准测试
echo "--- BM_ScalarCompute (可以并行的计算) ---"
echo "禁用指令调度:"
./benchmark_no_schedule --benchmark_filter="BM_ScalarCompute" --benchmark_min_time=1

echo ""
echo "启用指令调度:"
./benchmark_with_schedule --benchmark_filter="BM_ScalarCompute" --benchmark_min_time=1

echo ""
echo "--- BM_ScalarSerial (强制串行的计算) ---"
echo "禁用指令调度:"
./benchmark_no_schedule --benchmark_filter="BM_ScalarSerial" --benchmark_min_time=1

echo ""
echo "启用指令调度:"
./benchmark_with_schedule --benchmark_filter="BM_ScalarSerial" --benchmark_min_time=1

echo ""
echo "=== 结果解释 ==="
echo ""
echo "预期结果："
echo ""
echo "在 Cortex-A53 (顺序执行) 上："
echo "- BM_ScalarCompute: 启用调度应该明显更快"
echo "- BM_ScalarSerial: 调度影响较小（因为都是依赖链）"
echo ""
echo "在 Apple M4 (乱序执行) 上："
echo "- 两个版本性能差异较小"
echo "- CPU会在运行时自动重排指令"
echo ""
echo "这说明了为什么现代CPU要重复编译器的工作！"