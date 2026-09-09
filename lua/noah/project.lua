local M = {}

local markers = { "package.json", "deno.json", "deno.jsonc", "pyproject.toml", "Cargo.toml", "go.mod", "Makefile", "flake.nix" }

function M.normalize(path)
  path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
  return vim.uv.fs_realpath(path) or path
end

function M.anchor()
  local cwd, path = vim.fn.getcwd(), vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype == "oil" and package.loaded.oil then
    path = require("oil").get_current_dir() or cwd
  elseif vim.bo.filetype == "NvimTree" and package.loaded["nvim-tree.api"] then
    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    path = node and node.absolute_path or cwd
  elseif vim.bo.filetype == "minifiles" and package.loaded["mini.files"] then
    local state = require("mini.files").get_explorer_state()
    path = state and state.branch[state.depth_focus] or cwd
  elseif vim.bo.buftype ~= "" or path == "" or path:match "^%w+://" then
    path = cwd
  end
  return M.normalize(path)
end

function M.root(path)
  local anchor = path and M.normalize(path) or M.anchor()
  local root = vim.fs.root(anchor, ".git") or vim.fs.root(anchor, markers)
  if root then return M.normalize(root) end
  local cwd = M.normalize(vim.fn.getcwd())
  if anchor == cwd or anchor:sub(1, #cwd + 1) == cwd .. "/" then return cwd end
  return vim.fn.isdirectory(anchor) == 1 and anchor or vim.fs.dirname(anchor)
end

return M
