local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require "noah.utils"
local buf_map = utils.buf_map

-- ────────────────────────────────────────────────────────────────────────────
-- Large-file guard
--
-- On `BufReadPre` we peek at the file size and, above a threshold, mark the
-- buffer as "large" and turn off the most expensive per-buffer features
-- (syntax, treesitter, swap, undo). Prevents multi-second freezes when a
-- 500 KB+ log/blob/minified.js is opened - either directly (`nvim file.log`)
-- or as a side effect of :grep / telescope / `:args **/*`.
--
-- Threshold: 512 KiB. Raise if you routinely edit larger source files.
-- ────────────────────────────────────────────────────────────────────────────
local LARGE_FILE_BYTES = 512 * 1024

autocmd("BufReadPre", {
  group = augroup("LargeFileGuard", { clear = true }),
  desc = "Disable heavy per-buffer features for large files",
  callback = function(args)
    local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if not ok or not stat or stat.size <= LARGE_FILE_BYTES then return end
    vim.b[args.buf].large_file = true
    -- Editor-level knobs (syntax highlighter engine, undofile, swap).
    vim.opt_local.syntax = "off"
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.wrap = false
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.spell = false
    vim.opt_local.list = false
  end,
})

autocmd("FileType", {
  group = augroup("LargeFileTS", { clear = true }),
  desc = "Stop treesitter parser + LSP attach for large-file buffers",
  callback = function(args)
    if not vim.b[args.buf].large_file then return end
    pcall(vim.treesitter.stop, args.buf)
    -- Detach any LSP client that may have already attached.
    for _, client in ipairs(vim.lsp.get_clients { bufnr = args.buf }) do
      vim.lsp.buf_detach_client(args.buf, client.id)
    end
  end,
})

autocmd("LspAttach", {
  desc = "Display code action sign in gutter if available.",
  pattern = "*",
  group = augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/codeAction", args.buf) then return end

    -- Query only after the cursor has settled. CursorMoved generated an LSP
    -- request for every keystroke/movement and caused visible request churn.
    autocmd("CursorHold", {
      buffer = args.buf,
      group = augroup("CodeActionSign" .. args.buf, { clear = true }),
      callback = function() utils.code_action_listener(args.buf) end,
    })
  end,
})

autocmd("BufLeave", {
  desc = "Hide tabufline if only one buffer and one tab are open.",
  pattern = "*",
  group = augroup("TabuflineHide", { clear = true }),
  callback = function()
    if not vim.g.tabufline_enabled then return end

    vim.schedule(function()
      if #vim.t.bufs <= 1 and #vim.api.nvim_list_tabpages() <= 1 then
        vim.o.showtabline = 0
      else
        vim.o.showtabline = 2
      end
    end)
  end,
})

autocmd("Filetype", {
  desc = "Prevent <Tab>/<S-Tab> from switching specific buffers.",
  pattern = {
    "codecompanion",
    "lazy",
    "qf",
  },
  group = augroup("PreventBufferSwap", { clear = true }),
  callback = function(event)
    local lhs_list = { "<Tab>", "<S-Tab>" }
    buf_map(event.buf, "n", lhs_list, "<nop>")
  end,
})

autocmd("FileType", {
  desc = "Workaround for NvCheatsheet's zindex being higher than Mason's.",
  pattern = "nvcheatsheet",
  group = augroup("FixCheatsheetZindex", { clear = true }),
  callback = function() vim.api.nvim_win_set_config(0, { zindex = 44 }) end,
})

autocmd("FileType", {
  desc = "Workaround for NvMenu being below NvimTree.",
  pattern = "NvMenu",
  group = augroup("FixNvMenuZindex", { clear = true }),
  callback = function()
    if vim.bo.ft == "NvMenu" then vim.api.nvim_win_set_config(0, { zindex = 99 }) end
  end,
})

autocmd({ "BufEnter", "FileType" }, {
  desc = "Prevent auto-comment on new line.",
  pattern = "*",
  group = augroup("NoNewLineComment", { clear = true }),
  command = [[
    setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  ]],
})

autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Add support for .mdx files.",
  pattern = { "*.mdx" },
  group = augroup("MdxSupport", { clear = true }),
  callback = function() vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" }) end,
})

autocmd("VimResized", {
  desc = "Auto resize panes when resizing nvim window.",
  pattern = "*",
  group = augroup("VimAutoResize", { clear = true }),
  command = [[ tabdo wincmd = ]],
})

autocmd("VimLeavePre", {
  desc = "Close NvimTree before quitting nvim.",
  pattern = "*",
  group = augroup("NvimTreeCloseOnExit", { clear = true }),
  callback = function()
    if vim.bo.filetype == "NvimTree" then vim.api.nvim_buf_delete(0, { force = true }) end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight on yank.",
  group = augroup("HighlightOnYank", { clear = true }),
  callback = function() vim.highlight.on_yank { higroup = "YankVisual", timeout = 50, on_visual = true } end,
})

-- Auto-open quickfix / location list right after :grep, :make, :vimgrep,
-- :LspRestart-style commands populate them. `nested = true` lets triggered
-- autocmds inside the window setup (filetype detection etc.) fire.
autocmd("QuickFixCmdPost", {
  desc = "Auto-open quickfix window after :grep/:make.",
  group = augroup("AutoOpenQuickfix", { clear = true }),
  pattern = "[^l]*",
  nested = true,
  command = "cwindow",
})

autocmd("QuickFixCmdPost", {
  desc = "Auto-open location list after :lgrep/:lmake.",
  group = augroup("AutoOpenLoclist", { clear = true }),
  pattern = "l*",
  nested = true,
  command = "lwindow",
})

