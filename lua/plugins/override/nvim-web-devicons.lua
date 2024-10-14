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
      pug = {
        icon = "🐶", -- 襁
        color = "#dea584",
        cterm_color = "215",
        name = "Pug",
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
