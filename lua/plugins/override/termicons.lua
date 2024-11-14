---@type NvPluginSpec
return {
  "mskelton/termicons.nvim",
  requires = { "DaikyXendo/nvim-web-devicons" },
  config = function()
    local termicons = require "termicons"
    termicons.setup() -- Don't forget to call setup

    -- override icons for some filetypes
    require("nvim-web-devicons").setup {
      override = {
        ["lua"] = {
          icon = "",
          color = "#51a0cf",
          name = "Lua",
        },
        ["stylua.toml"] = {
          icon = "",
          color = "#6D8086",
          name = "StyluaConfig",
        },
        ["3d"] = {
          icon = "",
          color = "#29b6f6",
          name = "3d",
        },
        ["abc"] = {
          icon = "",
          color = "#ff5722",
          name = "Abc",
        },
        ["ada"] = {
          icon = "",
          color = "#0277bd",
          name = "Ada",
        },
        -- Add more filetypes here
      },
    }
  end,
  build = false,
}
