local M = {}

local current_popup = nil

-- ── Helpers ──────────────────────────────────────────────

local function format_size(bytes)
  if bytes < 1024 then
    return string.format("%d B", bytes)
  elseif bytes < 1024 * 1024 then
    return string.format("%.1f KB", bytes / 1024)
  elseif bytes < 1024 * 1024 * 1024 then
    return string.format("%.2f MB", bytes / (1024 * 1024))
  else
    return string.format("%.2f GB", bytes / (1024 * 1024 * 1024))
  end
end

local function ts_sec(ts)
  if not ts then
    return nil
  end
  return type(ts) == "table" and ts.sec or ts
end

local function format_date(ts)
  local sec = ts_sec(ts)
  if not sec or sec == 0 then
    return "—"
  end
  return os.date("%Y-%m-%d %H:%M:%S", sec)
end

local function format_permissions(mode)
  if not mode then
    return "—"
  end
  local bits = { "---", "--x", "-w-", "-wx", "r--", "r-x", "rw-", "rwx" }
  local owner = bit.band(bit.rshift(mode, 6), 7) + 1
  local group = bit.band(bit.rshift(mode, 3), 7) + 1
  local other = bit.band(mode, 7) + 1
  return bits[owner] .. bits[group] .. bits[other] .. string.format("  (%o)", bit.band(mode, 0x1FF))
end

local function format_type(stat)
  local types = {
    file = "📄 Regular file",
    directory = "📁 Directory",
    link = "🔗 Symbolic link",
    fifo = "📮 FIFO/Pipe",
    socket = "🔌 Socket",
    char = "⌨️  Character device",
    block = "💾 Block device",
  }
  return types[stat.type] or stat.type
end

