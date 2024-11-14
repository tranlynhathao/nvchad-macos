---@type NvPluginSpec
return {
  "NvChad/ui",
  dev = false,
  branch = "v3.0",
  config = function()
    -- Ensure theme_colors is defined with fallback values
    local theme_colors = theme_colors or { bg = "#000000", fg = "#FFFFFF" }

    require "nvchad"
  end,
}
