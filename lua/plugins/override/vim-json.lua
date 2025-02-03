---@type NvPluginSpec
return {
  "elzr/vim-json",
  config = function()
    vim.cmd [[
      let g:json_reformat_on_save = 1
      let g:json_syntax_conceal = 1
    ]]

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*.parcelrc",
      command = "set filetype=json",
    })
  end,
}
