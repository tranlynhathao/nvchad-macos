---@type NvPluginSpec
return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local configs = require "dropbar.configs"

    local default_enable = configs.opts.bar.enable
    configs.opts.bar.enable = function(buf, win, info)
      buf = vim._resolve_bufnr(buf)
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "NvimTree" then return false end

      return default_enable(buf, win, info)
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "NvimTree" then vim.wo[win].winbar = "" end
    end

    -- Safety wrap: dropbar's treesitter source calls vim.fn.matchstr on
    -- vim.treesitter.get_node_text() which occasionally returns a Blob for
    -- certain node contents -> `E976: Using a Blob as a String`. Swallow
    -- that failure at the source-entry boundary so the breadcrumb just
    -- shows nothing from treesitter for that update instead of throwing.
    local ok_ts, ts_source = pcall(require, "dropbar.sources.treesitter")
    if ok_ts and ts_source and type(ts_source.get_symbols) == "function" then
      local orig = ts_source.get_symbols
      ts_source.get_symbols = function(...)
        local ok, ret = pcall(orig, ...)
        if not ok then return {} end
        return ret
      end
    end
  end,
}
