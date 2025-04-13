-- encoding.lua
local M = {}

function M.setup()
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
  vim.opt.fileencodings = { "utf-8" }
end

return M
