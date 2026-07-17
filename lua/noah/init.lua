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

local is_mac = vim.uv.os_uname().sysname == "Darwin"
local is_linux = vim.uv.os_uname().sysname == "Linux"
local is_windows = vim.uv.os_uname().sysname:find "Windows" ~= nil

if is_mac then
  require "noah.macos"
elseif is_linux then
  require "noah.linux"
elseif is_windows then
  require "noah.windows"
end

require "noah.vim"
require "noah.filetypes"
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    -- Material UI snippets depend on LuaSnip; keep them off the startup path.
    pcall(require, "noah.material-ui")
  end,
})
require "noah.LSP.main"
require "noah.config"

return M
