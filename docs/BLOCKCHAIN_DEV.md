# Blockchain Development Configuration

Neovim configuration optimized for blockchain development with focus on memory safety, gas optimization, and security.

## Core Features

### 1. Rust Development (Blockchain, Smart Contracts)

- **rust-analyzer** with Clippy pedantic warnings
- **Miri** - Memory safety checker for unsafe code
- **AddressSanitizer** - Runtime memory error detection
- **Inlay hints** - Lifetime and type annotations
- **Unsafe code highlighting** - Visual indicator for `unsafe` blocks
- **Memory profiling** - Heaptrack integration

### 2. C/C++ Development (Low-level, Systems)

- **clangd** with clang-tidy integration
- **Valgrind** - Memory leak detection and analysis
- **AddressSanitizer** - Compile-time memory checks
- **Memory safety lints** - C++ Core Guidelines enforcement
- Template `.clang-tidy` configuration with strict checks

### 3. Solidity Development (Smart Contracts)

- **Foundry** integration - forge, anvil, cast
- **Hardhat** support for existing projects
- **Gas reporting** - Detailed gas consumption analysis
- **Coverage** - Test coverage metrics
- **Slither** - Static security analyzer
- **Auto-format** with forge fmt on save

### 4. Go Development (Blockchain nodes, APIs)

- **gopls** LSP server
- **gofmt** auto-formatting
- Compact array formatting

## Installation Dependencies

### Rust Tools

```bash
# Install Rust nightly (required for Miri and sanitizers)
rustup toolchain install nightly

# Install Miri component
rustup +nightly component add miri

# Install Clippy
rustup component add clippy

# Install rust-src
rustup component add rust-src

# Optional: heaptrack for memory profiling
brew install heaptrack  # macOS
```

### C/C++ Tools

```bash
# clangd is already available via LLVM
# Install Valgrind
brew install valgrind  # macOS

# Copy .clang-tidy template to your project
cp ~/.config/nvim/templates/.clang-tidy ~/your-project/
```

### Solidity Tools

```bash
# Install Foundry (forge, anvil, cast)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Slither static analyzer
pip3 install slither-analyzer

# Optional: Hardhat for existing projects
npm install --global hardhat
```

### LSP Servers

```bash
# In Neovim, run:
:MasonInstall rust-analyzer clangd solidity-ls-nomicfoundation
```

## Keymaps

### Prefix: `<leader>b` (blockchain tools)

#### Rust Memory Safety

- `<leader>bm` - Run Miri memory checker
- `<leader>ba` - Run with AddressSanitizer
- `<leader>bp` - Profile memory usage (heaptrack)

#### C/C++ Memory Tools

- `<leader>bv` - Run Valgrind memory analysis
- `<leader>bc` - Compile with AddressSanitizer

#### Solidity/Foundry

- `<leader>bg` - Show gas report
- `<leader>bC` - Show test coverage
- `<leader>bs` - Run Slither security analyzer
- `<leader>bo` - Open optimizer settings (foundry.toml)

## Commands

### Rust

```vim
:RustMiri          " Run Miri memory safety checker
:RustAsan          " Run tests with AddressSanitizer
:RustMemProfile    " Profile memory usage with heaptrack
```

### C/C++

```vim
:Valgrind          " Run Valgrind on current binary
:CppAsan           " Compile and run with AddressSanitizer
```

### Solidity/Foundry

```vim
:FoundryGas        " Display gas consumption report
:FoundryCov        " Display test coverage report
:Slither           " Run Slither security analyzer
:SolOptimizer      " Open optimizer settings in foundry.toml
```

## Best Practices

### Rust

1. **Verify unsafe code**
   - Unsafe blocks are highlighted in red
   - Use `:RustMiri` to verify memory safety guarantees
   - Review all unsafe code during code review

2. **Enable inlay hints**
   - Lifetime hints for understanding ownership semantics
   - Type hints for explicit type information
   - Helps prevent lifetime-related bugs

3. **Clippy warnings**
   - `clippy::pedantic` enabled for stricter checks
   - `clippy::unwrap_used` - Avoid `.unwrap()` in production
   - `clippy::expect_used` - Avoid `.expect()` in production

### C/C++

1. **Use clang-tidy**
   - Copy `.clang-tidy` template to project root
   - Enable memory safety checks via C++ Core Guidelines
   - Review all warnings during development

