--[=[
intelephense for language server
```
npm i -g intelephense
```
--]=]

local ok = require("vincent.utils.check_requires").check {
  "cmp_nvim_lsp",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"

local on_attach = function(client, bufnr)
  require "vincent.LSP.utils.keymap"(bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format()"
  end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config("intelephense", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
})
