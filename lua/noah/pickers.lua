-- Suite of small custom Telescope pickers tailored to this config's workflow.
--
-- Every entry point below is safe to call before Telescope loads (returns
-- with a friendly notify), degrades gracefully when a required CLI is
-- missing, and never spawns synchronous shell commands on the render path.

local M = {}

local function tele()
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return nil
  end
  return {
    pickers = pickers,
    finders = require "telescope.finders",
    conf = require("telescope.config").values,
    actions = require "telescope.actions",
    state = require "telescope.actions.state",
    previewers = require "telescope.previewers",
  }
end

-- ── 1) Zoxide directory jump ─────────────────────────────────────────────
-- `zoxide query -l` is sorted by frecency. Enter -> cd + FFF file finder.
-- <C-x> -> Oil in that directory.
function M.zoxide()
  if vim.fn.executable "zoxide" ~= 1 then
    vim.notify("zoxide not found on PATH", vim.log.levels.ERROR)
    return
  end
  local t = tele()
  if not t then return end
  local lines = vim.fn.systemlist { "zoxide", "query", "-l" }
  if vim.v.shell_error ~= 0 or #lines == 0 then
    vim.notify("zoxide has no history yet", vim.log.levels.WARN)
    return
  end

  local function pick(bufnr, use_oil)
    local entry = t.state.get_selected_entry()
    if not entry then return end
    local dir = entry[1]
    t.actions.close(bufnr)
    vim.cmd("cd " .. vim.fn.fnameescape(dir))
    vim.notify("cd " .. dir)
    if use_oil then
      pcall(function() require("oil").open(dir) end)
    else
      vim.schedule(function() require("noah.fff").find_files { cwd = dir } end)
    end
  end

  t.pickers
    .new({}, {
      prompt_title = "Zoxide (cd + FFF)",
      finder = t.finders.new_table { results = lines },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr, map)
        t.actions.select_default:replace(function() pick(bufnr, false) end)
        map({ "i", "n" }, "<C-x>", function() pick(bufnr, true) end)
        return true
      end,
    })
    :find()
end

-- ── 2) Project root picker ───────────────────────────────────────────────
-- Filters zoxide list to dirs that contain .git. Fast switcher across
-- projects. Enter -> cd + FFF.
function M.projects()
  if vim.fn.executable "zoxide" ~= 1 then
    vim.notify("zoxide not found on PATH", vim.log.levels.ERROR)
    return
  end
  local t = tele()
  if not t then return end
  local all = vim.fn.systemlist { "zoxide", "query", "-l" }
  local roots = {}
  for _, d in ipairs(all) do
    if vim.uv.fs_stat(d .. "/.git") then table.insert(roots, d) end
  end
  if #roots == 0 then
    vim.notify("No git projects found in zoxide history", vim.log.levels.WARN)
    return
  end

  t.pickers
    .new({}, {
      prompt_title = "Projects (git roots from zoxide)",
      finder = t.finders.new_table { results = roots },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr)
        t.actions.select_default:replace(function()
          local dir = t.state.get_selected_entry()[1]
          t.actions.close(bufnr)
          vim.cmd("cd " .. vim.fn.fnameescape(dir))
          vim.notify("Project: " .. dir)
          vim.schedule(function() require("noah.fff").find_files { cwd = dir } end)
        end)
        return true
      end,
    })
    :find()
end

