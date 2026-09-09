-- oil-vcs-status is disabled.
--
-- It renders Git symbols in Oil's signcolumn (via extmark sign_text at col 0),
-- and its per-directory status is a priority-collapsed single letter — so a
-- folder with modified+untracked descendants only shows `M` and never `?`.
--
-- The single-channel renderer in lua/noah/oil_git_agg.lua handles both files
-- AND directories via one EOL virt_text extmark per entry, with per-letter
-- highlight and full set-union aggregation for directories.
--
-- Spec kept (not deleted) so re-enabling is a one-line flip if needed.
return {
  "SirZenith/oil-vcs-status",
  enabled = false,
}
