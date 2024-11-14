---@type NvPluginSpec

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "DaikyXendo/nvim-web-devicons", opt = true }, -- Optional for icons
  config = function()
    require("lualine").setup {
      options = {
        theme = "gruvbox", -- Change to your preferred theme
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        icons_enabled = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly, modified)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end,
}
