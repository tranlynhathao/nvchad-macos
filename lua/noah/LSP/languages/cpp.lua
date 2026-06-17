--[=[
clangd LSP. Format do conform (clang-format) lo; lint do nvim-lint (clang-tidy).
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

vim.lsp.config("clangd", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = function(client, bufnr)
    -- clangd has builtin format; disable so conform is the single source.
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  root_dir = util.root_pattern "compile_commands.json",
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--enable-config",
    "--offset-encoding=utf-16",
  },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
})
