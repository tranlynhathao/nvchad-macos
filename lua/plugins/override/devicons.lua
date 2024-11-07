---@type NvPluginSpec
return {
  "DaikyXendo/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh",
        },
        [".prettierrc.json"] = {
          icon = "",
          color = "#cbcb41",
          name = "Prettier",
        },
        ["vitest.config.ts"] = {
          icon = "ﭧ",
          color = "#FA9E59",
          name = "Vitest",
        },
      },
      color_icons = true,
      default = true,
    }
  end,
}
