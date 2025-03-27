-- @type NvPluginSpec
return {
  "MeanderingProgrammer/markdown.nvim",
  main = "render-markdown",
  opts = {},
  name = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim",
    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "java", "markdown", "markdown_inline" } } },
  },
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "java", "markdown", "markdown_inline" },
      highlight = { enable = true },
    }
  end,
}