local function get_line_count(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if ok and lines then
    return tostring(#lines)
  end
  return "—"
end

local function get_git_status(path)
  local result = vim.fn.systemlist(
    "git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(path, ":h")) .. " status --porcelain -- " .. vim.fn.shellescape(path) .. " 2>/dev/null"
  )
  if vim.v.shell_error ~= 0 or #result == 0 then
    return "tracked (clean)"
  end
  local code = result[1]:sub(1, 2)
  local status_map = {
    ["??"] = "untracked",
    ["M "] = "modified (staged)",
    [" M"] = "modified (unstaged)",
    ["MM"] = "modified (staged + unstaged)",
    ["A "] = "added (staged)",
    ["D "] = "deleted",
    ["R "] = "renamed",
    ["C "] = "copied",
    ["UU"] = "conflict",
  }
  return status_map[code] or code
end

local function get_extension(path)
  local ext = vim.fn.fnamemodify(path, ":e")
  return ext ~= "" and ("." .. ext) or "—"
end

local function get_mime_type(path)
  local result = vim.fn.system("file --brief --mime-type " .. vim.fn.shellescape(path) .. " 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return "—"
  end
  return vim.trim(result)
end

-- ── Close / Toggle ───────────────────────────────────────

function M.close()
  if current_popup and vim.api.nvim_win_is_valid(current_popup.win) then
    vim.api.nvim_win_close(current_popup.win, true)
  end
  pcall(vim.api.nvim_del_augroup_by_name, "FileInfoAutoClose")
  current_popup = nil
end

---@param path? string
function M.toggle(path)
  path = path or vim.api.nvim_buf_get_name(0)
  if not path or path == "" then
    return
  end
  path = vim.fn.fnamemodify(path, ":p")

  if current_popup and current_popup.path == path then
    M.close()
    return
  end
  M.close()

  local stat = vim.uv.fs_stat(path)
  if not stat then
    return
  end

  local is_dir = stat.type == "directory"
  local is_file = stat.type == "file"

  local sections = {}

  -- Section 1: General
  local general = {
    { "Type", format_type(stat) },
    { "Path", path },
    { "Name", vim.fn.fnamemodify(path, ":t") },
    { "Directory", vim.fn.fnamemodify(path, ":h") },
  }
  if is_file then
    table.insert(general, { "Extension", get_extension(path) })
    table.insert(general, { "MIME", get_mime_type(path) })
  end
  table.insert(sections, { title = "GENERAL", rows = general })

  -- Section 2: Size & Content
  local size_content = {
    { "Size", is_dir and "—" or format_size(stat.size) },
  }
  if is_file then
    table.insert(size_content, { "Lines", get_line_count(path) })
  end
  if is_dir then
    local ok, entries = pcall(vim.fn.readdir, path)
    if ok and entries then
      table.insert(size_content, { "Entries", tostring(#entries) })
    end
  end
  table.insert(sections, { title = "SIZE", rows = size_content })

  -- Section 3: Timestamps
  table.insert(sections, {
    title = "TIMESTAMPS",
    rows = {
      { "Accessed", format_date(stat.atime) },
      { "Modified", format_date(stat.mtime) },
      { "Created", format_date(stat.birthtime) },
    },
  })

  -- Section 4: Permissions
  table.insert(sections, {
    title = "PERMISSIONS",
    rows = {
      { "Mode", format_permissions(stat.mode) },
      { "UID", tostring(stat.uid or "—") },
      { "GID", tostring(stat.gid or "—") },
    },
  })

  -- Section 5: Git
  if is_file then
    local git_st = get_git_status(path)
    table.insert(sections, {
      title = "GIT",
      rows = {
        { "Status", git_st },
      },
    })
  end

  -- ── Build lines ──
  local label_w = 12
  local lines = { "" }
  local section_meta = {} -- { line_idx, title }

  for si, section in ipairs(sections) do
    local title_line = "  " .. section.title
    table.insert(lines, title_line)
    table.insert(section_meta, { line = #lines, title = section.title })
    table.insert(lines, "  ─────────────────────────────────")
    for _, row in ipairs(section.rows) do
      local label, value = row[1], row[2]
      local pad = string.rep(" ", label_w - #label)
      table.insert(lines, "  " .. label .. pad .. value)
    end
    if si < #sections then
      table.insert(lines, "")
    end
  end
  table.insert(lines, "")

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width + 2, 90)
  local height = math.min(#lines, 30)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  -- ── Highlights ──
  vim.api.nvim_set_hl(0, "FileInfoTitle", { bold = true, fg = "#61afef", bg = "#2c323c" })
  vim.api.nvim_set_hl(0, "FileInfoLabel", { fg = "#7f848e", bg = "#282c34" })
  vim.api.nvim_set_hl(0, "FileInfoValue", { fg = "#e5e5e5", bg = "#282c34" })
  vim.api.nvim_set_hl(0, "FileInfoSep", { fg = "#3e4452", bg = "#282c34" })
  vim.api.nvim_set_hl(0, "FileInfoFloat", { bg = "#282c34" })
  vim.api.nvim_set_hl(0, "FileInfoFloatBorder", { fg = "#61afef", bg = "#282c34" })

  -- ── Extmarks ──
  local ns = vim.api.nvim_create_namespace "fileinfo"

  -- Section titles & separators
  for _, sm in ipairs(section_meta) do
    local li = sm.line
    vim.api.nvim_buf_set_extmark(buf, ns, li - 1, 2, {
      end_row = li - 1,
      end_col = 2 + #sm.title,
      hl_group = "FileInfoTitle",
    })
    -- Separator line (one below title)
    if li < #lines then
      local sep_text = lines[li + 1] or ""
      vim.api.nvim_buf_set_extmark(buf, ns, li, 0, {
        end_row = li,
        end_col = #sep_text,
        hl_group = "FileInfoSep",
      })
    end
  end

  -- Label & value per data row
  for _, section in ipairs(sections) do
    for _, _ in ipairs(section.rows) do
    end
  end
  -- Iterate all lines, find data rows (start with "  " + non-separator)
  for li = 1, #lines do
    local line = lines[li]
    if line:match "^  %S" and not line:match "^  ───" then
      -- Check if it's a section title
      local is_title = false
      for _, sm in ipairs(section_meta) do
        if sm.line == li then
          is_title = true
          break
        end
      end
      if not is_title then
        -- It's a data row: label ends at label_w, value starts after
        local content = line:sub(3) -- strip leading "  "
        local label = content:sub(1, label_w):match "^(%S+)"
        if label then
          vim.api.nvim_buf_set_extmark(buf, ns, li - 1, 2, {
            end_row = li - 1,
            end_col = 2 + #label,
            hl_group = "FileInfoLabel",
          })
          local value_start = 2 + label_w
          vim.api.nvim_buf_set_extmark(buf, ns, li - 1, value_start, {
            end_row = li - 1,
            end_col = #line,
            hl_group = "FileInfoValue",
          })
        end
      end
    end
  end

  -- ── Window ──
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = height,
    style = "minimal",
    border = "double",
    title = { { "  📄 File info  ", "FileInfoTitle" } },
    title_pos = "center",
    noautocmd = true,
    focusable = false,
  })
  vim.wo[win].winhighlight = "Normal:FileInfoFloat,FloatBorder:FileInfoFloatBorder"
  vim.wo[win].winblend = 0
  vim.wo[win].wrap = false

  current_popup = { win = win, path = path }

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("FileInfoAutoClose", {}),
    callback = function()
      M.close()
    end,
  })
end

M.show = M.toggle

return M
