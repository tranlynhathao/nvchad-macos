---@type NvPluginSpec
return {
  "sainnhe/gruvbox-material",
  priority = 1000, -- gruvbox-material load early
  config = function()
    -- palette: "material", "mix", or "original"
    vim.g.gruvbox_material_palette = "material" -- "mix" or "original"

    vim.g.gruvbox_material_background = "medium" -- "soft", "medium", or "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_diagnostic_text_highlight = 1
    vim.g.gruvbox_material_diagnostic_line_highlight = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

    vim.o.background = "dark" -- or "light"
    vim.cmd "colorscheme gruvbox-material"
  end,
}
