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
