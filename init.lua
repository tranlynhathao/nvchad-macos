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

-- Blockchain workflow is useful, but it only needs commands/keymaps/autocmds.
-- Defer it until after the first UI cycle so startup can render sooner.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local ok, blockchain = pcall(require, "noah.blockchain")
    if ok then
      blockchain.setup()
    end
  end,
})

vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10
