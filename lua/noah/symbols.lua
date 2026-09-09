-- Authoritative legend for auxiliary symbols shown around source code.
--
-- Each row maps a visible glyph to its actual owner (verified at runtime by
-- inspecting sign_getdefined() + nvim_get_namespaces() + extmarks). No entry
-- is inferred from a screenshot. Update this table when a new symbol
-- appears on screen you can't identify.
--
-- Toggle helpers below don't bind keys on their own — call them explicitly
-- from a mapping or `:SymbolLegend` command below documents them.

local M = {}

M.rows = {
  { section = "Git (gitsigns.nvim)" },
  { sym = "▎", hl = "GitSignsAdd", owner = "gitsigns", meaning = "Added line" },
  { sym = "▎", hl = "GitSignsChange", owner = "gitsigns", meaning = "Changed line" },
  { sym = "▁", hl = "GitSignsDelete", owner = "gitsigns", meaning = "Deleted line above" },
  { sym = "▎", hl = "GitSignsUntracked", owner = "gitsigns", meaning = "Untracked file marker" },
  { sym = "blame", hl = "GitSignsCurrentLineBlame", owner = "gitsigns", meaning = "Current-line blame text (author + date + summary)" },

  { section = "Diagnostics (vim.diagnostic + tiny-inline-diagnostic)" },
  { sym = "󰅚", hl = "DiagnosticSignError", owner = "vim.diagnostic", meaning = "Error" },
  { sym = "󰀪", hl = "DiagnosticSignWarn", owner = "vim.diagnostic", meaning = "Warning" },
  { sym = "󰋽", hl = "DiagnosticSignInfo", owner = "vim.diagnostic", meaning = "Info" },
  { sym = "󰌶", hl = "DiagnosticSignHint", owner = "vim.diagnostic", meaning = "Hint" },
  { sym = "inline text", hl = "", owner = "tiny-inline-diagnostic", meaning = "Diagnostic message rendered inline near cursor" },

  { section = "LSP" },
  { sym = "󰉁", hl = "CodeActionSignHl", owner = "noah/autocmds.lua (CodeActionSign)", meaning = "Code action available on this line" },
  {
    sym = "󰏪 label",
    hl = "LspInlayHint",
    owner = "nvim-lsp-endhints",
    meaning = "LSP parameter-name hint (label of the current call arg)",
  },

  { section = "DAP (nvim-dap-ui / nvim-dap-virtual-text)" },
  { sym = "●", hl = "DapBreakpoint", owner = "nvim-dap defaults", meaning = "Breakpoint" },
  { sym = "◆", hl = "DapBreakpointCondition", owner = "nvim-dap defaults", meaning = "Conditional breakpoint" },
  { sym = "▶", hl = "DapStopped", owner = "nvim-dap defaults", meaning = "Current execution line while stopped" },

  { section = "Folds" },
  { sym = "1..n", hl = "FoldColumn", owner = "foldcolumn (built-in) + nvim-ufo", meaning = "Fold level indicator" },

  { section = "Winbar" },
  { sym = "breadcrumb", hl = "DropBar*", owner = "dropbar.nvim", meaning = "Symbol path to the cursor position" },
}

-- Runtime toggles for the optional layers. Idempotent and cheap.
M.toggle = {}

function M.toggle.git_signs()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.toggle_signs() end
end

function M.toggle.git_blame()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.toggle_current_line_blame() end
end

function M.toggle.inlay_hints()
  local buf = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
end

function M.toggle.endhints()
  local ok, eh = pcall(require, "lsp-endhints")
  if ok and eh.toggle then eh.toggle() end
end

function M.toggle.diagnostics()
  local enabled = vim.diagnostic.is_enabled and vim.diagnostic.is_enabled() or true
  vim.diagnostic.enable(not enabled)
end

function M.toggle.breadcrumb() vim.o.winbar = (vim.o.winbar == "" and "%{%v:lua.dropbar()%}") or "" end

local function open_legend()
  local lines = { "  Neovim source-code symbols", "" }
  local hl_ranges = {}
  for _, r in ipairs(M.rows) do
    if r.section then
      table.insert(lines, "")
      table.insert(lines, "  " .. r.section)
      table.insert(hl_ranges, { row = #lines - 1, col_start = 2, col_end = 2 + #r.section, hl = "Title" })
    else
      local sym = r.sym or ""
      local pad = string.rep(" ", math.max(1, 12 - vim.fn.strdisplaywidth(sym)))
      local line = string.format("    %s%s %s", sym, pad, r.meaning)
      table.insert(lines, line)
      if r.hl and r.hl ~= "" then table.insert(hl_ranges, { row = #lines - 1, col_start = 4, col_end = 4 + #sym, hl = r.hl }) end
    end
  end
  table.insert(lines, "")
  table.insert(lines, "  q / <Esc> to close")

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  for _, r in ipairs(hl_ranges) do
    vim.api.nvim_buf_add_highlight(buf, 0, r.hl, r.row, r.col_start, r.col_end)
  end
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " Symbol legend ",
    title_pos = "center",
    width = width + 4,
    height = #lines,
    row = math.floor((vim.o.lines - #lines) / 2) - 2,
    col = math.floor((vim.o.columns - width - 4) / 2),
  })
  for _, k in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", k, function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, nowait = true, silent = true })
  end
end

vim.api.nvim_create_user_command("SymbolLegend", open_legend, {
  desc = "Show a legend of every auxiliary symbol shown around source code",
})

return M
