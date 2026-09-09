-- LSP module bootstrap.
--
-- After tier-3 migration, per-server LSP configs live in
-- ~/.config/nvim/lsp/<name>.lua and are auto-discovered by Neovim on
-- vim.lsp.enable(). The old noah/LSP/languages/* modules are gone.
--
-- This file only wires the utility bits that still live under noah/LSP/:
--   * diagnostic UI icons  (utils.icon)
--   * cmp keymap defaults  (utils.cmp)
--   * luasnip loader       (luasnip.main)
--
local M = {}

M.setup = function()
  require "noah.LSP.utils.icon"
  require "noah.LSP.utils.cmp"
  require "noah.LSP.luasnip.main"
end

if not pcall(debug.getlocal, 4, 1) then M.setup() end

return M
