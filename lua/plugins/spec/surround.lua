---@type NvPluginSpec
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("nvim-surround").setup {
      keymaps = {
        normal = "ys", -- word
        normal_cur = "yss", -- line
        delete = "ds",
        change = "cs",
        visual = "<leader>sr",
        visual_line = "gS",
      },
    }
  end,
}
