---@type NvPluginSpec
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("nvim-surround").setup()

    -- vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)")
    -- vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)")
    -- vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)")
    -- vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)")
    -- vim.keymap.set("x", "<leader>sr", "<Plug>(nvim-surround-visual)")
    -- vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)")
  end,
}
