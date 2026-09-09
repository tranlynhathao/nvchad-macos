---@type NvPluginSpec
return {
  "williamboman/mason-lspconfig.nvim",
  -- Native Neovim 0.11+ lsp/*.lua discovery is authoritative in this config.
  -- Keep the bridge installed for manual use without forcing the LSP graph at startup.
  lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
}
