---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      -- ── Blockchain / Solidity ──────────────────────────────────────────────
      "nomicfoundation-solidity-language-server", -- better diagnostics, Foundry root detection
      "solidity-ls", -- legacy fallback
      "solhint", -- Solidity linter (security + style)
      "js-debug-adapter",
      "codelldb", -- Rust / C/C++ debugger

      -- ── TypeScript / JavaScript ───────────────────────────────────────────
      "eslint-lsp",
      "typescript-language-server",
      "prettier",
      "tailwindcss-language-server",

      -- ── Go ────────────────────────────────────────────────────────────────
      "goimports",
      "gopls",

      -- ── Rust ──────────────────────────────────────────────────────────────
      "rust-analyzer",

      -- ── Lua ───────────────────────────────────────────────────────────────
      "lua-language-server",
      "stylua",

      -- ── Data formats (foundry.toml, Cargo.toml, Anchor.toml) ──────────────
      "taplo", -- TOML LSP + formatter
      "json-lsp",
      "yaml-language-server",

      -- ── Docker ────────────────────────────────────────────────────────────
      "dockerfile-language-server",
      "docker-compose-language-service",

      -- ── Shell / scripting ─────────────────────────────────────────────────
      "bash-language-server",
      "shfmt",

      -- ── Python / other ────────────────────────────────────────────────────
      "pyright",
      "mypy",
      "ruff",

      -- ── Zig ───────────────────────────────────────────────────────────
      "zls",

      -- ── Kotlin ────────────────────────────────────────────────────────
      "kotlin-language-server",
      "kotlin-debug-adapter",

      -- ── C# / .NET ─────────────────────────────────────────────────────
      "omnisharp",

      -- ── Ruby ──────────────────────────────────────────────────────────
      "solargraph",

      -- ── Terraform / HCL ───────────────────────────────────────────────
      "terraform-ls",
    },
  },
}
