-- -- ~/.config/nvim/init.lua
-- -- require module
-- require "bootstrap"
-- require "noah.globals"
-- require "noah.usercmds"
-- require "noah.autocmds"
-- require "noah.aliases"
-- -- require "noah.wsl"
-- -- require "noah.linux"
-- require "noah.wezterm"
-- require "noah.macos"
-- require "noah.vim"
-- require "noah.filetypes"
-- require "options"
-- require "noah.material-ui"
-- require "noah.LSP.main"
-- require "mappings"
-- require "helpers"
-- require "help_floating"
-- require "floating_term"
-- require "configs.keymaps"
-- require "configs.autocmd"
-- require "functions"
-- -- end require
--
-- -- Autocommand to reload config on save
-- vim.cmd "source ~/.config/nvim/lua/chadrc.lua"
--
-- vim.cmd [[
--   autocmd BufRead,BufNewFile *.pl
--     \ if search(':-', 'nw') |
--     \   let b:filetype = 'prolog' |
--     \ else |
--     \   let b:filetype = 'perl' |
--     \ endif
-- ]]
--
-- -- Autocommand to reload Lua files on save
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*.lua",
--   callback = function()
--     vim.cmd "luafile %"
--   end,
-- })
--
-- -- Set cursorline
-- vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25,r-cr:hor20,o:hor50"
--
-- vim.cmd [[
--   highlight Cursor guibg=#ffcc00 guifg=black
--   highlight lCursor guibg=#ffcc00 guifg=black
-- ]]
--
-- -- Lazygit command
-- vim.api.nvim_create_user_command("Lazygit", function()
--   require("lazygit").lazygit()
-- end, {})
--
-- -- Notify configuration
-- local original_notify = vim.notify or function() end
-- vim.notify = function(msg, level, opts)
--   if not msg:match "Re-sourcing your config is not supported with lazy.nvim" then
--     original_notify(msg, level, opts)
--   end
-- end
--
-- vim.notify = function(msg, ...)
--   if msg:match "nvchad.stl.default" then
--     return
--   end
--   return require "notify"(msg, ...)
-- end
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*",
--   callback = function()
--     local file = vim.fn.expand "%:p"
--     local size = vim.fn.getfsize(file)
--     vim.notify(string.format("File saved: %s (%.2f KB)", file, size / 1024))
--   end,
-- })
--
-- vim.cmd "syntax enable"
-- vim.cmd "filetype plugin indent on"
--
-- -- Slime configuration
-- vim.g.slime_target = "tmux"
-- vim.g.slime_bracketed_paste = 1
-- vim.g.base47_cache = vim.fn.stdpath "cache" .. "/base47/"

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
