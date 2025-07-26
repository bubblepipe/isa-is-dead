# Makefile - 使用 LLVM 工具链精确控制指令调度

CXX := clang++
CXXFLAGS := -std=c++17 -Wall -Wextra
LLC := llc
TRIPLE ?= arm64-apple-darwin
MCPU ?=

# Step 1: 编译到 LLVM IR
benchmark.ll: benchmark.cpp
	$(CXX) $(CXXFLAGS) -O1 -S -emit-llvm -o $@ $<
	@echo "Generated LLVM IR"

# Step 2a: 禁用调度 - 保持源代码顺序
benchmark_no_sched.s: benchmark.ll
	$(LLC) -O2 -mtriple=$(TRIPLE) $(if $(MCPU),-mcpu=$(MCPU)) \
		-pre-RA-sched=source \
		-enable-post-misched=false \
		-o $@ $<
	@echo "Generated assembly WITHOUT scheduling for $(TRIPLE) $(MCPU)"

# Step 2b: 启用调度优化
benchmark_with_sched.s: benchmark.ll
	$(LLC) -O2 -mtriple=$(TRIPLE) $(if $(MCPU),-mcpu=$(MCPU)) \
		-pre-RA-sched=list-ilp \
		-enable-post-misched=true \
		-o $@ $<
	@echo "Generated assembly WITH scheduling for $(TRIPLE) $(MCPU)"

# Step 3: 组装和链接
benchmark_no_sched: benchmark_no_sched.s
	$(CXX) -o $@ $< -lbenchmark -lpthread

benchmark_with_sched: benchmark_with_sched.s
	$(CXX) -o $@ $< -lbenchmark -lpthread

# 比较 func 函数的汇编代码
compare: benchmark_no_sched.s benchmark_with_sched.s
	@echo "=== Comparing func function assembly ==="
	@echo "--- No scheduling (source order) ---"
	@sed -n '/__Z4funcPKj:/,/ret/p' benchmark_no_sched.s | head -40
	@echo ""
	@echo "--- With scheduling (optimized) ---"
	@sed -n '/__Z4funcPKj:/,/ret/p' benchmark_with_sched.s | head -40

# 运行性能测试
run: benchmark_no_sched benchmark_with_sched
	@echo "=== Performance Comparison on $(TRIPLE) $(MCPU) ==="
	@echo ""
	@echo "1. WITHOUT instruction scheduling:"
	./benchmark_no_sched --benchmark_min_time=2s
	@echo ""
	@echo "2. WITH instruction scheduling:"
	./benchmark_with_sched --benchmark_min_time=2s

all: benchmark_no_sched benchmark_with_sched

clean:
	rm -f *.ll *.s benchmark_no_sched benchmark_with_sched

.PHONY: all clean compare run