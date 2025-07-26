# Makefile - 使用 LLVM 工具链精确控制指令调度

CXX := clang++
CXXFLAGS := -std=c++17 -Wall -Wextra
LLC := llc
OPT := opt

# Step 1: 编译到 LLVM IR (使用 O0 保留原始结构)
benchmark.ll: benchmark.cpp
	$(CXX) $(CXXFLAGS) -O0 -S -emit-llvm -o $@ $<
	@echo "Generated LLVM IR (unoptimized)"

# Step 2a: 生成禁用指令调度的汇编代码
benchmark_no_sched.s: benchmark.ll
	$(LLC) -O2 -mtriple=arm64-apple-darwin -disable-post-ra -disable-sched-cycles -o $@ $<
	@echo "Generated assembly WITHOUT instruction scheduling"

# Step 2b: 生成启用指令调度的汇编代码（默认）
benchmark_with_sched.s: benchmark.ll
	$(LLC) -O2 -mtriple=arm64-apple-darwin -o $@ $<
	@echo "Generated assembly WITH instruction scheduling"

# Step 3: 组装和链接
benchmark_no_sched: benchmark_no_sched.s
	$(CXX) -o $@ $< -lbenchmark -lpthread
	@echo "Built benchmark without instruction scheduling"

benchmark_with_sched: benchmark_with_sched.s
	$(CXX) -o $@ $< -lbenchmark -lpthread
	@echo "Built benchmark with instruction scheduling"

# 查看汇编差异
diff_asm: benchmark_no_sched.s benchmark_with_sched.s
	@echo "=== Assembly Difference (scheduling impact) ==="
	@echo "Look for differences in instruction order within the main loop..."
	@diff -u benchmark_no_sched.s benchmark_with_sched.s | grep -A5 -B5 "+" | head -50 || true

# 运行性能测试
run: benchmark_no_sched benchmark_with_sched
	@echo "=== Performance Comparison ==="
	@echo ""
	@echo "1. WITHOUT instruction scheduling:"
	./benchmark_no_sched --benchmark_min_time=2
	@echo ""
	@echo "2. WITH instruction scheduling:"
	./benchmark_with_sched --benchmark_min_time=2

all: benchmark_no_sched benchmark_with_sched

clean:
	rm -f *.ll *.s benchmark_no_sched benchmark_with_sched

.PHONY: all clean diff_asm run