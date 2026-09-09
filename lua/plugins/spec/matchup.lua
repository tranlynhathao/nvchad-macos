---@type NvPluginSpec
return {
  "andymass/vim-matchup",
  -- matchup enhances `%` — bind to first buffer read, not LSP attach.
  event = "BufReadPost",
  config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
}
