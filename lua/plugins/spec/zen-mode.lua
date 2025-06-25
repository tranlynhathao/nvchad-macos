-- ---@type NvPluginSpec
-- return {
--   "folke/zen-mode.nvim",
--   dependencies = { "folke/twilight.nvim" },
--   cmd = "ZenMode",
--   opts = {
--     window = {
--       backdrop = 0.95,
--       width = 80,
--       height = 0.85,
--       options = {
--         signcolumn = "no",
--         number = false,
--         relativenumber = false,
--         cursorline = false,
--         foldcolumn = "0",
--         list = false,
--       },
--     },
--     plugins = {
--       options = {
--         enabled = true,
--         ruler = false,
--         showcmd = false,
--       },
--       -- twilight = { enabled = true },
--       -- gitsigns = { enabled = false },
--       tmux = { enabled = false },
--       kitty = {
--         enabled = false,
--         font = "+2",
--       },
--       alacritty = {
--         enabled = false,
--         font = "14",
--       },
--     },
--     on_open = function()
--       vim.cmd "IBLDisable"
--     end,
--     on_close = function()
--       vim.cmd "IBLEnable"
--     end,
--   },
-- }

---@type NvPluginSpec
return {
  "folke/zen-mode.nvim",
  dependencies = { "folke/twilight.nvim" },
  cmd = "ZenMode",
}
