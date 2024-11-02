---@type NvPluginSpec
return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    local map = vim.keymap.set
    local api = require "Comment.api"

    map("n", "<leader>_", function()
      api.toggle.blockwise.current()
    end, { desc = "Comment toggle (block) in single line" })

    map("n", "<leader>/", function()
      api.toggle.linewise.current()
    end, { desc = "Comment toggle" })

    map(
      "x",
      "<leader>/",
      "<cmd>set operatorfunc=v:lua.__toggle_contextual<CR>g@",
      { desc = "Comment toggle (aware of context)" }
    )
  end,
  ---@param opts CommentConfig
  config = function(_, opts)
    local comment = require "Comment"
    local ts_addon = require "ts_context_commentstring.integrations.comment_nvim"
    opts.pre_hook = function(ctx)
      vim.api.nvim_echo({ { vim.inspect(ctx), "Normal" } }, false, {})
      vim.api.nvim_echo({ { vim.inspect(require("Comment.ft").ctype), "Normal" } }, false, {})
      if vim.bo.filetype == "pug" then
        if ctx.ctype == require("Comment.ft").ctype.line then
          return "// %s"
        else
          return "//- %s"
        end
      end

      local ts_pre_hook = ts_addon.create_pre_hook()
      return ts_pre_hook and ts_pre_hook(ctx) or ""
    end
    comment.setup(opts)
  end,
}
