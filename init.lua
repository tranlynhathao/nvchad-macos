require "compat"
require "bootstrap"
require "noah"
require "options"
require "mappings"
require "helpers"
require "help_floating"
require "floating_term"
require "configs.autocmd"
require "configs.keymaps"
require "functions"

-- Blockchain development tools
local ok, blockchain = pcall(require, "noah.blockchain")
if ok then
  blockchain.setup()
end

vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10
