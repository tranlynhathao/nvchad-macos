--[=[
CSS completions
```
npm i -g vscode-langservers-extracted @fsouza/prettierd
```
--]=]

local ok = require("vincent.utils.check_requires").check {
  "cmp_nvim_lsp",
  "null-ls",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local null_ls = require "null-ls"

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require "vincent.LSP.utils.keymap"(bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

null_ls.register {
  name = "null-ls-CSS",
  sources = {
    null_ls.builtins.formatting.prettierd.with {
      filetypes = { "css", "scss", "less" },
    },
  },
}
