---@type NvPluginSpec
return {

  -- nimls config moved to ~/.config/nvim/lsp/nimls.lua (tier-3 API).
  -- Enabling happens through lspconfig.lua's filetype_to_servers table.

  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require "cmp"

      cmp.setup {
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      }
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function() end,
  },

  {
    "saadparwaiz1/cmp_luasnip",
    config = function() end,
  },

  {
    "ray-x/lsp_signature.nvim",
    config = function() require("lsp_signature").on_attach() end,
  },
}
