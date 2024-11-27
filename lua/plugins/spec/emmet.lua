---@type NvPluginSpec
return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "typescript" },
  config = function()
    vim.api.nvim_set_keymap("i", "<Tab>", "<Plug>(EmmetExpandAbbrev)", { noremap = true, silent = true })
  end,
}
