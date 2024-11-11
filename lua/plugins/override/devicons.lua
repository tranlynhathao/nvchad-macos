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
        Makefile = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Makefile",
        },
        ["rockspec"] = {
          icon = "",
          color = "#a074c4",
          cterm_color = "140",
          name = "Rockspec",
        },
        ["vitest.config.js"] = {
          icon = "ﭧ",
          color = "#cbcb41",
          name = "VitestJS",
        },
        ["vitest.ts"] = {
          icon = "ﭧ", -- 텦termicons
          color = "#FA9E59",
          name = "VitestTS",
        },
      },
      color_icons = true,
      default = true,
    }
  end,
}
