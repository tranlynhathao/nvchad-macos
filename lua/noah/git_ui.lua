-- Shared Git-status vocabulary for tree/directory UIs (Oil + nvim-tree).
--
-- Both plugins render Git decorations, but their taxonomies differ:
--   nvim-tree:  unstaged, staged, unmerged, renamed, untracked, deleted, ignored
--   oil-vcs-status: Added, Copied, Deleted, Ignored, Modified, Renamed,
--                   TypeChanged, Unmerged, Untracked, + Upstream* variants
-- This module is the single source of truth for the symbol + colour a state
-- gets, and exposes adapters that map each plugin's schema onto it.
--
-- Design goals:
--   * one letter per state, semantic and readable at a glance
--   * same symbol and same highlight group in both plugins
--   * directory aggregate uses `•` (never a file letter) to avoid the
--     misleading "directory looks modified" case
--   * ignored is muted (Comment), conflict is loudest (Error)

local M = {}

M.symbols = {
  modified = "M",
  added = "A",
  deleted = "D",
  renamed = "R",
  untracked = "?",
  conflict = "!",
  staged = "S",
  ignored = "·",
  dir_dirty = "•",
  clean = " ",
}

M.hl = {
  modified = "NoahGitModified",
  added = "NoahGitAdded",
  deleted = "NoahGitDeleted",
  renamed = "NoahGitRenamed",
  untracked = "NoahGitUntracked",
  conflict = "NoahGitConflict",
  staged = "NoahGitStaged",
  ignored = "NoahGitIgnored",
  dir_dirty = "NoahGitDirDirty",
}

