---@type NvPluginSpec
return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  -- Load only when user presses a comment key, not at startup. Saves ~600ms.
  keys = {
    {
      "<leader>_",
      function() require("Comment.api").toggle.blockwise.current() end,
      mode = "n",
      desc = "Comment toggle (block) single line",
    },
    {
      "<leader>/",
      function()
        local line = vim.api.nvim_get_current_line()
        if vim.bo.filetype == "pug" then
          if line:sub(1, 2) == "//" then
            vim.api.nvim_set_current_line(line:sub(4))
          else
            vim.api.nvim_set_current_line("// " .. line)
          end
        else
          require("Comment.api").toggle.linewise.current()
        end
      end,
      mode = "n",
      desc = "Comment toggle",
    },
    {
      "<leader>/",
      function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
      end,
      mode = "x",
      desc = "Comment toggle (visual)",
    },
  },
  ---@param opts CommentConfig
  config = function(_, opts)
    local comment = require "Comment"
    local ts_addon = require "ts_context_commentstring.integrations.comment_nvim"

    opts.pre_hook = function(ctx)
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