2. **Sanitizers**
   - Development: Use AddressSanitizer for fast feedback
   - Production: Comprehensive testing with Valgrind
   - Enable sanitizers in CI/CD pipeline

3. **Smart pointers**
   - Prefer `std::unique_ptr`, `std::shared_ptr`
   - Minimize raw pointer usage
   - Use RAII for resource management

### Solidity

1. **Gas optimization**
   - Run `:FoundryGas` regularly during development
   - Verify gas costs before deployment
   - Optimize high-frequency operations

2. **Security**
   - Run `:Slither` to detect common vulnerabilities
   - Maintain test coverage >= 90% (`:FoundryCov`)
   - Audit all external calls and state changes

3. **Formatting**
   - Auto-format on save with forge fmt
   - Maintain consistent style across team
   - Use solhint for additional linting

## Workflow Examples

### Rust Development

```bash
# 1. Write code in Neovim
# 2. Verify with Clippy
cargo clippy

# 3. In Neovim, verify memory safety
:RustMiri

# 4. If performance issues exist, profile
:RustMemProfile
```

### C/C++ Development

```bash
# 1. Write code in Neovim
# 2. Compile with sanitizer (in Neovim)
:CppAsan

# 3. If tests pass, verify with Valgrind
:Valgrind

# 4. Review clang-tidy suggestions (automatic via LSP)
```

### Solidity Development

```bash
# 1. Write smart contract in Neovim
# 2. Auto-format on save (forge fmt)

# 3. Run tests with gas report
:FoundryGas

# 4. Security analysis
:Slither

# 5. Verify coverage
:FoundryCov

# 6. Deploy (manual)
forge script --broadcast
```

## Memory Safety Checks

### Rust

- **Ownership & Borrowing**: Enforced by compiler
- **Lifetime hints**: Visible via inlay hints
- **Miri**: Detects undefined behavior in unsafe code
- **AddressSanitizer**: Runtime memory error detection

### C/C++

- **Static analysis**: clang-tidy integration
- **Runtime checks**: AddressSanitizer, Valgrind
- **Memory leaks**: Valgrind leak detection
- **Use-after-free**: Detected by ASAN and Valgrind

### Solidity

- **Reentrancy**: Detected by Slither
- **Integer overflow**: Automatic checks in Solidity 0.8+
- **Gas optimization**: Foundry gas reports
- **Access control**: Verified by Slither

## Formatting Configuration

### Rust

- `rustfmt` with edition 2021
- Compact array formatting (default)

### C/C++

- `clang-format` with LLVM style base
- `ColumnLimit: 120` for wider displays
- `BinPackArguments: true` for compact arrays

### Solidity

- `forge fmt` for Foundry projects
- `prettier` for Hardhat projects

### Go

- `gofmt` (standard Go formatter)
- Compact array formatting (default)

### Python

- `ruff` - Fast, modern formatter
- Compact array formatting

## Troubleshooting

### Miri not working

```bash
rustup +nightly component add miri
rustup update nightly
```

### Valgrind not found

```bash
brew install valgrind
# Note: Valgrind may not work on ARM-based Macs (M1/M2/M3)
# Consider using AddressSanitizer as alternative
```

### Slither cannot find contracts

```bash
# Ensure you are in the project root directory
cd /path/to/foundry-project
:Slither
```

### LSP not starting

```bash
# Check Mason installation
:Mason
# Install required LSP servers: rust-analyzer, clangd, solidity-ls-nomicfoundation
```

## Resources

### Rust

- [The Rust Programming Language](https://doc.rust-lang.org/book/)
- [The Rustonomicon](https://doc.rust-lang.org/nomicon/) - Unsafe Rust guide
- [Miri Documentation](https://github.com/rust-lang/miri)

### C/C++

- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)
- [Valgrind Manual](https://valgrind.org/docs/manual/)
- [AddressSanitizer Documentation](https://github.com/google/sanitizers/wiki/AddressSanitizer)

### Solidity

- [Solidity Documentation](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Slither Documentation](https://github.com/crytic/slither)

## Tips

1. **Rust**: Always verify `unsafe` code with Miri before production
2. **C/C++**: Enable sanitizers during development phase
3. **Solidity**: Gas optimization should be a primary concern
4. **Memory**: Profile before optimizing to identify bottlenecks
5. **Security**: Run static analyzers regularly, ideally in CI/CD

---

For questions or issues, refer to the official documentation of each tool.
