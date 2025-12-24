---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      -- Web3/Blockchain
      "solidity-ls", -- Solidity language server
      "js-debug-adapter", -- For TypeScript/Node debugging
      "codelldb", -- For Rust debugging

      -- TypeScript/JavaScript
      "eslint-lsp",
      "typescript-language-server",
      "prettier",
      "tailwindcss-language-server",

      -- Go
      "goimports",
      "gopls",

      -- Rust
      "rust-analyzer",

      -- Lua
      "lua-language-server",
      "stylua",

      -- Other
      "json-lsp",
      "yaml-language-server",
      "bash-language-server",
      "pyright",
      "mypy",
      "ruff",
    },
  },
}
