---@type NvPluginSpec

-- Sidebar for outline/symbol navigation
return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
