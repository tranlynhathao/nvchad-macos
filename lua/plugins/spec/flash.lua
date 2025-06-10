---@type NvPluginSpec

-- Jump to characters/strings instantly, like easymotion.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
  },
}

-- return {
--   "folke/flash.nvim",
--   event = "VeryLazy",
--   opts = {
--     search = {
--       mode = "exact",
--       multi_window = true,
--       wrap = true,
--     },
--     jump = {
--       autojump = true,
--       pos = "start",
--       jumplist = true,
--     },
--     label = {
--       uppercase = true,
--       exclude = "aeiou",
--       current = true,
--       after = true,
--     },
--   },
--   keys = {
--     {
--       "s",
--       mode = { "n", "x", "o" },
--       function()
--         require("flash").jump()
--       end,
--       desc = "Flash Jump",
--     },
--     {
--       "S",
--       mode = { "n", "x", "o" },
--       function()
--         require("flash").treesitter()
--       end,
--       desc = "Flash Treesitter",
--     },
--     {
--       "<c-s>",
--       mode = { "c" },
--       function()
--         require("flash").toggle()
--       end,
--       desc = "Toggle Flash Search",
--     },
--   },
-- }
