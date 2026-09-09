local M = {}

local TRAILING = "[)%]},.;:!?%*_`>]+$"
local URL = "[%w][%w+.%-]*://[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+"

local function strip_trailing(url) return (url:gsub(TRAILING, "")) end

local function find_at(text, pattern, col)
  local init = 1
  while true do
    local s, e, cap = text:find(pattern, init)
    if not s then return nil end
    if col >= s - 1 and col <= e - 1 then return cap or text:sub(s, e), s, e end
    init = e + 1
  end
end

function M.resolve()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  local inline = find_at(line, "%[[^%]]*%]%(([^)]+)%)", col)
  if inline then return strip_trailing(vim.trim(inline)) end

  local auto = find_at(line, "<(%w[%w+.%-]*://[^>%s]+)>", col)
  if auto then return vim.trim(auto) end

  local mailto = find_at(line, "<(mailto:[%w._%+-]+@[%w.-]+)>", col)
  if mailto then return mailto end

  local bare = find_at(line, URL, col)
  if bare then return strip_trailing(bare) end

  local www = find_at(line, "www%.[%w%-._~:/?#%[%]@!$&'()*+,;=%%]+", col)
  if www then return "https://" .. strip_trailing(www) end

  local mail = find_at(line, "[%w._%+-]+@[%w][%w.-]+%.[%w]+", col)
  if mail then return "mailto:" .. mail end

  return nil
end

function M.open()
  local url = M.resolve()
  if not url or url == "" then
    local cfile = vim.fn.expand "<cfile>"
    if cfile ~= "" and cfile:match "://" then
      url = strip_trailing(cfile)
    else
      vim.notify("No URL under cursor", vim.log.levels.INFO)
      return
    end
  end
  local cmd, err = vim.ui.open(url)
  if not cmd then vim.notify(("Unable to open URL: %s"):format(err or url), vim.log.levels.ERROR) end
end

return M
