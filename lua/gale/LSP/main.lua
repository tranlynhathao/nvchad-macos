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
  require "gale.LSP.utils.icon"
  require "gale.LSP.utils.cmp"
  -- # LSP UI
  -- require("gale.LSP.utils.lspsaga")
  -- # LSP Config
  require "gale.LSP.languages.typescript"
  require "gale.LSP.languages.css"
  require "gale.LSP.languages.svelte"
  require "gale.LSP.languages.vue"
  require "gale.LSP.languages.astro"
  require "gale.LSP.languages.deno"
  require "gale.LSP.languages.rust"
  require "gale.LSP.languages.go"
  require "gale.LSP.languages.cpp"
  require "gale.LSP.languages.python"
  require "gale.LSP.languages.lua"
  require "gale.LSP.languages.php"
  require "gale.LSP.languages.csharp"
  -- format some markup and dif file
  require "gale.LSP.languages.prettier"

  -- # LuaSnip
  require "gale.LSP.luasnip.main"
end

if not pcall(debug.getlocal, 4, 1) then
  M.setup()
end

return M
