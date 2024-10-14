---@type NvPluginSpec
return {
  "sheerun/vim-polyglot",
  config = function()
    vim.g.polyglot_disabled = { "autoindent" }

    vim.cmd [[autocmd BufNewFile,BufRead *.pug set filetype=pug]]
  end,
}
