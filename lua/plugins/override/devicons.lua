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
        pug = {
          icon = "", -- 謹
          color = "#a86454",
          cterm_color = "65",
          name = "Pug",
        },
        rb = {
          icon = "",
          color = "#f50707",
          cterm_color = "167",
          name = "Ruby",
        },
      },
      color_icons = true,
      default = true,
    }
  end,
}
