local M = {}

local function target_bufnr()
  local winid = vim.g.statusline_winid
  if type(winid) == "number" and winid > 0 and vim.api.nvim_win_is_valid(winid) then
    return vim.api.nvim_win_get_buf(winid)
  end

  return vim.api.nvim_get_current_buf()
end

local function shorten(path)
  if not path or path == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(path, ":~")
end

local function build_lines(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  local lines = {
    "# LSP Info",
    "",
    "- Buffer: `" .. shorten(path) .. "`",
    "- Filetype: `" .. vim.bo[bufnr].filetype .. "`",
  }

  if #clients == 0 then
    table.insert(lines, "- Active clients: none")
    return lines
  end

  table.insert(lines, "- Active clients: " .. #clients)
  table.insert(lines, "")
  table.insert(lines, "## Clients")
  table.insert(lines, "")

  for _, client in ipairs(clients) do
    table.insert(lines, "- `" .. client.name .. "` (id " .. client.id .. ")")

    if type(client.config.root_dir) == "string" and client.config.root_dir ~= "" then
      table.insert(lines, "  root: `" .. shorten(client.config.root_dir) .. "`")
    end

    if client.config.cmd and #client.config.cmd > 0 then
      table.insert(lines, "  cmd: `" .. table.concat(client.config.cmd, " ") .. "`")
    end
  end

  return lines
end

function M.show()
  local bufnr = target_bufnr()
  local lines = build_lines(bufnr)

  if #vim.api.nvim_list_uis() == 0 then
    print(table.concat(lines, "\n"))
    return
  end

  vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "rounded",
    title = " LSP Info ",
    title_pos = "center",
    max_width = math.min(100, math.floor(vim.o.columns * 0.8)),
    max_height = math.min(20, math.floor(vim.o.lines * 0.5)),
    focusable = true,
  })
end

return M
