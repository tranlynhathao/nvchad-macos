-- # LSP

local M = {}

M.plugin = {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- # LSP Hook
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      commit = "bb680d7",
    },
    -- # LSP Completion
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    -- # LSP Snippet
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    -- # LSP UI
    -- {
    --   "nvimdev/lspsaga.nvim",
    --   branch = "main",
    -- },
  },
  event = "VeryLazy",
  config = function()
    M.setup()
  end,
}

M.setup = function()
  -- # LSP utils
  require "noah.LSP.utils.icon"
  require "noah.LSP.utils.cmp"
  -- # LSP UI
  -- require("noah.LSP.utils.lspsaga")
  -- # LSP Config
  require "noah.LSP.languages.typescript"
  require "noah.LSP.languages.css"
  require "noah.LSP.languages.svelte"
  require "noah.LSP.languages.vue"
  require "noah.LSP.languages.astro"
  require "noah.LSP.languages.deno"
  require "noah.LSP.languages.rust"
  require "noah.LSP.languages.go"
  require "noah.LSP.languages.cpp"
  require "noah.LSP.languages.python"
  require "noah.LSP.languages.lua"
  require "noah.LSP.languages.php"
  require "noah.LSP.languages.csharp"
  -- format some markup and dif file
  require "noah.LSP.languages.prettier"

  -- # LuaSnip
  require "noah.LSP.luasnip.main"
end

if not pcall(debug.getlocal, 4, 1) then
  M.setup()
end

return M
