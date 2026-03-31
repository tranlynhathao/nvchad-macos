---@type NvPluginSpec
return {
  -- Solidity syntax + filetype detection (vim-polyglot replacement for .sol files)
  {
    "TovarishFin/vim-solidity",
    ft = { "solidity" },
  },

  -- Treesitter: solidity parser (belt-and-suspenders with main treesitter config)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "solidity" })
    end,
  },

  -- Blockchain workflow keymaps via ToggleTerm.
  -- noah.blockchain.setup() is called from init.lua (commands + autocmds already active).
  -- This spec adds the practical day-to-day terminal keymaps that core/project.lua
  -- defined but never imported.
  {
    "akinsho/toggleterm.nvim",
    keys = {
      -- ── Foundry ──────────────────────────────────────────────────────────
      {
        "<leader>bt",
        "<cmd>ToggleTerm direction=float cmd='forge test -vvv'<cr>",
        desc = "Forge test (verbose)",
      },
      {
        "<leader>bb",
        "<cmd>ToggleTerm direction=float cmd='forge build'<cr>",
        desc = "Forge build",
      },
      {
        "<leader>bA",
        "<cmd>ToggleTerm direction=float cmd='anvil'<cr>",
        desc = "Anvil local node",
      },
      -- ── Cargo / Rust ─────────────────────────────────────────────────────
      {
        "<leader>rb",
        "<cmd>ToggleTerm direction=float cmd='cargo build'<cr>",
        desc = "Cargo build",
      },
      {
        "<leader>rt",
        "<cmd>ToggleTerm direction=float cmd='cargo test'<cr>",
        desc = "Cargo test",
      },
      -- ── Anchor / Solana ──────────────────────────────────────────────────
      {
        "<leader>bat",
        "<cmd>ToggleTerm direction=float cmd='anchor test'<cr>",
        desc = "Anchor test",
      },
      {
        "<leader>bab",
        "<cmd>ToggleTerm direction=float cmd='anchor build'<cr>",
        desc = "Anchor build",
      },
    },
  },
}
