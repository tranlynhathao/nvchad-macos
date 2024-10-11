---@type NvPluginSpec
return {
  "MeanderingProgrammer/markdown.nvim",
  main = "render-markdown",
  opts = {},
  name = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim",
  },
}
