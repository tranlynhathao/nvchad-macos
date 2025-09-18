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
  require "vincent.LSP.utils.icon"
  require "vincent.LSP.utils.cmp"
  -- # LSP UI
  -- require("vincent.LSP.utils.lspsaga")
  -- # LSP Config
  require "vincent.LSP.languages.typescript"
  require "vincent.LSP.languages.css"
  require "vincent.LSP.languages.svelte"
  require "vincent.LSP.languages.vue"
  require "vincent.LSP.languages.astro"
  require "vincent.LSP.languages.deno"
  require "vincent.LSP.languages.rust"
  require "vincent.LSP.languages.go"
  require "vincent.LSP.languages.cpp"
  require "vincent.LSP.languages.python"
  require "vincent.LSP.languages.lua"
  require "vincent.LSP.languages.php"
  require "vincent.LSP.languages.csharp"
  -- format some markup and dif file
  require "vincent.LSP.languages.prettier"

  -- # LuaSnip
  require "vincent.LSP.luasnip.main"
end

if not pcall(debug.getlocal, 4, 1) then
  M.setup()
end

return M
