---@type NvPluginSpec
return {
  "NvChad/ui",
  dev = false,
  branch = "v3.0",
  config = function()
    -- luacheck: globals theme_colors
    local colors = _G.theme_colors or { bg = "#000000", fg = "#FFFFFF" }

    -- apply into highlights (if needed)
    vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })

    require "nvchad"
  end,
}
