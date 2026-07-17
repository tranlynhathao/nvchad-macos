vim.opt.signcolumn = "yes"

-- Diagnostic UI (virtual_text/signs/float) is owned by plugins/override/lspconfig.lua.
-- Only sign icons live here.
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
