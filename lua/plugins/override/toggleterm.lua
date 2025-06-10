---@type NvPluginSpec

-- Floating/split/tab terminal made easy
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = true,
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
  },
}
