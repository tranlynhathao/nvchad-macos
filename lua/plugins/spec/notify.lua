---@type NvPluginSpec
return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 50,
    stages = "fade_in_slide_out",
  },
  lazy = false,
  config = function()
    if not vim.g.base46_cache then
      vim.notify("base46_cache is not set!", vim.log.levels.ERROR)
      return
    end

    dofile(vim.g.base46_cache .. "notify")

    vim.notify = require "notify"
    ---@diagnostic disable-next-line
    vim.notify.setup {
      -- background_colour = "#1c2433",
      background_colour = "#1e1e1e",
      top_down = false,

      -- addition
      fps = 60,
      render = "minimal",
    }
  end,
}

-- ---@type NvPluginSpec
-- return {
--   "rcarriga/nvim-notify",
--   lazy = false,
--   config = function()
--     dofile(vim.g.base46_cache .. "notify")
--
--     vim.notify = require "notify"
--     ---@diagnostic disable-next-line
--     vim.notify.setup {
--       background_colour = "#1c2433",
--       top_down = true,
--     }
--   end,
-- }
