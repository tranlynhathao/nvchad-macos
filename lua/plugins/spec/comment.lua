---@type NvPluginSpec
return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    local map = vim.keymap.set

    map("n", "<leader>_", function()
      local api = require "Comment.api"
      api.toggle.blockwise.current()
    end, { desc = "Comment toggle (block) in single line" })

    map("n", "<leader>/", function()
      local line = vim.api.nvim_get_current_line()
      if vim.bo.filetype == "pug" then
        if line:sub(1, 2) == "//" then
          vim.api.nvim_set_current_line(line:sub(4))
        else
          vim.api.nvim_set_current_line("// " .. line)
        end
      else
        local api = require "Comment.api"
        api.toggle.linewise.current()
      end
    end, { desc = "Comment toggle for Pug files" })

    -- comment for normalfile
    -- map("n", "<leader>/", function()
    --   api.toggle.linewise.current()
    -- end, { desc = "Comment toggle" })

    map("x", "<leader>/", function()
      local api = require "Comment.api"
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { desc = "Comment toggle (aware of context)" })
  end,
  ---@param opts CommentConfig
  config = function(_, opts)
    local comment = require "Comment"
    local ts_addon = require "ts_context_commentstring.integrations.comment_nvim"

    opts.pre_hook = function(ctx)
      -- vim.api.nvim_echo({ { vim.inspect(ctx), "Normal" } }, false, {}) -- inspect
      if vim.bo.filetype == "pug" then
        if ctx.ctype == require("Comment.ft").ctype.line then
          return "// %s"
        elseif ctx.ctype == require("Comment.ft").ctype.block then
          return "//- %s"
        else
          return "// %s"
        end
      end

      local ts_pre_hook = ts_addon.create_pre_hook()
      return ts_pre_hook and ts_pre_hook(ctx) or ""
    end

    comment.setup(opts)
  end,
}
