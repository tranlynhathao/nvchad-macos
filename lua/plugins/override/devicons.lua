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
        -- ["pl"] = {
        --   icon = "🐪",
        --   color = "#3178c6",
        --   cterm_color = "74",
        --   name = "Perl",
        -- },
        ["prolog"] = {
          icon = "",
          color = "#A074C4",
          cterm_color = "140",
          name = "Prolog",
        },
        ["pl"] = {
          icon = "",
          color = "#A074C4",
          cterm_color = "140",
          name = "PrologFile",
        },
        ["pug"] = {
          icon = "",
          color = "#a86454",
          cterm_color = "65",
          name = "Pug",
        },
        ["rb"] = {
          icon = "",
          color = "#f50707",
          cterm_color = "167",
          name = "Ruby",
        },
        ["Makefile"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Makefile",
        },
        ["netlify.toml"] = {
          icon = "",
          color = "#15847c",
          cterm_color = "29",
          name = "Netlify",
        },

        [".all-contributorsrc"] = {
          icon = "",
          color = "#ffcc00",
          cterm_color = "220",
          name = "AllContributors",
        },
      },
      color_icons = true,
      default = true,
    }
  end,
}
