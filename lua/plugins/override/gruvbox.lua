---@type NvPluginSpec
return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load early
  opts = {
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- Set up color for searching, diff, statusline and error
    contrast = "", -- "hard", "soft" or empty
    palette_overrides = {
      bright_green = "#990000", -- palette color
    },
    overrides = {
      SignColumn = { bg = "#ff9900" },
      ["@lsp.type.method"] = { bg = "#ff9900" },
      ["@comment.lua"] = { bg = "#000000" },
    },
    dim_inactive = false,
    transparent_mode = false,
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.o.background = "dark" -- or "light"
    vim.cmd "colorscheme gruvbox"
  end,
}
