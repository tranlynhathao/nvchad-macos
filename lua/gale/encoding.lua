-- encoding.lua
local M = {}

function M.setup()
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
  vim.opt.fileencodings = { "utf-8", "ucs-bom", "euc-jp", "cp932", "sjis", "iso-2022-jp", "latin1" }
end

return M
