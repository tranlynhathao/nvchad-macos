---@type NvPluginSpec
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("nvim-surround").setup {
      keymaps = {
        normal = "ys",
        normal_cur = "yss",
        delete = "ds",
        change = "cs",
        visual = "<leader>sr",
        visual_line = "gS",
      },
    }
  end,
}
