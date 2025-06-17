local M = {}

local popup_winid = nil

local function is_valid_line(line)
  return type(line) == "number" and line >= 0 and line < vim.api.nvim_buf_line_count(0)
end

function M.close()
  if popup_winid and vim.api.nvim_win_is_valid(popup_winid) then
    vim.api.nvim_win_close(popup_winid, true)
    popup_winid = nil
    return true
  end
  return false
end

function M.show_range(start_line, end_line)
  if not (is_valid_line(start_line) and is_valid_line(end_line - 1)) or start_line >= end_line then
    vim.notify("Invalid line range", vim.log.levels.WARN)
    return
  end

  if M.close() then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  if #lines == 0 then
    return
  end

  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local filetype = vim.bo.filetype
  vim.bo[buf].filetype = filetype
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  local width = math.max(60, vim.fn.winwidth(0) - 20)
  local height = math.min(#lines, vim.fn.winheight(0) - 4)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = 2,
    style = "minimal",
    border = "rounded",
  }

  popup_winid = vim.api.nvim_open_win(buf, true, opts)

  vim.keymap.set("n", "q", function()
    M.close()
  end, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd({ "BufLeave", "QuitPre", "WinLeave" }, {
    buffer = 0,
    once = true,
    callback = function()
      M.close()
    end,
  })
end

return M
