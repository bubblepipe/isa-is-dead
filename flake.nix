{
  description = "ISA benchmark development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # LLVM 工具链 (使用 LLVM 20 或最新版本)
            # 尝试使用 LLVM 20，如果不可用则使用 latest
            (if (pkgs ? llvmPackages_20) then llvmPackages_20 else llvmPackages_latest).clang
            (if (pkgs ? llvmPackages_20) then llvmPackages_20 else llvmPackages_latest).llvm
            (if (pkgs ? llvmPackages_20) then llvmPackages_20 else llvmPackages_latest).bintools
            
            # Google Benchmark
            gbenchmark
            
            # 构建工具
            cmake
            gnumake
            pkg-config
            
            # 调试和分析工具（如果在 Linux 上）
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            valgrind
            linuxPackages.perf
          ];
          
          shellHook = ''
            echo "🚀 ISA Benchmark Development Environment"
            echo ""
            echo "Available compilers:"
            echo "  • gcc $(gcc --version | head -1)"
            echo "  • clang $(clang --version | head -1)"
            echo ""
            echo "Google Benchmark: $(pkg-config --modversion benchmark)"
            echo ""
            echo "Usage:"
            echo "  make all         - Build benchmarks"
            echo "  make run         - Run performance comparison"
            echo "  make compare     - Compare assembly output"
            echo ""
            echo "Note: Using gcc for -fno-schedule-insns support"
          '';
        };
      });
}