-- ── 2b) All git repos on disk ────────────────────────────────────────────
-- Scans $HOME + every mounted /Volumes/* drive for `.git` dirs via fd
-- (respects hidden, ignores nothing, --prune stops descent into matches,
-- max-depth caps runtime). Merges with zoxide-tracked roots for frecency.
-- Result cached until :AllGitRepos! is invoked (bang forces rescan).
local repo_cache = { list = nil, ts = 0 }
local REPO_TTL = 60 * 5 -- 5 minutes

local function scan_repos()
  if vim.fn.executable "fd" ~= 1 then
    vim.notify("fd not found on PATH", vim.log.levels.ERROR)
    return {}
  end
  local roots = { vim.env.HOME }
  if vim.uv.fs_stat "/Volumes" then table.insert(roots, "/Volumes") end
  local args = { "fd", "-H", "--type", "d", "--no-ignore", "--prune", "--max-depth", "5", "^\\.git$" }
  vim.list_extend(args, roots)
  local lines = vim.fn.systemlist(args)
  if vim.v.shell_error ~= 0 then
    vim.notify("fd failed (exit " .. vim.v.shell_error .. ")", vim.log.levels.ERROR)
    return {}
  end
  local out, seen = {}, {}
  for _, gitdir in ipairs(lines) do
    local root = vim.fs.dirname(gitdir:gsub("/$", ""))
    if root and not seen[root] then
      seen[root] = true
      table.insert(out, root)
    end
  end
  -- merge zoxide-tracked git roots (frecency order)
  if vim.fn.executable "zoxide" == 1 then
    for _, d in ipairs(vim.fn.systemlist { "zoxide", "query", "-l" }) do
      if not seen[d] and vim.uv.fs_stat(d .. "/.git") then
        seen[d] = true
        table.insert(out, 1, d) -- prepend (frecency wins)
      end
    end
  end
  return out
end

function M.git_repos_all(force)
  local now = os.time()
  if force or not repo_cache.list or (now - repo_cache.ts) > REPO_TTL then
    vim.notify("Scanning for .git dirs …", vim.log.levels.INFO)
    repo_cache.list = scan_repos()
    repo_cache.ts = now
  end
  local repos = repo_cache.list
  if not repos or #repos == 0 then
    vim.notify("No git repos found", vim.log.levels.WARN)
    return
  end
  local t = tele()
  if not t then return end
  t.pickers
    .new({}, {
      prompt_title = string.format("All git repos  (%d found, cached %ds)", #repos, math.min(now - repo_cache.ts, REPO_TTL)),
      finder = t.finders.new_table {
        results = repos,
        entry_maker = function(path)
          local display = path:gsub("^" .. vim.pesc(vim.env.HOME), "~")
          return { value = path, display = display, ordinal = display, path = path }
        end,
      },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr)
        t.actions.select_default:replace(function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          local dir = sel.value
          t.actions.close(bufnr)
          vim.cmd("cd " .. vim.fn.fnameescape(dir))
          vim.notify("cd " .. dir)
          vim.schedule(function() require("noah.fff").find_files { cwd = dir } end)
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command("AllGitRepos", function(o) M.git_repos_all(o.bang) end, {
  bang = true,
  desc = "Pick from ALL .git repos on $HOME + /Volumes (cached 5min; ! to rescan)",
})

-- ── 3) Makefile targets ──────────────────────────────────────────────────
-- Walks upward from cwd looking for a Makefile, parses target names,
-- filters internals. Enter -> `:make <target>` (uses cwindow autocmd added
-- earlier so quickfix opens).
local function find_makefile()
  local hit = vim.fs.find({ "Makefile", "makefile", "GNUmakefile" }, {
    path = vim.uv.cwd(),
    upward = true,
    type = "file",
  })[1]
  return hit
end

function M.makefile()
  local mk = find_makefile()
  if not mk then
    vim.notify("No Makefile found", vim.log.levels.WARN)
    return
  end
  local t = tele()
  if not t then return end
  local targets, seen = {}, {}
  for line in io.lines(mk) do
    local name = line:match "^([%w][%w._-]*)%s*:"
    if
      name
      and not seen[name]
      and not name:match "^%." -- skip .PHONY etc.
      and not name:match "^_" -- skip _internal
    then
      seen[name] = true
      table.insert(targets, name)
    end
  end
  if #targets == 0 then
    vim.notify("No targets found in " .. mk, vim.log.levels.WARN)
    return
  end

  t.pickers
    .new({}, {
      prompt_title = "Makefile targets  (" .. vim.fn.fnamemodify(mk, ":~:.") .. ")",
      finder = t.finders.new_table { results = targets },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr)
        t.actions.select_default:replace(function()
          local target = t.state.get_selected_entry()[1]
          t.actions.close(bufnr)
          vim.cmd("make " .. target)
        end)
        return true
      end,
    })
    :find()
end

-- ── 4) Colorscheme with live preview ─────────────────────────────────────
-- indent-blankline registers a ColorScheme autocmd that reads `IblChar`.
-- On preview hover, if the previewed theme doesn't define IblChar, ibl's
-- setup errors and crashes Telescope's set_selection. ibl's autocmd is
-- registered at load time (before us) so registration-order reordering
-- won't help. Monkey-patch ibl.highlights.setup with pcall for the
-- duration of the preview session, restore after 60s (well past the time
-- any interactive picker lives).
function M.colorscheme()
  local ok, ibl_hl = pcall(require, "ibl.highlights")
  if ok and ibl_hl and type(ibl_hl.setup) == "function" then
    local orig = ibl_hl.setup
    ibl_hl.setup = function(...) pcall(orig, ...) end
    vim.defer_fn(function() ibl_hl.setup = orig end, 60000)
  end
  vim.cmd "Telescope colorscheme enable_preview=true"
end

-- ── 5) Undo history ──────────────────────────────────────────────────────
-- Reads vim.fn.undotree().entries. Enter -> :undo N (jumps to that state).
-- Entries labelled with seq + "N ago" so you can pick before-and-after.
local function ago(t)
  local d = os.time() - t
  if d < 60 then return d .. "s ago" end
  if d < 3600 then return math.floor(d / 60) .. "m ago" end
  if d < 86400 then return math.floor(d / 3600) .. "h ago" end
  return math.floor(d / 86400) .. "d ago"
end

function M.undo()
  local t = tele()
  if not t then return end
  local tree = vim.fn.undotree()
  local entries = tree.entries
  if not entries or #entries == 0 then
    vim.notify("No undo history", vim.log.levels.WARN)
    return
  end
  local items = {}
  -- reverse-chronological, current state marked
  for i = #entries, 1, -1 do
    local e = entries[i]
    local marker = (e.seq == tree.seq_cur) and "* " or "  "
    table.insert(items, {
      seq = e.seq,
      display = string.format("%s#%-4d %-10s", marker, e.seq, ago(e.time)),
    })
  end

  t.pickers
    .new({}, {
      prompt_title = "Undo history  (seq_cur = " .. tree.seq_cur .. ")",
      finder = t.finders.new_table {
        results = items,
        entry_maker = function(item) return { value = item, display = item.display, ordinal = tostring(item.seq) } end,
      },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr)
        t.actions.select_default:replace(function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          t.actions.close(bufnr)
          vim.cmd("silent undo " .. sel.value.seq)
          vim.notify("undo -> seq " .. sel.value.seq)
        end)
        return true
      end,
    })
    :find()
end

-- ── 6) Backup restore picker ─────────────────────────────────────────────
-- Lists every file under ~/.config/nvim/.backups/**. Enter -> open backup
-- read-only in a vsplit. <C-d> -> :diffthis both sides against the live
-- file of the same basename in the current cwd if it exists.
local BACKUPS = vim.fn.expand "~/.config/nvim/.backups"

function M.backups()
  if vim.fn.isdirectory(BACKUPS) ~= 1 then
    vim.notify("No .backups directory", vim.log.levels.WARN)
    return
  end
  local t = tele()
  if not t then return end
  local files = vim.fn.systemlist { "find", BACKUPS, "-type", "f", "-not", "-path", "*/.*" }
  if #files == 0 then
    vim.notify("No backups yet", vim.log.levels.WARN)
    return
  end
  -- newest first
  table.sort(files, function(a, b)
    local sa = vim.uv.fs_stat(a)
    local sb = vim.uv.fs_stat(b)
    return (sa and sa.mtime.sec or 0) > (sb and sb.mtime.sec or 0)
  end)

  t.pickers
    .new({}, {
      prompt_title = "Backups  (~/.config/nvim/.backups/)",
      finder = t.finders.new_table {
        results = files,
        entry_maker = function(path)
          local rel = path:sub(#BACKUPS + 2)
          return { value = path, display = rel, ordinal = rel, path = path }
        end,
      },
      sorter = t.conf.generic_sorter {},
      previewer = t.conf.file_previewer {},
      attach_mappings = function(bufnr, map)
        t.actions.select_default:replace(function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          t.actions.close(bufnr)
          vim.cmd("vsplit " .. vim.fn.fnameescape(sel.value))
          vim.bo.readonly = true
          vim.bo.modifiable = false
        end)
        map({ "i", "n" }, "<C-d>", function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          t.actions.close(bufnr)
          local base = vim.fs.basename(sel.value)
          local live = vim.uv.cwd() .. "/" .. base
          if vim.uv.fs_stat(live) then
            vim.cmd("tabnew " .. vim.fn.fnameescape(live))
            vim.cmd "diffthis"
            vim.cmd("vsplit " .. vim.fn.fnameescape(sel.value))
            vim.cmd "diffthis"
          else
            vim.notify("No live file named " .. base .. " in cwd for diff", vim.log.levels.WARN)
          end
        end)
        return true
      end,
    })
    :find()
end

-- ── 7) Dadbod connection picker ──────────────────────────────────────────
-- Reads $XDG_DATA_HOME/nvim/db_ui/connections.json (dbui saved conns).
-- Enter -> :DB <url>. <C-y> -> yank URL to `+`. Reveals connection URLs;
-- if you store secrets inline (bad practice) they'll be visible.
local CONN_JSON = vim.fn.stdpath "data" .. "/db_ui/connections.json"

