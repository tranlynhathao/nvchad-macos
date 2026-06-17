--[=[
Rust. Note: rustaceanvim manages rust-analyzer independently. This file exists
only for legacy compatibility - rustaceanvim overrides it when loaded.
Format do conform (rustfmt) lo; lint do clippy (qua rust-analyzer).
--]=]

local ok = require("noah.utils.check_requires").check {
  "cmp_nvim_lsp",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"

local function on_attach(_, bufnr)
  require "noah.LSP.utils.keymap"(bufnr)
end

vim.lsp.config("rust_analyzer", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
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
