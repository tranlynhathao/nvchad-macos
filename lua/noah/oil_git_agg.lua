-- Oil Git-status renderer — single visual channel.
--
-- Emits one virt_text extmark at EOL of every entry that has any Git state.
--   * Files:       own status set (usually 1 letter; MM porcelain shows S M).
--   * Directories: set-union aggregate of every descendant status class.
-- Per-letter highlight (each chunk carries its own NoahGit* group), so
-- `M ?` reads as modified + untracked at a glance.
--
-- oil-vcs-status is disabled so nothing draws Git symbols in the signcolumn
-- anymore; this module is the single authoritative Git UI for Oil.

local M = {}

local git_ui = require "noah.git_ui"
local NS = vim.api.nvim_create_namespace "noah_oil_git_agg"

-- Deterministic display order — matches user policy `! S M A R D ?`.
local ORDER = { "conflict", "staged", "modified", "added", "renamed", "deleted", "untracked", "ignored" }

-- Map XY (git status --porcelain=v1) to canonical status classes.
--   X = index (staged) status, Y = worktree status.
--   `M ` -> staged-only modification -> {staged}
--   ` M` -> worktree modified only    -> {modified}
--   `MM` -> both                      -> {staged, modified}
--   `A ` -> newly-added staged        -> {added}
--   ` D` -> worktree deletion         -> {deleted}
--   `D ` -> staged deletion           -> {deleted}
--   `R ` -> rename in index           -> {renamed}
--   `??` -> untracked                 -> {untracked}
--   `!!` -> ignored                   -> {ignored}
--   `UU`/`AA`/`DD`/`U*`/`*U` -> conflict
local function classify(x, y)
  local cls = {}
  if x == "U" or y == "U" or (x == "A" and y == "A") or (x == "D" and y == "D") then
    cls.conflict = true
    return cls
  end
  if x == "?" and y == "?" then
    cls.untracked = true
    return cls
  end
  if x == "!" and y == "!" then
    cls.ignored = true
    return cls
  end
  if x == "M" or x == "T" then
    cls.staged = true
  elseif x == "A" or x == "C" then
    cls.added = true
  elseif x == "D" then
    cls.deleted = true
  elseif x == "R" then
    cls.renamed = true
  end
  if y == "M" or y == "T" then
    cls.modified = true
  elseif y == "D" then
    cls.deleted = true
  end
  return cls
end

local function repo_root(path)
  local hit = vim.fs.find(".git", { path = path, upward = true })[1]
  return hit and vim.fs.dirname(hit) or nil
end

local function merge(dst, src)
  for k in pairs(src) do
    dst[k] = true
  end
end

---@return { files: table<string, table>, dirs: table<string, table> }
local function parse_porcelain(root, raw)
  local files, dirs = {}, {}
  local i = 1
  while i <= #raw do
    local nul = raw:find("\0", i, true) or (#raw + 1)
    local entry = raw:sub(i, nul - 1)
    i = nul + 1
    if #entry >= 4 then
      local x, y, path = entry:sub(1, 1), entry:sub(2, 2), entry:sub(4)
      if x == "R" or x == "C" then
        local n2 = raw:find("\0", i, true) or (#raw + 1)
        i = n2 + 1
      end
      local classes = classify(x, y)
      -- git reports untracked directories as `?? path/` (trailing slash);
      -- strip so the entry lookup matches Oil's slash-less entry.name.
      path = path:gsub("/$", "")
      local abs = root .. "/" .. path
      files[abs] = classes
      local dir = vim.fs.dirname(abs)
      while dir and #dir >= #root do
        local set = dirs[dir] or {}
        merge(set, classes)
        dirs[dir] = set
        if dir == root then break end
        dir = vim.fs.dirname(dir)
      end
    end
  end
  return { files = files, dirs = dirs }
end

local function set_to_chunks(set)
  if not set or not next(set) then return nil end
  local has_real = false
  for k in pairs(set) do
    if k ~= "ignored" then
      has_real = true
      break
    end
  end
  local chunks = {}
  for _, cls in ipairs(ORDER) do
    if set[cls] and not (cls == "ignored" and has_real) then
      if #chunks > 0 then table.insert(chunks, { " ", "Normal" }) end
      table.insert(chunks, { git_ui.symbols[cls], git_ui.hl[cls] })
    end
  end
  if #chunks == 0 then return nil end
  -- Leading spacer separates the badge from the filename.
  table.insert(chunks, 1, { "  ", "Normal" })
  return chunks
end

local function render(bufnr, snap)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
  local ok, oil = pcall(require, "oil")
  if not ok then return end
  local cwd = oil.get_current_dir(bufnr)
  if not cwd then return end
  cwd = cwd:gsub("/$", "")
  local n = vim.api.nvim_buf_line_count(bufnr)
  for line = 1, n do
    local ok_e, entry = pcall(oil.get_entry_on_line, bufnr, line)
    if ok_e and entry and entry.name ~= ".." then
      local abs = cwd .. "/" .. entry.name
      local set
      if entry.type == "directory" then
        -- Untracked/ignored directories arrive as a single porcelain entry
        -- (`?? path/`), so their status is stored in files[]. Prefer the
        -- descendant aggregate; fall back to file-level status.
        set = snap.dirs[abs] or snap.files[abs]
      else
        set = snap.files[abs]
      end
      local chunks = set_to_chunks(set)
      if chunks then
        pcall(vim.api.nvim_buf_set_extmark, bufnr, NS, line - 1, 0, {
          virt_text = chunks,
          virt_text_pos = "eol",
          hl_mode = "combine",
        })
      end
    end
  end
end

local pending = {}

function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].filetype ~= "oil" then return end
  local ok, oil = pcall(require, "oil")
  if not ok then return end
  local cwd = oil.get_current_dir(bufnr)
  if not cwd then return end
  local root = repo_root(cwd)
  if not root then
    vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
    return
  end
  if pending[bufnr] then return end
  pending[bufnr] = true
  vim.system(
    { "git", "-C", root, "status", "--porcelain=v1", "--ignored=matching", "-z" },
    { text = true },
    vim.schedule_wrap(function(res)
      pending[bufnr] = nil
      if res.code ~= 0 then return end
      local snap = parse_porcelain(root, res.stdout or "")
      render(bufnr, snap)
    end)
  )
end

local function schedule_refresh(bufnr)
  vim.defer_fn(function() M.refresh(bufnr) end, 120)
end

function M.setup()
  local aug = vim.api.nvim_create_augroup("NoahOilDirGitAgg", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = "oil",
    callback = function(ev) schedule_refresh(ev.buf) end,
  })
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    group = aug,
    pattern = "oil://*",
    callback = function(ev) schedule_refresh(ev.buf) end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = aug,
    pattern = { "OilEnter", "OilDirGitAggRefresh" },
    callback = function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].filetype == "oil" then schedule_refresh(b) end
      end
    end,
  })
end

return M
