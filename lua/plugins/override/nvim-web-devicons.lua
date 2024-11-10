---@type NvPluginSpec
return {
  "nvim-tree/nvim-web-devicons",
  opts = {
    override = {
      -- For some reason md changes here don't take effect
      md = { icon = "󰽛", color = "#FFFFFF", name = "Md" },
      mdx = { icon = "󰽛", color = "#FFFFFF", name = "Mdx" },
      markdown = { icon = "󰽛", color = "#FFFFFF", name = "Markdown" },
      rmd = { icon = "󰽛", color = "#FFFFFF", name = "Rmd" },
      -- pug = {
      --   icon = "🐶", -- 襁
      --   color = "#dea584",
      --   cterm_color = "215",
      --   name = "Pug",
      -- },
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
      ["toml"] = {
        icon = "",
        color = "#42a5f4",
        cterm_color = "66",
        name = "Toml",
      },
      ["LICENSE"] = {
        icon = "",
        color = "#ff5722",
        cterm_color = "202",
        name = "License",
      },
    },
    override_by_extension = {
      astro = { icon = "", color = "#FE5D02", name = "astro" },
      javascript = { icon = "" },
      typescript = { icon = "󰛦" },
      lockb = { icon = "", color = "#FBF0DF", name = "bun-lock" },
    },
    override_by_filename = {
      [".stylua.toml"] = { icon = "", color = "#6D8086", name = "stylua" },
      [".gitignore"] = { icon = "", color = "#6D8086", name = "gitignore" },
      ["license"] = { icon = "󰿃", name = "License" },
    },
  },
}
