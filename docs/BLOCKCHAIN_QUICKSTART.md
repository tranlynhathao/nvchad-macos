# Blockchain Development - Quick Start

## Installation (5 minutes)

```bash
# 1. Rust nightly + Miri
rustup toolchain install nightly
rustup +nightly component add miri

# 2. Foundry (Solidity toolchain)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# 3. Slither (Security analyzer)
pip3 install slither-analyzer

# 4. LSP servers (in Neovim)
# :MasonInstall rust-analyzer clangd solidity-ls-nomicfoundation
```

## Keymaps (Prefix: `<leader>b`)

| Key | Function | Language |
|-----|----------|----------|
| `<leader>bm` | Miri memory check | Rust |
| `<leader>ba` | AddressSanitizer | Rust |
| `<leader>bv` | Valgrind | C/C++ |
| `<leader>bc` | Compile with ASAN | C/C++ |
| `<leader>bg` | Gas report | Solidity |
| `<leader>bs` | Slither security | Solidity |
| `<leader>bC` | Coverage | Solidity |

## Commands

```vim
" Rust
:RustMiri          " Memory safety verification
:RustAsan          " AddressSanitizer

" C/C++
:Valgrind          " Memory leak detection
:CppAsan           " Compile and run with ASAN

" Solidity
:FoundryGas        " Gas optimization report
:Slither           " Security vulnerability scan
:FoundryCov        " Test coverage report
```

## Workflow

### Rust

```bash
# Code → Save (auto-format) → :RustMiri → cargo test
```

### C/C++

```bash
# Code → Save (auto-format) → :CppAsan → :Valgrind
```

### Solidity

```bash
# Code → Save (auto-forge fmt) → :FoundryGas → :Slither
```

## Key Points

1. **Rust**: `unsafe` code is highlighted in red automatically
2. **C/C++**: Copy `.clang-tidy` template from `~/.config/nvim/templates/`
3. **Solidity**: Run `:FoundryGas` before deployment
4. **Memory**: Always verify with sanitizers or Miri
5. **Security**: Run `:Slither` regularly on smart contracts

## Full Documentation

Comprehensive guide: `~/.config/nvim/docs/BLOCKCHAIN_DEV.md`
