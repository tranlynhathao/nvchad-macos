-- ~/.config/nvim/init.lua
-- require module
require "bootstrap"
require "gale.globals"
require "gale.usercmds"
require "gale.autocmds"
require "gale.aliases"
-- require "gale.wsl"
-- require "gale.linux"
require "gale.macos"
require "gale.vim"
require "gale.filetypes"
require "options"
require "gale.material-ui"
require "gale.LSP.main"
require "mappings"
require "configs.keymaps"
require "functions"
-- end require

-- Autocommand to reload config on save
vim.cmd "source ~/.config/nvim/lua/chadrc.lua"

-- Autocommand to reload Lua files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    vim.cmd "luafile %"
  end,
})

-- Lazygit command
vim.api.nvim_create_user_command("Lazygit", function()
  require("lazygit").lazygit()
end, {})

-- Notify configuration
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if not msg:match "Re-sourcing your config is not supported with lazy.nvim" then
    original_notify(msg, level, opts)
  end
end

-- Slime configuration
vim.g.slime_target = "tmux"
vim.g.slime_bracketed_paste = 1
vim.g.base47_cache = vim.fn.stdpath "cache" .. "/base47/"
