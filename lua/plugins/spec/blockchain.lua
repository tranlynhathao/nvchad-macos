---@type NvPluginSpec
return {
  -- Solidity syntax highlighting (fallback)
  {
    "TovarishFin/vim-solidity",
    ft = { "solidity" },
  },
  -- Enhanced Solidity support with treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "solidity" })
    end,
  },
  -- Foundry.toml syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "toml" })
    end,
  },
}
