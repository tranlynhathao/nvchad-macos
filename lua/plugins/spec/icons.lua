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
}
