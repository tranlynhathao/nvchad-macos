--[=[
Rust lsp and formatting
`rust-analyzer` recommend to install using rustup

```
rustup component add rust-src rust-analyzer
```

format using rustfmt
--]=]

local ok = require("noah.utils.check_requires").check {
  "cmp_nvim_lsp",
  "null-ls",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local null_ls = require "null-ls"

local on_attach = function(client, bufnr)
  require "noah.LSP.utils.keymap"(bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format()"
  end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        enable = false,
      },
    },
  },
})

null_ls.register {
  name = "null-ls-Rust",
  sources = {
    null_ls.builtins.formatting.rustfmt.with {
      filetypes = { "rust" },
    },
  },
  on_attach = on_attach,
}
