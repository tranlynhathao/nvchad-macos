--[=[
lua-language-server. Format handled by conform (stylua), not via LSP.
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

vim.lsp.config("lua_ls", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = function(client, bufnr)
    -- Disable LSP format to avoid duplicating conform/stylua.
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
