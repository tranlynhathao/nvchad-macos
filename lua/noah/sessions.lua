local M = {}
local active_root
local configured = false
local directory = vim.fn.stdpath "state" .. "/project-sessions"

local function name(root) return vim.uri_encode(root, "rfc3986"):gsub("/", "%%2F") .. ".vim" end

local function has_file(root)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local path = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buftype == "" and path ~= "" and require("noah.project").root(path) == root then return true end
  end
  return false
end

function M.save(quiet)
  local root = require("noah.project").root()
  if not has_file(root) then
    if not quiet then vim.notify("Session: open a project file first", vim.log.levels.WARN) end
    return false
  end
  local options = vim.o.sessionoptions
  vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos"
  local ok, err = pcall(require("mini.sessions").write, name(root), { verbose = false })
  vim.o.sessionoptions = options
  if not ok then
    vim.notify("Session: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  active_root = root
  if not quiet then vim.notify("Session saved: " .. root) end
  return true
end

local function has_unsaved()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified then
      vim.notify("Session: save or discard edits before restoring (buffer " .. buf .. ")", vim.log.levels.WARN)
      return true
    end
  end
  return false
end

function M.load(root)
  root = root or require("noah.project").root()
  if vim.fn.filereadable(directory .. "/" .. name(root)) == 0 then
    vim.notify("No saved session for " .. root, vim.log.levels.WARN)
    return false
  end
  if has_unsaved() then return false end
  vim.schedule(function()
    if has_unsaved() then return end
    local ok, err = pcall(require("mini.sessions").read, name(root), { force = false })
    if not ok then
      vim.notify("Session: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    active_root = root
  end)
  return true
end

function M.pick()
  local roots = {}
  for _, path in ipairs(vim.fn.globpath(directory, "*.vim", false, true)) do
    roots[#roots + 1] = vim.uri_decode(vim.fs.basename(path):sub(1, -5))
  end
  table.sort(roots)
  if #roots == 0 then
    vim.notify "No project sessions yet; use :SessionSave"
    return
  end
  vim.ui.select(roots, { prompt = "Restore project session", format_item = function(root) return vim.fn.fnamemodify(root, ":~") end }, function(root)
    if root then M.load(root) end
  end)
end

function M.stop()
  active_root = nil
  vim.notify "Session autosave stopped; saved files are kept"
end

function M.setup()
  if configured then return end
  require("mini.sessions").setup { directory = directory, file = "", autoread = false, autowrite = false }
  local group = vim.api.nvim_create_augroup("NoahProjectSessions", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if active_root and active_root == require("noah.project").root() then M.save(true) end
    end,
  })
  configured = true
end

return M
