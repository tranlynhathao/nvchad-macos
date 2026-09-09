local M = {}

local function picker() return require "fff" end

local function sync_root(opts)
  local project = require "noah.project"
  local root = opts and opts.cwd and project.normalize(opts.cwd) or project.root()
  local ok, ready = pcall(function()
    local current = require("fff.conf").get().base_path
    if require("fff.core").is_file_picker_initialized() and current and project.normalize(current) == root then return true end
    return picker().change_indexing_directory(root)
  end)
  if not ok or not ready then
    if not ok then vim.notify("FFF: " .. tostring(ready), vim.log.levels.ERROR) end
    return nil
  end
  return root
end

local function root_label(root) return vim.fs.basename(root) or root end

local function merge_opts(defaults, opts) return vim.tbl_deep_extend("force", defaults, opts or {}) end

local function picker_title(icon, label, root) return string.format(" %s %s  %s ", icon, label, root_label(root)) end

local function apply_highlights()
  local hl = function(name, spec) vim.api.nvim_set_hl(0, name, spec) end
  local function resolve(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end

  -- Base surfaces — inherit from the float baseline so a theme swap sweeps
  -- across the picker without our intervention.
  hl("FFFNormal", { link = "NormalFloat" })
  hl("FFFBorder", { link = "FloatBorder" })
  hl("FFFTitle", { link = "Title" })
  hl("FFFPrompt", { link = "Question" })

  local search = resolve "Search"
  hl("FFFMatched", { fg = search.fg, bg = search.bg, bold = true, underline = true })
  hl("FFFGrepMatch", { fg = search.fg, bg = search.bg, bold = true, underline = true })

  -- Row hierarchy: an unfocused-but-selected row uses CursorLine (subtle),
  -- the actively-focused row uses Visual (bg-only — no fg override so the
  -- source text keeps its colour and matches survive on top).
  hl("FFFSelected", { link = "CursorLine" })
  hl("FFFSelectedActive", { bg = resolve("Visual").bg })

  -- Directory / paths / scrollbar / line-number: all secondary information.
  hl("FFFDirectory", { link = "Comment" })
  hl("FFFScrollbar", { link = "Comment" })
  hl("FFFGrepLineNumber", { link = "LineNr" })

  -- Metadata badges — align with the semantic they carry.
  hl("FFFComboHeader", { link = "Number" })
  hl("FFFSuggestionHeader", { link = "WarningMsg" })

  -- Git text (filename tint) — the spec sets git.status_text_color = false
  -- so these only affect the sign column icon. Link to GitSigns groups so
  -- the sign column matches the editor's git signs; Diagnostic* is a stable
  -- fallback for themes that don't ship GitSigns colors.
  hl("FFFGitStaged", { link = "GitSignsAdd" })
  hl("FFFGitModified", { link = "GitSignsChange" })
  hl("FFFGitDeleted", { link = "GitSignsDelete" })
  hl("FFFGitRenamed", { link = "DiagnosticInfo" })
  hl("FFFGitUntracked", { link = "GitSignsAdd" })
  hl("FFFGitIgnored", { link = "Comment" })

  hl("FFFGitSignStaged", { link = "GitSignsAdd" })
  hl("FFFGitSignModified", { link = "GitSignsChange" })
  hl("FFFGitSignDeleted", { link = "GitSignsDelete" })
  hl("FFFGitSignRenamed", { link = "DiagnosticInfo" })
  hl("FFFGitSignUntracked", { link = "GitSignsAdd" })
  hl("FFFGitSignIgnored", { link = "Comment" })

  -- The *Selected variants inherit the row background; composition needs a
  -- lookup because Visual.bg / CursorLine.bg differ per theme.
  local active_bg = resolve("Visual").bg or resolve("CursorLine").bg

  local sign_selected = function(target_link)
    local target = resolve(target_link)
    return { fg = target.fg, bg = active_bg, bold = true }
  end
  hl("FFFGitSignStagedSelected", sign_selected "GitSignsAdd")
  hl("FFFGitSignModifiedSelected", sign_selected "GitSignsChange")
  hl("FFFGitSignDeletedSelected", sign_selected "GitSignsDelete")
  hl("FFFGitSignRenamedSelected", sign_selected "DiagnosticInfo")
  hl("FFFGitSignUntrackedSelected", sign_selected "GitSignsAdd")
  hl("FFFGitSignIgnoredSelected", sign_selected "Comment")
end

local function visual_selection()
  local saved = vim.fn.getreg "s"
  vim.cmd [[noau normal! "sy]]
  local selection = vim.fn.getreg "s"
  vim.fn.setreg("s", saved)

  if selection == "" then return nil end

  return selection
end

function M.find_files(opts)
  local root = sync_root(opts)
  if not root then return end
  picker().find_files(merge_opts({
    cwd = root,
    title = picker_title("󰱼", "Files", root),
    prompt = "   ",
  }, opts))
end

function M.live_grep(opts)
  local root = sync_root(opts)
  if not root then return end
  picker().live_grep(merge_opts({
    cwd = root,
    title = picker_title("󰺮", "Grep", root),
    prompt = " 󰍉  ",
    grep = {
      modes = { "plain", "regex", "fuzzy" },
    },
  }, opts))
end

function M.fuzzy_grep(opts)
  local root = sync_root(opts)
  if not root then return end
  picker().live_grep(merge_opts({
    cwd = root,
    title = picker_title("󰱽", "Fuzzy Grep", root),
    prompt = " 󰱽  ",
    grep = {
      modes = { "fuzzy", "plain", "regex" },
    },
  }, opts))
end

function M.grep_cword() M.live_grep { query = vim.fn.expand "<cword>" } end

function M.grep_visual_selection()
  local selection = visual_selection()
  if not selection then return end

  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  vim.schedule(function() M.live_grep { query = selection } end)
end

function M.scan_files()
  if not sync_root() then return end
  picker().scan_files()
end

function M.refresh_git_status()
  if not sync_root() then return end
  picker().refresh_git_status()
end

function M.setup_highlights()
  local group = vim.api.nvim_create_augroup("NoahFffHighlights", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply_highlights,
  })

  apply_highlights()
end

return M