function M.dadbod_conn()
  if not vim.uv.fs_stat(CONN_JSON) then
    vim.notify("No DBUI connections at " .. CONN_JSON, vim.log.levels.WARN)
    return
  end
  local t = tele()
  if not t then return end
  local raw = table.concat(vim.fn.readfile(CONN_JSON), "\n")
  local ok, parsed = pcall(vim.json.decode, raw)
  if not ok or type(parsed) ~= "table" or #parsed == 0 then
    vim.notify("No connections parsed", vim.log.levels.WARN)
    return
  end
  local items = {}
  for _, c in ipairs(parsed) do
    table.insert(items, { name = c.name or "?", url = c.url or "" })
  end

  t.pickers
    .new({}, {
      prompt_title = "Dadbod connections",
      finder = t.finders.new_table {
        results = items,
        entry_maker = function(it)
          local display = string.format("%-24s %s", it.name, it.url)
          return { value = it, display = display, ordinal = it.name .. " " .. it.url }
        end,
      },
      sorter = t.conf.generic_sorter {},
      attach_mappings = function(bufnr, map)
        t.actions.select_default:replace(function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          t.actions.close(bufnr)
          vim.cmd("DB " .. vim.fn.fnameescape(sel.value.url))
        end)
        map({ "i", "n" }, "<C-y>", function()
          local sel = t.state.get_selected_entry()
          if not sel then return end
          vim.fn.setreg("+", sel.value.url)
          vim.notify("Yanked: " .. sel.value.url)
        end)
        return true
      end,
    })
    :find()
end

return M
