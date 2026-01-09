return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "solidity" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Nomicfoundation Solidity LSP (recommended for Foundry/Hardhat)
        solidity_ls_nomicfoundation = {
          -- Gas optimization and security features
          settings = {
            solidity = {
              -- Enable all compiler warnings
              compileUsingRemoteVersion = nil,
              compileUsingLocalVersion = nil,
              -- Formatter settings for gas optimization
              formatter = "forge", -- or "prettier"
              -- Enable telemetry for better diagnostics
              telemetry = false,
              -- Validation settings
              validation = {
                onChange = true,
                onOpen = true,
                onSave = true,
              },
            },
          },
          -- Auto-start LSP on Solidity files
          filetypes = { "solidity" },
          root_dir = function(fname)
            local util = require "lspconfig.util"
            return util.root_pattern("foundry.toml", "hardhat.config.js", "hardhat.config.ts", ".git")(fname) or util.path.dirname(fname)
          end,
        },
        -- Alternative: Solang (for more strict checks)
        -- solang = {},
      },
    },
  },
  {
    -- Solidity plugin for syntax highlighting
    "TovarishFin/vim-solidity",
    ft = "solidity",
  },
}
