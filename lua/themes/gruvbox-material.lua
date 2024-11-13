-- ~/.config/nvim/lua/themes/gruvbox-material.lua
return {
  "sainnhe/gruvbox-material",
  priority = 1000,
  config = function()
    vim.o.background = "dark"
    vim.g.gruvbox_material_palette = "material" -- Chọn bảng màu "material"
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.cmd "colorscheme gruvbox-material"
  end,
}
