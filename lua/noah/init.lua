local M = {}

require "noah.globals"
require "noah.usercmds"
require "noah.autocmds"
require "noah.aliases"
-- require "noah.wsl"
-- require "noah.linux"
require "noah.wezterm"
require "noah.macos"

-- Setup UTF-8 encoding
require("noah.encoding").setup()

local is_mac = vim.loop.os_uname().sysname == "Darwin"
local is_linux = vim.loop.os_uname().sysname == "Linux"
local is_windows = vim.loop.os_uname().sysname:find "Windows" ~= nil

if is_mac then
  require "noah.macos"
elseif is_linux then
  require "noah.linux"
elseif is_windows then
  require "noah.windows"
end

require "noah.vim"
require "noah.filetypes"
require "noah.material-ui"
require "noah.LSP.main"
require "noah.config"

return M
