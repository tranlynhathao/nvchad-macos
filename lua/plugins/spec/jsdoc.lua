---@type NvPluginSpec
return {
  "heavenshell/vim-jsdoc",
  ft = { "javascript", "typescript" },
  build = "npm install -g jsdoc",
  config = function()
    vim.g.jsdoc_enable_es6 = 1
    vim.g.jsdoc_formatter = "jsdoc"
  end,
}
