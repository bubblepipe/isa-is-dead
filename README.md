# ISA Benchmark Test

A CPU instruction scheduling benchmark demonstrating how modern processors and compilers optimize independent computations.

## Overview

This benchmark tests instruction-level parallelism (ILP) by measuring the performance of independent arithmetic operations that can be reordered by the CPU scheduler and compiler optimizations.

## Building

### Using Nix (Recommended)

```bash
nix develop
make
```

### Manual Build

Requirements:
- C++17 compiler (GCC/Clang)
- Google Benchmark library

```bash
# Install dependencies
# macOS
brew install google-benchmark

# Ubuntu/Debian
apt-get install libbenchmark-dev

# Build
make
```

## Running the Benchmark

```bash
./benchmark
```

## Benchmark Details

The test performs:
1. Loads 4 independent 32-bit values
2. Executes parallel arithmetic operations (multiply, add, shift)
3. Measures throughput in bytes/second

The operations are intentionally independent to allow:
- Compiler instruction scheduling
- CPU out-of-order execution
- Pipeline optimization

## Results

- **Apple M4**: See `m4_benchmark_result.png`
- **ARM Cortex-A53**: See `a53_benchmark_result.png`

## Architecture Insights

This benchmark demonstrates how modern CPUs handle instruction scheduling:
- Out-of-order execution engines reorder operations dynamically
- LLVM scheduler optimizes instruction order at compile time
- Independent operations can execute in parallel on multiple execution units

## Files

- `benchmark.cpp` - Main benchmark implementation
- `Makefile` - Build configuration
- `flake.nix` - Nix development environment
- `*.png` - Benchmark results on different architectures