local M = {}

local popup_winid = nil

local function ClosePopup()
  if popup_winid and vim.api.nvim_win_is_valid(popup_winid) then
    vim.api.nvim_win_close(popup_winid, true)
    popup_winid = nil
    return true
  end
  return false
end

function M.show_range(start_line, end_line)
  if ClosePopup() then
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
    ClosePopup()
  end, { buffer = buf, nowait = true })

  vim.api.nvim_create_autocmd({ "BufLeave", "QuitPre" }, {
    once = true,
    callback = function()
      ClosePopup()
    end,
  })
end

function M.show_header()
  M.show_range(0, 15)
end

function M.show_fold_under_cursor()
  local lnum = vim.fn.line "."
  local fold_start = vim.fn.foldclosed(lnum)
  local fold_end = vim.fn.foldclosedend(lnum)
  if fold_start == -1 then
    return
  end
  M.show_range(fold_start - 1, fold_end)
end

function M.show_selection()
  local start_pos = vim.fn.getpos("'<")[2] - 1
  local end_pos = vim.fn.getpos("'>")[2]
  M.show_range(start_pos, end_pos)
end

return M