-- Resolve highlight specs from the current theme's semantic colours so a
-- colorscheme swap keeps the vocabulary consistent. No hex-coded colours.
local function resolve(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

function M.hl_spec()
  local warn = resolve("DiagnosticWarn").fg or resolve("WarningMsg").fg
  local ok = resolve("DiagnosticOk").fg or resolve("String").fg
  local err = resolve("DiagnosticError").fg or resolve("ErrorMsg").fg
  local info = resolve("DiagnosticInfo").fg or resolve("Function").fg
  local hint = resolve("DiagnosticHint").fg or resolve("Constant").fg
  local muted = resolve("Comment").fg

  return {
    [M.hl.modified] = { fg = warn },
    [M.hl.added] = { fg = ok },
    [M.hl.deleted] = { fg = err },
    [M.hl.renamed] = { fg = info },
    [M.hl.untracked] = { fg = hint },
    [M.hl.conflict] = { fg = err, bold = true },
    [M.hl.staged] = { fg = ok, bold = true },
    [M.hl.ignored] = { fg = muted },
    [M.hl.dir_dirty] = { fg = muted, bold = true },
  }
end

function M.apply_highlights()
  for name, spec in pairs(M.hl_spec()) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

-- ── nvim-tree adapter ─────────────────────────────────────────────────────
-- nvim-tree schema (renderer.icons.glyphs.git.<key>):
--   unstaged, staged, unmerged, renamed, untracked, deleted, ignored
-- It has no separate "added" bucket — a new-and-staged file is `staged`.
-- Its `unstaged` covers modified worktree changes.
function M.nvim_tree_glyphs()
  return {
    unstaged = M.symbols.modified,
    staged = M.symbols.staged,
    unmerged = M.symbols.conflict,
    renamed = M.symbols.renamed,
    untracked = M.symbols.untracked,
    deleted = M.symbols.deleted,
    ignored = M.symbols.ignored,
  }
end

-- Icon-level highlight groups nvim-tree exposes (see appearance/init.lua).
-- Linking these to our canonical groups paints the letters in the shared
-- colour without touching the plugin source.
function M.nvim_tree_hl_links()
  return {
    NvimTreeGitDirtyIcon = M.hl.modified,
    NvimTreeGitStagedIcon = M.hl.staged,
    NvimTreeGitMergeIcon = M.hl.conflict,
    NvimTreeGitRenamedIcon = M.hl.renamed,
    NvimTreeGitNewIcon = M.hl.untracked,
    NvimTreeGitDeletedIcon = M.hl.deleted,
    NvimTreeGitIgnoredIcon = M.hl.ignored,
    -- File-name tint (highlight_git = true).
    NvimTreeGitFileDirtyHL = M.hl.modified,
    NvimTreeGitFileStagedHL = M.hl.staged,
    NvimTreeGitFileMergeHL = M.hl.conflict,
    NvimTreeGitFileRenamedHL = M.hl.renamed,
    NvimTreeGitFileNewHL = M.hl.untracked,
    NvimTreeGitFileDeletedHL = M.hl.deleted,
    NvimTreeGitFileIgnoredHL = M.hl.ignored,
    -- Directory aggregate — nvim-tree tints the folder name when a
    -- descendant is dirty. Use the muted dir_dirty colour so it reads as
    -- "changes inside" instead of the folder being changed itself.
    NvimTreeGitFolderDirtyHL = M.hl.dir_dirty,
    NvimTreeGitFolderStagedHL = M.hl.dir_dirty,
    NvimTreeGitFolderMergeHL = M.hl.conflict,
    NvimTreeGitFolderRenamedHL = M.hl.dir_dirty,
    NvimTreeGitFolderNewHL = M.hl.dir_dirty,
    NvimTreeGitFolderDeletedHL = M.hl.dir_dirty,
    NvimTreeGitFolderIgnoredHL = M.hl.ignored,
  }
end

-- ── oil-vcs-status adapter ────────────────────────────────────────────────
-- Local worktree StatusType keys map onto our vocabulary. Upstream (index)
-- entries are collapsed to blanks so the tree shows one column of state per
-- file — matching nvim-tree's single-glyph presentation.
function M.oil_vcs_status_symbols(StatusType)
  return {
    [StatusType.Added] = M.symbols.added,
    [StatusType.Copied] = M.symbols.added,
    [StatusType.Deleted] = M.symbols.deleted,
    [StatusType.Ignored] = M.symbols.ignored,
    [StatusType.Modified] = M.symbols.modified,
    [StatusType.Renamed] = M.symbols.renamed,
    [StatusType.TypeChanged] = M.symbols.modified,
    [StatusType.Unmodified] = M.symbols.clean,
    [StatusType.Unmerged] = M.symbols.conflict,
    [StatusType.Untracked] = M.symbols.untracked,
    [StatusType.External] = M.symbols.clean,

    [StatusType.UpstreamAdded] = M.symbols.staged,
    [StatusType.UpstreamCopied] = M.symbols.staged,
    [StatusType.UpstreamDeleted] = M.symbols.staged,
    [StatusType.UpstreamIgnored] = M.symbols.clean,
    [StatusType.UpstreamModified] = M.symbols.staged,
    [StatusType.UpstreamRenamed] = M.symbols.staged,
    [StatusType.UpstreamTypeChanged] = M.symbols.staged,
    [StatusType.UpstreamUnmodified] = M.symbols.clean,
    [StatusType.UpstreamUnmerged] = M.symbols.conflict,
    [StatusType.UpstreamUntracked] = M.symbols.clean,
    [StatusType.UpstreamExternal] = M.symbols.clean,
  }
end

function M.oil_vcs_status_hl(StatusType)
  return {
    [StatusType.Added] = M.hl.added,
    [StatusType.Copied] = M.hl.added,
    [StatusType.Deleted] = M.hl.deleted,
    [StatusType.Ignored] = M.hl.ignored,
    [StatusType.Modified] = M.hl.modified,
    [StatusType.Renamed] = M.hl.renamed,
    [StatusType.TypeChanged] = M.hl.modified,
    [StatusType.Unmodified] = "Normal",
    [StatusType.Unmerged] = M.hl.conflict,
    [StatusType.Untracked] = M.hl.untracked,
    [StatusType.External] = "Normal",

    [StatusType.UpstreamAdded] = M.hl.staged,
    [StatusType.UpstreamCopied] = M.hl.staged,
    [StatusType.UpstreamDeleted] = M.hl.staged,
    [StatusType.UpstreamIgnored] = "Normal",
    [StatusType.UpstreamModified] = M.hl.staged,
    [StatusType.UpstreamRenamed] = M.hl.staged,
    [StatusType.UpstreamTypeChanged] = M.hl.staged,
    [StatusType.UpstreamUnmodified] = "Normal",
    [StatusType.UpstreamUnmerged] = M.hl.conflict,
    [StatusType.UpstreamUntracked] = "Normal",
    [StatusType.UpstreamExternal] = "Normal",
  }
end

function M.legend()
  local s = M.symbols
  return {
    string.format("%s Modified   %s Added      %s Deleted", s.modified, s.added, s.deleted),
    string.format("%s Renamed    %s Untracked  %s Conflict", s.renamed, s.untracked, s.conflict),
    string.format("%s Staged     %s Ignored    %s Changes inside", s.staged, s.ignored, s.dir_dirty),
  }
end

function M.show_legend()
  local lines = M.legend()
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " Git status legend ",
    title_pos = "center",
    width = width + 2,
    height = #lines,
    row = math.max(0, vim.o.lines - #lines - 4),
    col = math.max(0, vim.o.columns - width - 6),
  })
end

vim.api.nvim_create_user_command("GitStatusLegend", M.show_legend, {
  desc = "Show Oil/nvim-tree Git status vocabulary",
})

return M
