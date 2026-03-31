---@type NvPluginSpec
-- setup() is intentionally absent here.
-- lsp/init.lua is the single authoritative caller of mason_lspconfig.setup()
-- with the merged ensure_installed list. A second setup() call here would
-- override that list before lsp/init.lua runs.
return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
}
