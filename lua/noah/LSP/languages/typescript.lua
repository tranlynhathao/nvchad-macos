--[=[
JS/TS LSP (ts_ls). Linting via eslint-lsp (already in lspconfig.lua); format via
conform (prettier).
--]=]

local ok = require("noah.utils.check_requires").check {
  "cmp_nvim_lsp",
  "lspconfig.util",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local util = require "lspconfig.util"

local function on_attach(_, bufnr)
  require "noah.LSP.utils.keymap"(bufnr)
end

vim.lsp.config("ts_ls", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  root_dir = util.root_pattern "package.json, .git",
  single_file_support = false,
})
