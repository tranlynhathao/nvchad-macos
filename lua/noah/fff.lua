local M = {}

local root_markers = {
  ".git",
  "package.json",
  "deno.json",
  "deno.jsonc",
  "pyproject.toml",
  "Cargo.toml",
  "go.mod",
  "Makefile",
  "flake.nix",
}

local function current_anchor()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    return path
  end

  return vim.uv.cwd()
end

local function project_root()
  return vim.fs.root(current_anchor(), root_markers) or vim.uv.cwd()
end

local function picker()
  return require "fff"
end

local function sync_root()
  local root = project_root()
  picker().change_indexing_directory(root)
  return root
end

local function root_label(root)
  return vim.fs.basename(root) or root
end

local function merge_opts(defaults, opts)
  return vim.tbl_deep_extend("force", defaults, opts or {})
end

local function picker_title(icon, label, root)
  return string.format(" %s %s  %s ", icon, label, root_label(root))
end

local function clean_hl_spec(spec)
  local cleaned = {}
  for key, value in pairs(spec) do
    if value ~= nil then
      cleaned[key] = value
    end
  end

  return cleaned
end

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok then
    return hl
  end

  return {}
end

local function as_hex(value)
  if value == nil then
    return nil
  end

  if type(value) == "number" then
    return string.format("#%06x", value)
  end

  return value
end

local function pick_color(...)
  for index = 1, select("#", ...) do
    local value = select(index, ...)
    if value ~= nil then
      return as_hex(value)
    end
  end

  return nil
end

local function base46_palette()
  local ok, base46 = pcall(require, "base46")
  if not ok then
    return {}
  end

  local ok_palette, palette = pcall(base46.get_theme_tb, "base_30")
  if not ok_palette then
    return {}
  end

  return palette
end

local function ui_transparency()
  local ok, chadrc = pcall(require, "chadrc")
  if not ok then
    return false
  end

  return chadrc.base46 and chadrc.base46.transparency or false
end

