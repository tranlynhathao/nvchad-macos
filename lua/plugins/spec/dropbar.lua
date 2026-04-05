---@type NvPluginSpec
return {
  "Bekaboo/dropbar.nvim",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local configs = require "dropbar.configs"

    local default_enable = configs.opts.bar.enable
    configs.opts.bar.enable = function(buf, win, info)
      buf = vim._resolve_bufnr(buf)
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "NvimTree" then
        return false
      end

      return default_enable(buf, win, info)
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "NvimTree" then
        vim.wo[win].winbar = ""
      end
    end
  end,
}
