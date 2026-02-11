---@type NvPluginSpec
return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason_lspconfig = require "mason-lspconfig"

    -- List of LSP servers to install automatically
    mason_lspconfig.setup {
      ensure_installed = {
        "gopls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "jsonls",
        "yamlls",
        "bashls",
        "eslint",
        "tailwindcss",
      },
      automatic_installation = true,
    }

    -- Handlers are not needed here; lspconfig.lua sets up all servers.
    -- mason-lspconfig only ensures these servers are installed.
  end,
}
