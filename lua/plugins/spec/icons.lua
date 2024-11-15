---@type NvPluginSpec
return {
  {
    "junegunn/vim-emoji",
    config = function()
      vim.cmd [[
        autocmd BufWritePre * :EmojiReplace
      ]]
    end,
  },

  {
    "nvim-lua/plenary.nvim",
    config = function()
      local emoji_map = {
        [":penguin:"] = "🐧",
        [":smile:"] = "😄",
        [":heart:"] = "❤️",
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          for k, v in pairs(emoji_map) do
            vim.api.nvim_buf_set_lines(
              bufnr,
              0,
              -1,
              false,
              vim.tbl_map(function(line)
                return line:gsub(k, v)
              end, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
            )
          end
        end,
      })
    end,
  },
}
