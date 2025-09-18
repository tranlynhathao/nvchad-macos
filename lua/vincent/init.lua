local M = {}

require "vincent.globals"
require "vincent.usercmds"
require "vincent.autocmds"
require "vincent.aliases"
-- require "vincent.wsl"
-- require "vincent.linux"
require "vincent.wezterm"
require "vincent.macos"

-- Setup UTF-8 encoding
require("vincent.encoding").setup()

local is_mac = vim.loop.os_uname().sysname == "Darwin"
local is_linux = vim.loop.os_uname().sysname == "Linux"
local is_windows = vim.loop.os_uname().sysname:find "Windows" ~= nil

if is_mac then
  require "vincent.macos"
elseif is_linux then
  require "vincent.linux"
elseif is_windows then
  require "vincent.windows"
end

require "vincent.vim"
require "vincent.filetypes"
require "vincent.material-ui"
require "vincent.LSP.main"
require "vincent.config"

return M
