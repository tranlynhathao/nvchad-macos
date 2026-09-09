-- Telescope-based SSH host picker.
--
-- Reads ~/.ssh/config (and any `Include`-ed files) for `Host <name>` entries
-- (wildcards like `*` / `?` are skipped since they aren't concrete targets),
-- shows them via Telescope. Enter opens a new tab with `terminal ssh <host>`;
-- <C-v> opens the SSH session in a vertical split, <C-x> in a horizontal one.
--
-- Zero plugin dependency — uses Telescope which is already installed.

local M = {}

local function read_lines(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and lines or {}
end

local function parse_config(path, seen)
  seen = seen or {}
  path = vim.fn.fnamemodify(path, ":p")
  if seen[path] then return {} end
  seen[path] = true

  local hosts, base = {}, vim.fs.dirname(path)
  for _, line in ipairs(read_lines(path)) do
    local stripped = line:match "^%s*(.-)%s*$"
    if stripped ~= "" and not stripped:match "^#" then
      local include = stripped:match "^[Ii]nclude%s+(.+)$"
      local host = stripped:match "^[Hh]ost%s+(.+)$"
      if include then
        for _, pat in ipairs(vim.split(include, "%s+")) do
          local abs = pat:sub(1, 1) == "/" and pat or (base .. "/" .. pat)
          for _, matched in ipairs(vim.fn.glob(vim.fn.expand(abs), true, true)) do
            vim.list_extend(hosts, parse_config(matched, seen))
          end
        end
      elseif host then
        for _, name in ipairs(vim.split(host, "%s+")) do
          if name ~= "" and not name:match "[*?!]" then table.insert(hosts, name) end
        end
      end
    end
  end
  return hosts
end

local function unique(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

local function launch(host, cmd_prefix)
  vim.cmd(cmd_prefix .. " | terminal ssh " .. vim.fn.shellescape(host))
  vim.cmd "startinsert"
end

function M.pick()
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local state = require "telescope.actions.state"

  local hosts = unique(parse_config(vim.fn.expand "~/.ssh/config"))
  if #hosts == 0 then
    vim.notify("No SSH hosts found in ~/.ssh/config", vim.log.levels.WARN)
    return
  end

  local function pick(bufnr, opener)
    local entry = state.get_selected_entry()
    if not entry then return end
    actions.close(bufnr)
    launch(entry[1], opener)
  end

  pickers
    .new({}, {
      prompt_title = "SSH hosts",
      finder = finders.new_table { results = hosts },
      sorter = conf.generic_sorter {},
      attach_mappings = function(bufnr, map)
        actions.select_default:replace(function() pick(bufnr, "tabnew") end)
        map({ "i", "n" }, "<C-v>", function() pick(bufnr, "vnew") end)
        map({ "i", "n" }, "<C-x>", function() pick(bufnr, "new") end)
        return true
      end,
    })
    :find()
end

return M
