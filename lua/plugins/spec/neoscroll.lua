---@type NvPluginSpec
return {
  "karb94/neoscroll.nvim",
  event = "WinScrolled", -- or "InsertEnter"
  config = function()
    local neoscroll = require "neoscroll"

    neoscroll.setup {
      mappings = {
        ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
        ["<C-h>"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
        ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } },
        ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } },
        ["zz"] = { "scroll", { "0.5", "true", "250" } }, -- auto
      },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      cursor_scrolls_alone = true,
      easing_function = "circular",
    }
  end,
}
