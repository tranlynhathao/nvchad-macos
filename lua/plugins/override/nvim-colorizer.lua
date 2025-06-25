---@type NvPluginSpec
return {
  "NvChad/nvim-colorizer.lua",
  enabled = false,
  opts = {
    user_default_options = {
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      sass = { enable = true, parsers = { "css" } },
      mode = "virtualtext",
      virtualtext = "󱓻",
    },
  },
}

-- ---@type NvPluginSpec
-- return {
--   "NvChad/nvim-colorizer.lua",
--   enabled = true,
--   opts = {
--     filetypes = {
--       "css", "scss", "html", "javascript", "typescript", "lua",
--       "json", "yaml", "markdown", "toml", "svelte", "astro",
--     },
--     user_default_options = {
--       names = true,
--       RRGGBBAA = true,
--       AARRGGBB = true,
--       rgb_fn = true,
--       hsl_fn = true,
--       css = true,
--       css_fn = true,
--       sass = { enable = true, parsers = { "css" } },
--       virtualtext = "●",
--       mode = "virtualtext", -- or "background"
--       always_update = false, -- Use when invisible lag
--     },
--     exclude = {
--       "NvimTree", "TelescopePrompt", "alpha", "dashboard", "lazy", "Trouble"
--     },
--   },
-- }
