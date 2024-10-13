require "gale.globals"
require "bootstrap"
require "gale.usercmds"
require "gale.autocmds"
require "gale.aliases"
-- require "gale.wsl"
-- require "gale.linux"
require "gale.macos"
require "options"
require "mappings"
require "configs.keymaps"

vim.cmd "autocmd BufWritePost *.lua source %"

vim.cmd [[
augroup StatusLineGroup
  autocmd!
  autocmd BufEnter * setlocal statusline=%f\ %m\ %r
augroup END
]]

-- Custom configuration
local function InsertBackLink()
  local backlink_text = vim.fn.input "Backlink Text: "
  local backlink_url = vim.fn.input "Backlink URL: "
  vim.api.nvim_put({ "[" .. backlink_text .. "](" .. backlink_url .. ")" }, "c", true, true)
end

_G.InsertBackLink = InsertBackLink

-- Open Lazygit
vim.api.nvim_create_user_command("Lazygit", function()
  require("lazygit").lazygit()
end, {})

vim.opt.clipboard = "unnamedplus"

vim.g.slime_target = "neovim"
vim.api.nvim_set_keymap("v", "<C-c>", "<Plug>SlimeSend", { noremap = true, silent = true })

-- Lua configuration for telescope to open markdown links
function OpenMarkdownLink()
  local line = vim.api.nvim_get_current_line()
  local path = string.match(line, "%]%((.-)%)")

  if path then
    vim.cmd("edit " .. path)
  else
    print "No markdown link found on this line"
  end
end

vim.api.nvim_set_keymap("n", "<C-o>", ":lua OpenMarkdownLink()<CR>", { noremap = true, silent = true })
