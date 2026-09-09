vim.g.mapleader = " "
vim.g.maplocalleader = ","

if vim.loader then vim.loader.enable() end

require "compat"
require "bootstrap"
require "noah"
require "options"
require "mappings"
require "helpers"
require "help_floating"
require "floating_term"
require "functions"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local ok, blockchain = pcall(require, "noah.blockchain")
    if ok then blockchain.setup() end
  end,
})

vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10
