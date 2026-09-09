-- nvim-lsp-endhints is disabled.
--
-- It rendered LSP parameter-name hints (`← modname`, `← f, arg1`,
-- `← event, opts`, ...) at end-of-line via the `lspEndhints` namespace.
-- The gray labels became noisy for obvious `require()` / `pcall()` /
-- `vim.api.nvim_create_autocmd()` calls.
--
-- Neovim's built-in vim.lsp.inlay_hint already handles the same LSP
-- semantic, so removing this plugin does not lose the capability — hints
-- reappear via `:lua vim.lsp.inlay_hint.enable(true, { bufnr = 0 })`
-- when needed, and lua_ls's paramName policy governs what it emits.
--
-- Spec kept (not deleted) so re-enabling is a one-line flip.
---@type NvPluginSpec
return {
  "chrisgrieser/nvim-lsp-endhints",
  enabled = false,
}
