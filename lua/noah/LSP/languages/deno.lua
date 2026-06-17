--[=[
Deno LSP. Format handled by conform (see conform.lua).
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

vim.g.markdown_fenced_languages = {
  "ts=typescript",
}

local function on_attach(_, bufnr)
  require "noah.LSP.utils.keymap"(bufnr)
end

vim.lsp.config("denols", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  init_options = {
    enable = true,
    lint = true,
    unstable = false,
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
  single_file_support = false,
})
