--[=[
install clang with bundle clangd and clang-format
--]=]

local ok = require("noah.utils.check_requires").check {
  "cmp_nvim_lsp",
  "null-ls",
  "lspconfig.util",
}
if not ok then
  return
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"
local null_ls = require "null-ls"
local util = require "lspconfig.util"

local on_attach = function(client, bufnr)
  require "noah.LSP.utils.keymap"(bufnr)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config("clangd", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  root_dir = util.root_pattern "compile_commands.json",
})

null_ls.register {
  name = "null-ls-Cpp",
  sources = {
    null_ls.builtins.formatting.clang_format.with {},
  },
  on_attach = on_attach,
}