-- hlsearch auto-clear: keep hlsearch ON only while actively searching.
-- Toggles the option based on the last normal-mode key so search stays
-- highlighted through n/N/*/#/?// and clears the moment you move away.
do
  local search_keys = { n = true, N = true, ["*"] = true, ["#"] = true, ["?"] = true, ["/"] = true }
  vim.on_key(function(char)
    if vim.fn.mode() == "n" then
      local want = search_keys[vim.fn.keytrans(char)] == true
      if vim.opt.hlsearch:get() ~= want then vim.opt.hlsearch = want end
    end
  end)
end

local user_diagnostic = augroup("UserDiagnostic", { clear = true })

local diag_running = false
local function guarded(fn)
  return function(args)
    if diag_running then return end
    if args.buf and vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].buftype ~= "" then
      -- Skip UI/scratch buffers (notify, nui popups, quickfix, terminal, etc.)
      return
    end
    diag_running = true
    local ok, err = pcall(fn)
    diag_running = false
    if not ok then vim.schedule(function() vim.notify(tostring(err), vim.log.levels.ERROR) end) end
  end
end

autocmd("ModeChanged", {
  desc = "Strategically disable diagnostics to focus on editing tasks.",
  pattern = { "n:i", "n:v", "i:v" },
  group = user_diagnostic,
  callback = guarded(function() vim.diagnostic.enable(false) end),
})

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Disable diagnostics in node_modules.",
  pattern = "*/node_modules/*",
  group = user_diagnostic,
  callback = function(args) vim.diagnostic.enable(false, { bufnr = args.buf }) end,
})

autocmd("ModeChanged", {
  desc = "Enable diagnostics upon exiting insert mode to resume feedback.",
  pattern = "i:n",
  group = user_diagnostic,
  callback = guarded(function() vim.diagnostic.enable(true) end),
})

autocmd("BufWritePre", {
  desc = "Remove trailing whitespaces on save.",
  group = augroup("TrimWhitespaceOnSave", { clear = true }),
  command = [[ %s/\s\+$//e ]],
})

autocmd("FileType", {
  desc = "Define windows to close with 'q'",
  pattern = {
    "empty",
    "help",
    "startuptime",
    "qf",
    "query",
    "lspinfo",
    "man",
    "checkhealth",
    "nvcheatsheet",
    "codecompanion",
  },
  group = augroup("WinCloseOnQDefinition", { clear = true }),
  command = [[
    nnoremap <buffer><silent> q :close<CR>
    set nobuflisted
  ]],
})

autocmd("BufHidden", {
  desc = "Delete [No Name] buffers.",
  group = augroup("DeleteNoNameBuffer", { clear = true }),
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function() pcall(vim.api.nvim_buf_delete, event.buf, {}) end)
    end
  end,
})

local snip_running = false
autocmd("ModeChanged", {
  -- https://github.com/L3MON4D3/LuaSnip/issues/258
  desc = "Prevent weird snippet jumping behavior.",
  pattern = { "s:n", "i:*" },
  group = augroup("PreventSnippetJump", { clear = true }),
  callback = function(args)
    if snip_running then return end
    if args.buf and vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].buftype ~= "" then return end
    snip_running = true
    local ok, ls = pcall(require, "luasnip")
    if ok then
      local bufnr = vim.api.nvim_get_current_buf()
      if ls.session.current_nodes[bufnr] and not ls.session.jump_active then pcall(ls.unlink_current) end
    end
    snip_running = false
  end,
})

-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd({ "FocusGained", "BufEnter" }, {
  desc = "Automatically update changed file in nvim.",
  group = augroup("AutoupdateOnFileChange", { clear = true }),
  command = [[
    if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  ]],
})

-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd("FileChangedShellPost", {
  desc = "Show notification on file change.",
  group = augroup("NotifyOnFileChange", { clear = true }),
  command = [[
    echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  ]],
})

autocmd("User", {
  desc = "Enable line number in Telescope preview.",
  pattern = "TelescopePreviewerLoaded",
  group = augroup("CustomTelescopePreview", { clear = true }),
  callback = function() vim.opt_local.number = true end,
})

autocmd("TermOpen", {
  desc = "Prevent left click on terminal buffers from exiting insert mode.",
  pattern = "*",
  group = augroup("LeftMouseClickTerm", { clear = true }),
  callback = function(event)
    local mouse_actions = {
      "<LeftMouse>",
      "<2-LeftMouse>",
      "<3-LeftMouse>",
      "<4-LeftMouse>",
    }
    buf_map(event.buf, "t", mouse_actions, "<nop>")
  end,
})

autocmd("FileType", {
  desc = "Set custom conceal level in markdown files.",
  pattern = "markdown",
  callback = function()
    if vim.bo.ft == "markdown" then
      vim.opt.conceallevel = 2
    else
      vim.opt.conceallevel = 0
    end
  end,
})

autocmd("FileType", {
  desc = "Set custom conceal level in nvim.ai's chat window.",
  pattern = "chat-dialog",
  callback = function()
    if vim.bo.ft == "chat-dialog" then
      vim.schedule(function() vim.opt.conceallevel = 2 end)
    else
      vim.opt.conceallevel = 0
    end
  end,
})

autocmd({ "UIEnter", "ColorScheme" }, {
  desc = "Set background color for nvim to match terminal's background.",
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then return end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

autocmd("UILeave", {
  desc = "Reset background color to terminal default.",
  callback = function()
    io.write "\027]111\007"
    -- io.write "\027]11;#1e1e2e\007"
  end,
})

-- Floating UI polish (which-key + telescope highlight groups) lives in its
-- own module for clarity; see lua/noah/ui.lua.
require("noah.ui").setup()

-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
-- local vault_location = vim.fn.expand "~/Documents/ObsidianVault" .. "/**/*.md"
-- local obsidian_group = augroup("obsidian_cmds", { clear = true })
--
-- autocmd("BufRead", {
--   pattern = vault_location,
--   group = obsidian_group,
--   callback = function()
--     vim.cmd "ObsidianOpen"
--   end,
--   desc = "Opens the current buffer in Obsidian",
-- })

-- autocmd("BufWritePre", {
--   pattern = "*.nix",
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })

autocmd("FileType", {
  group = augroup("NoahMarkdownGx", { clear = true }),
  pattern = { "markdown", "quarto", "rmd" },
  callback = function(ev)
    vim.keymap.set("n", "gx", function() require("noah.markdown_open").open() end, {
      buffer = ev.buf,
      silent = true,
      desc = "Open URL under cursor (Markdown-aware)",
    })
  end,
})
