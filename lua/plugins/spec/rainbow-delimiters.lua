-- ---@type NvPluginSpec
-- return {
--   -- TODO: re-enable once html support improves
--   enabled = false,
--   "HiPhish/rainbow-delimiters.nvim",
--   event = "FileType",
--   config = function()
--     dofile(vim.g.base46_cache .. "rainbow-delimiters")
--     require("rainbow-delimiters").setup()
--   end,
-- }

---@type NvPluginSpec
return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "FileType",
  enabled = true,
  config = function()
    local rainbow_delimiters = require "rainbow-delimiters"

    vim.api.nvim_set_hl(0, "RainbowDelimiterPink", { fg = "#ff79c6" })
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        lua = rainbow_delimiters.strategy["local"],
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
        "RainbowDelimiterPink",
      },
    }
  end,
}
