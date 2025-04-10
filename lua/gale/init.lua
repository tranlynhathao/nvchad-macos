local M = {}

require "gale.globals"
require "gale.usercmds"
require "gale.autocmds"
require "gale.aliases"
-- require "gale.wsl"
-- require "gale.linux"
require "gale.wezterm"
require "gale.macos"

local is_mac = vim.loop.os_uname().sysname == "Darwin"
local is_linux = vim.loop.os_uname().sysname == "Linux"
local is_windows = vim.loop.os_uname().sysname:find "Windows" ~= nil

if is_mac then
  require "gale.macos"
elseif is_linux then
  require "gale.linux"
elseif is_windows then
  require "gale.windows"
end

require "gale.vim"
require "gale.filetypes"
require "gale.material-ui"
require "gale.LSP.main"
require "gale.config"

return M