local function apply_highlights()
  local normal_float = get_hl "NormalFloat"
  local float_border = get_hl "FloatBorder"
  local title = get_hl "Title"
  local question = get_hl "Question"
  local visual = get_hl "Visual"
  local cursorline = get_hl "CursorLine"
  local comment = get_hl "Comment"
  local number = get_hl "Number"
  local warning = get_hl "WarningMsg"
  local incsearch = get_hl "IncSearch"
  local git_add = get_hl "GitSignsAdd"
  local git_change = get_hl "GitSignsChange"
  local git_delete = get_hl "GitSignsDelete"
  local diag_info = get_hl "DiagnosticInfo"
  local diag_hint = get_hl "DiagnosticHint"
  local diag_ok = get_hl "DiagnosticOk"

  local selected_bg = visual.bg or cursorline.bg or normal_float.bg
  local selected_fg = visual.fg or normal_float.fg
  local active_bg = cursorline.bg or visual.bg or normal_float.bg
  local active_fg = title.fg or normal_float.fg

  vim.api.nvim_set_hl(
    0,
    "FFFNormal",
    clean_hl_spec {
      bg = normal_float.bg,
      fg = normal_float.fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFBorder",
    clean_hl_spec {
      bg = normal_float.bg,
      fg = float_border.fg or title.fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFTitle",
    clean_hl_spec {
      bg = normal_float.bg,
      fg = title.fg or float_border.fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFPrompt",
    clean_hl_spec {
      bg = normal_float.bg,
      fg = question.fg or title.fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFMatched",
    clean_hl_spec {
      bg = incsearch.bg,
      fg = incsearch.fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFDirectory",
    clean_hl_spec {
      fg = comment.fg,
      italic = comment.italic,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFScrollbar",
    clean_hl_spec {
      fg = comment.fg or float_border.fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFComboHeader",
    clean_hl_spec {
      fg = number.fg or title.fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSuggestionHeader",
    clean_hl_spec {
      fg = warning.fg or title.fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSelected",
    clean_hl_spec {
      bg = selected_bg,
      fg = selected_fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSelectedActive",
    clean_hl_spec {
      bg = active_bg,
      fg = active_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(0, "FFFGitStaged", clean_hl_spec { fg = git_add.fg or diag_ok.fg })
  vim.api.nvim_set_hl(0, "FFFGitModified", clean_hl_spec { fg = git_change.fg or warning.fg })
  vim.api.nvim_set_hl(0, "FFFGitDeleted", clean_hl_spec { fg = git_delete.fg or warning.fg })
  vim.api.nvim_set_hl(0, "FFFGitRenamed", clean_hl_spec { fg = diag_info.fg or title.fg })
  vim.api.nvim_set_hl(0, "FFFGitUntracked", clean_hl_spec { fg = git_add.fg or diag_hint.fg })
  vim.api.nvim_set_hl(0, "FFFGitIgnored", clean_hl_spec { fg = comment.fg })

  vim.api.nvim_set_hl(0, "FFFGitSignStaged", clean_hl_spec { fg = git_add.fg or diag_ok.fg })
  vim.api.nvim_set_hl(0, "FFFGitSignModified", clean_hl_spec { fg = git_change.fg or warning.fg })
  vim.api.nvim_set_hl(0, "FFFGitSignDeleted", clean_hl_spec { fg = git_delete.fg or warning.fg })
  vim.api.nvim_set_hl(0, "FFFGitSignRenamed", clean_hl_spec { fg = diag_info.fg or title.fg })
  vim.api.nvim_set_hl(0, "FFFGitSignUntracked", clean_hl_spec { fg = git_add.fg or diag_hint.fg })
  vim.api.nvim_set_hl(0, "FFFGitSignIgnored", clean_hl_spec { fg = comment.fg or float_border.fg })

  vim.api.nvim_set_hl(
    0,
    "FFFGitSignStagedSelected",
    clean_hl_spec {
      fg = git_add.fg or diag_ok.fg,
      bg = selected_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignModifiedSelected",
    clean_hl_spec {
      fg = git_change.fg or warning.fg,
      bg = selected_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignDeletedSelected",
    clean_hl_spec {
      fg = git_delete.fg or warning.fg,
      bg = selected_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignRenamedSelected",
    clean_hl_spec {
      fg = diag_info.fg or title.fg,
      bg = selected_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignUntrackedSelected",
    clean_hl_spec {
      fg = git_add.fg or diag_hint.fg,
      bg = selected_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignIgnoredSelected",
    clean_hl_spec {
      fg = comment.fg or float_border.fg,
      bg = selected_bg,
      bold = true,
    }
  )

  local palette = base46_palette()
  local transparent = ui_transparency()
  local search = get_hl "Search"

  local float_bg = transparent and "NONE" or pick_color(normal_float.bg, palette.one_bg, palette.statusline_bg, palette.black2, palette.black)
  local border_fg = pick_color(float_border.fg, palette.grey, palette.one_bg2, title.fg)
  local title_fg = pick_color(title.fg, palette.blue, palette.yellow, normal_float.fg)
  local prompt_fg = pick_color(question.fg, palette.yellow, title.fg, palette.green)
  local muted_fg = pick_color(comment.fg, palette.grey)
  local normal_fg = pick_color(normal_float.fg, title.fg, palette.grey)
  local passive_select_bg = pick_color(cursorline.bg, palette.one_bg, palette.statusline_bg, visual.bg)
  local active_select_bg = pick_color(visual.bg, palette.lightbg, palette.one_bg2, cursorline.bg)
  local matched_bg = pick_color(incsearch.bg, search.bg, palette.yellow)
  local matched_fg = pick_color(incsearch.fg, search.fg, palette.black)
  local directory_fg = pick_color(comment.fg, palette.grey, palette.one_bg2)
  local combo_fg = pick_color(number.fg, palette.yellow, title.fg)
  local suggestion_fg = pick_color(warning.fg, palette.green, palette.yellow)

  vim.api.nvim_set_hl(
    0,
    "FFFNormal",
    clean_hl_spec {
      bg = float_bg,
      fg = normal_fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFBorder",
    clean_hl_spec {
      bg = float_bg,
      fg = border_fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFTitle",
    clean_hl_spec {
      bg = float_bg,
      fg = title_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFPrompt",
    clean_hl_spec {
      bg = float_bg,
      fg = prompt_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFMatched",
    clean_hl_spec {
      bg = matched_bg,
      fg = matched_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFDirectory",
    clean_hl_spec {
      fg = directory_fg,
      italic = comment.italic ~= false,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFScrollbar",
    clean_hl_spec {
      fg = pick_color(comment.fg, border_fg, palette.one_bg2),
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFComboHeader",
    clean_hl_spec {
      fg = combo_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSuggestionHeader",
    clean_hl_spec {
      fg = suggestion_fg,
      bold = true,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSelected",
    clean_hl_spec {
      bg = passive_select_bg,
      fg = normal_fg,
    }
  )

  vim.api.nvim_set_hl(
    0,
    "FFFSelectedActive",
    clean_hl_spec {
      bg = active_select_bg,
      fg = pick_color(title.fg, palette.black, normal_fg),
      bold = true,
    }
  )

  vim.api.nvim_set_hl(0, "FFFGitIgnored", clean_hl_spec { fg = muted_fg })
  vim.api.nvim_set_hl(0, "FFFGitSignIgnored", clean_hl_spec { fg = muted_fg })
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignStagedSelected",
    clean_hl_spec {
      fg = pick_color(git_add.fg, diag_ok.fg, palette.green),
      bg = active_select_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignModifiedSelected",
    clean_hl_spec {
      fg = pick_color(git_change.fg, warning.fg, palette.yellow),
      bg = active_select_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignDeletedSelected",
    clean_hl_spec {
      fg = pick_color(git_delete.fg, warning.fg, palette.red),
      bg = active_select_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignRenamedSelected",
    clean_hl_spec {
      fg = pick_color(diag_info.fg, title.fg, palette.blue),
      bg = active_select_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignUntrackedSelected",
    clean_hl_spec {
      fg = pick_color(git_add.fg, diag_hint.fg, palette.green),
      bg = active_select_bg,
      bold = true,
    }
  )
  vim.api.nvim_set_hl(
    0,
    "FFFGitSignIgnoredSelected",
    clean_hl_spec {
      fg = muted_fg,
      bg = active_select_bg,
      bold = true,
    }
  )
end

local function visual_selection()
  local saved = vim.fn.getreg "s"
  vim.cmd [[noau normal! "sy]]
  local selection = vim.fn.getreg "s"
  vim.fn.setreg("s", saved)

  if selection == "" then
    return nil
  end

  return selection
end

function M.find_files(opts)
  -- Previous version:
  -- sync_root()
  -- picker().find_files(opts or {})
  local root = sync_root()
  picker().find_files(merge_opts({
    title = picker_title("󰱼", "Files", root),
    prompt = "   ",
  }, opts))
end

function M.live_grep(opts)
  -- Previous version:
  -- sync_root()
  -- picker().live_grep(opts or {})
  local root = sync_root()
  picker().live_grep(merge_opts({
    title = picker_title("󰺮", "Grep", root),
    prompt = " 󰍉  ",
    grep = {
      modes = { "plain", "regex", "fuzzy" },
    },
  }, opts))
end

function M.fuzzy_grep(opts)
  local root = sync_root()
  picker().live_grep(merge_opts({
    title = picker_title("󰱽", "Fuzzy Grep", root),
    prompt = " 󰱽  ",
    grep = {
      modes = { "fuzzy", "plain", "regex" },
    },
  }, opts))
end

function M.grep_cword()
  M.live_grep { query = vim.fn.expand "<cword>" }
end

function M.grep_visual_selection()
  local selection = visual_selection()
  if not selection then
    return
  end

  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  vim.schedule(function()
    M.live_grep { query = selection }
  end)
end

function M.scan_files()
  -- Previous version:
  -- sync_root()
  -- picker().scan_files()
  sync_root()
  picker().scan_files()
end

function M.refresh_git_status()
  -- Previous version:
  -- sync_root()
  -- picker().refresh_git_status()
  sync_root()
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
