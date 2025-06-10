---@type NvPluginSpec

-- Increment/decrement numbers, booleans, dates, etc.
return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
      mode = "n",
      desc = "Dial increment",
    },
    {
      "<C-x>",
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
      mode = "n",
      desc = "Dial decrement",
    },
  },
  config = function()
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.date.alias["%Y/%m/%d"],
      },
    }
  end,
}
