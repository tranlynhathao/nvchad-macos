---@type NvPluginSpec
return {
  "digitaltoad/vim-pug",
  config = function()
    vim.cmd [[autocmd BufNewFile,BufRead *.pug set filetype=pug]]
  end,
}
