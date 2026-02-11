local utils = require "noah.utils"
local map = utils.glb_map
local comments = require "utils.comments"
local popup = require "utils.popup"
local wk = require "which-key"
local ms = vim.lsp.protocol.Methods

P = vim.print

vim.g["quarto_is_r_mode"] = vim.g["quarto_is_r_mode"] or nil
vim.g["reticulate_running"] = vim.g["reticulate_running"] or false

-- #################################
-- Naviagtion word
-- w: move to next word
-- b: move to previous word
-- e: move to next end of word
-- ge or E: move to previous end of word
map("n", "E", "ge")
map("n", "yw", "yiw")

-- Movement
-- h: move to left
-- j: move down
-- k: move up
-- l: move to right

-- xp: move charater to the right
-- xhp: move character to the left

-- n>>: indent n lines
-- #################################

vim.api.nvim_create_user_command("PopupLines", function(opts)
  local args = vim.split(opts.args, " ")
  local start_line = tonumber(args[1]) and tonumber(args[1]) - 1 or -1
  local end_line = tonumber(args[2]) or -1
  popup.show_range(start_line, end_line)
end, {
  nargs = "+",
})

vim.keymap.set("n", "<leader>pp", function()
  local cur = vim.fn.line "."
  popup.show_range(cur - 1, cur + 10)
end, { desc = "Popup 10 lines from current line" })

vim.keymap.set("n", "<leader>ph", function()
  popup.show_range(0, 15)
end, { desc = "Popup file header" })

vim.keymap.set("n", "<leader>pf", function()
  local lnum = vim.fn.line "."
  local fold_start = vim.fn.foldclosed(lnum)
  local fold_end = vim.fn.foldclosedend(lnum)
  if fold_start ~= -1 then
    popup.show_range(fold_start - 1, fold_end)
  end
end, { desc = "Popup fold content" })

vim.keymap.set("v", "<leader>pv", function()
  local start_pos = vim.fn.getpos("'<")[2] - 1
  local end_pos = vim.fn.getpos("'>")[2]
  popup.show_range(start_pos, end_pos)
end, { desc = "Popup visual selection" })

-- DAP
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Continue debugger" })

map("n", "<leader>sn", ":Telescope scissors<CR>", { noremap = true, silent = true, desc = "Search Snippets" })

-- ~/.config/nvim/lua/mappings.lua

-- Keymaps for general functionality
-- Navigation & File
map("n", "<C-o>", ":lua OpenMarkdownLink()<CR>", { noremap = true, silent = true }) -- Open markdown links
map("n", "<leader>w", ":lua ToggleWrap()<CR>", { noremap = true, silent = true }) -- Toggle wrap for markdown
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree window" })
-- map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus NvimTree window" })

-- #################################
-- Slime Integration
-- #################################
map("v", "<C-c>", "<Plug>SlimeSend", { noremap = true, silent = true })

-- #################################
-- Commenting Functions
-- #################################
map("n", "<leader>ch", function()
  vim.cmd "normal! I// " -- Insert HTML comment (//) in Normal mode
end, { desc = "Insert HTML comment (//) in Normal mode" })

map("n", "<leader>cp", function()
  vim.cmd "normal! I//- " -- Insert Pug comment (//-) in Normal mode
end, { desc = "Insert Pug comment (//-) in Normal mode" })

map("v", "<leader>ch", function()
  comments.toggle_pug_comment "html" -- Toggle HTML comments (//) in Visual mode
end, { desc = "Toggle HTML comments (//) in Visual mode" })

map("v", "<leader>cp", function()
  comments.toggle_pug_comment "pug" -- Toggle Pug comments (//-) in Visual mode
end, { desc = "Toggle Pug comments (//-) in Visual mode" })

-- compress code
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Compress code (all supported formats)" })

-- Better escape using jk in insert and terminal mode
map("i", "jk", "<ESC>")
map("t", "jk", "<C-\\><C-n>")
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points (from configs/keymaps.lua)
vim.keymap.set("i", ",", ",<c-g>u", { silent = true, noremap = true })
vim.keymap.set("i", ".", ".<c-g>u", { silent = true, noremap = true })
vim.keymap.set("i", ";", ";<c-g>u", { silent = true, noremap = true })

-- Command mode mappings (from configs/keymaps.lua)
vim.keymap.set("c", "<C-a>", "<Home>", { silent = true, noremap = true })

vim.keymap.set("n", "<C-g>", function()
  vim.notify(vim.fn.expand "%:p", vim.log.levels.INFO, { title = "Current File" })
end, { desc = "Show absolute file path" })

-- Resize window
map("n", "<C-w><left>", "<C-w><")
map("n", "<C-w><right>", "<C-w>>")
map("n", "<C-w><up>", "<C-w>+")
map("n", "<C-w><down>", "<C-w>-")

-- Select all
-- map("n", "<C-a>", "<cmd>normal! ggVG<CR>", { desc = "Select all" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Filthy emacs(ish) bindings
map("n", "<C-z>", "<C-d>zz")
map("n", "<C-p>", "<C-u>zz")

-- Move line up and down
map("n", "<ESC>j", ":m .+1<CR>==")
map("n", "<ESC>k", ":m .-2<CR>==")
map("i", "<ESC>j", "<ESC>:m .+1<CR>==gi")
map("i", "<ESC>k", "<ESC>:m .-2<CR>==gi")

-- Move section up and down
map("v", "<ESC>j", ":move '>+1<CR>gv")
map("v", "<ESC>k", ":move '<-2<CR>gv")

-- ## Command: <ESC>nj/k (n is character)
local function move_line_or_block(direction)
  local n = tonumber(vim.fn.input("Move by how many lines? ", "1")) or 1
  if n < 1 then
    n = 1
  end
  local line = vim.fn.line "."

  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    if direction == "down" then
      vim.cmd(string.format(":'<,'>move '>+%d", n))
    elseif direction == "up" then
      vim.cmd(string.format(":'<,'>move '<-%d", n))
    end
  else
    if direction == "down" then
      vim.cmd(string.format(":move %d", line + n))
    elseif direction == "up" then
      vim.cmd(string.format(":move %d", line - n - 1))
    end
  end
end

-- local function map(mode, lhs, rhs, opts)
--   opts = opts or {}
--   vim.keymap.set(mode, lhs, rhs, opts)
-- end

map("n", "<ESC>nj", function()
  move_line_or_block "down"
end, { silent = true })
map("n", "<ESC>nk", function()
  move_line_or_block "up"
end, { silent = true })

map("v", "<ESC>nj", function()
  move_line_or_block "down"
end, { silent = true })
map("v", "<ESC>nk", function()
  move_line_or_block "up"
end, { silent = true })

-- OR

-- ## Command: n<ESC>j/k (n is a number) -- Ex: 5<ESC>j/k
-- local function move_line_or_block(direction, count)
--   count = count or 1
--
--   if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
--     if direction == "down" then
--       vim.cmd(string.format(":'<,'>move '>+%d", count))
--     elseif direction == "up" then
--       vim.cmd(string.format(":'<,'>move '<-%d", count))
--     end
--   else
--     if direction == "down" then
--       vim.cmd(string.format(":move .+%d", count))
--     elseif direction == "up" then
--       vim.cmd(string.format(":move .-%d", count))
--     end
--   end
-- end
--
-- local function map(mode, lhs, rhs, opts)
--   opts = opts or {}
--   vim.keymap.set(mode, lhs, rhs, opts)
-- end
--
-- -- Keymap support `n` lines
-- map("n", "<ESC>j", function()
--   local count = tonumber(vim.v.count) or 1
--   move_line_or_block("down", count)
-- end, { silent = true })
--
-- map("n", "<ESC>k", function()
--   local count = tonumber(vim.v.count) or 1
--   move_line_or_block("up", count)
-- end, { silent = true })
--
-- -- Visual mode support n lines
-- map("v", "<ESC>j", function()
--   local count = tonumber(vim.v.count) or 1
--   move_line_or_block("down", count)
-- end, { silent = true })
--
-- map("v", "<ESC>k", function()
--   local count = tonumber(vim.v.count) or 1
--   move_line_or_block("up", count)
-- end, { silent = true })

-- Redo
map("n", "U", "<C-r>")

-- Mapping to make text bold/italic/underline
map("v", "<leader>b", 'c**<C-r>"**<Esc>', { desc = "Bold" })
map("v", "<leader>i", 'c*<C-r>"*<Esc>', { desc = "Italic" })
map("v", "<leader>u", 's/<C-R>"<u>\\O</u>/', { desc = "Underline" })

-- Insert Codeblock with languages
vim.keymap.set("n", "<leader>a", function()
  local lines = {
    "```python",
    "",
    "```",
  }
  vim.api.nvim_put(lines, "l", true, true)
  vim.cmd "normal! k"
end, { desc = "Insert python code block" })

vim.keymap.set("n", "<leader>j", function()
  local lines = {
    "```javascript",
    "",
    "```",
  }
  vim.api.nvim_put(lines, "l", true, true)
  vim.cmd "normal! k"
end, { desc = "Insert javascript code block" })

vim.keymap.set("x", "<leader>`", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  vim.fn.append(end_line, "```")
  vim.fn.append(start_line - 1, "```")
end, { desc = "Wrap selection with plain code block" })

-- Normal mode: Insert code block with language prompt
vim.keymap.set("n", "<leader>~", function()
  local lang = vim.fn.input "Language: "
  if lang == "" then
    lang = "plaintext"
  end
  local lines = {
    "```" .. lang,
    "",
    "```",
  }
  vim.api.nvim_put(lines, "l", true, true)
  vim.cmd "normal! k"
end, { desc = "Insert code block with language" })

-- Visual mode: Wrap selected lines with code block
vim.keymap.set("x", "<leader>~", function()
  local lang = vim.fn.input "Language: "
  if lang == "" then
    lang = "plaintext"
  end

  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  vim.fn.append(end_line, "```")
  vim.fn.append(start_line - 1, "```" .. lang)
end, { desc = "Wrap selection in code block with language" })

map("i", "<C-c>", "<ESC>") -- Remap <C-c> into <ESC> for convenience

-- Build project with a command
local make_cmd = "make"
map("n", "<leader>m", "", {
  noremap = true,
  silent = true,
  callback = function()
    local cmd = vim.fn.input("Build command: ", make_cmd)
    local last_makeprg = vim.opt.makeprg:get()

    vim.opt.makeprg = cmd:match "%S+"
    vim.cmd((cmd:gsub("%S+", "make", 7)))

    vim.opt.makeprg = last_makeprg
    make_cmd = cmd
  end,
})

-- Custom configuration
map("n", "<leader>l", ":lua InsertBackLink()<CR>", { desc = "Insert backlink" })

-- Open Lazygit
map("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open Lazygit" })

map("n", "z-", "z^") -- Remap z^ into z- for convenience
map("n", "g-", "g;") -- Remap g; into g- for convenience
map("n", ";", ":", { desc = "General enter CMD mode" })

map("i", "jk", "<ESC>", { desc = "General exit insert mode" })

map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "General save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General copy file content" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General clear search highlights" })
map("n", "<leader>cs", "<cmd><CR>", { desc = "General clear statusline" })
map("n", "<leader><F10>", "<cmd>stop<CR>", { desc = "Genaral stop NVIM" })

map("n", "<leader>cm", "<cmd>mes clear<CR>", { desc = "General clear messages" })
map("n", "<leader>cn", function()
  require("notify").dismiss { silent = true, pending = true }
end, { desc = "Clear notifications" })

-- https://github.com/neovim/neovim/issues/2054
map("i", "<A-BS>", "<C-w>", { desc = "General remove word" })

map("n", "<leader>ol", function()
  vim.ui.open(vim.fn.expand "%:p:h")
end, { desc = "General open file location in file explorer" })

-- Yank/Paste/Delete/Cut improvements
-- https://github.com/neovim/neovim/issues/29718
map({ "n", "v" }, "y", '"6ygv<Esc>', { desc = "Yank selection" })
map("n", "Y", '"6y$', { desc = "Yank up to EOL" })
map({ "n", "v" }, "yy", '"6yy', { desc = "Yank line" })
map({ "n", "v" }, "p", '"6p', { desc = "Paste below" })
map({ "n", "v" }, "P", '"6P', { desc = "Paste above" })
map("n", "x", '"6x', { desc = "Delete character" })
-- map("n", "dd", '"6dd', { desc = "Delete line" })
-- map("v", "d", '"6d', { desc = "Delete selection" })
map("n", "cc", '"6cc', { desc = "Change line" })
map("v", "c", '"6c', { desc = "Change selection" })
-- map("n", "yw", '"6yiw', { desc = "Yank inner word to custom register" })
-- map("n", "<C-yw>", '"+yiw', { desc = "Yank word to system clipboard" })

-- Use register `"0` for default yank register
map("v", "d", '"_d"0p', { desc = "Delete selection and store in default yank register" })
-- map("n", "dd", '"_dd"0p', { desc = "Delete line and store in default yank register" })

-- Yank/Paste/Delete/Cut improvements for clipboard
map({ "n", "v" }, "<C-y>", '"+ygv<Esc>', { desc = "Yank selection into system clipboard" })
map("n", "<c-y>", '"+y$', { desc = "yank up to eol into system clipboard" })
map({ "n", "v" }, "<C-yy>", '"+yy', { desc = "Yank line into system clipboard" })
map({ "n", "v" }, "<C-p>", '"+p', { desc = "Paste below from system clipboard" })
map({ "n", "v" }, "<C-P>", '"+P', { desc = "Paste above from system clipboard" })
map("n", "<C-x>", '"6x', { desc = "Delete character (x register)" })
map("n", "<C-D>", "dd", { desc = "Delete line (x register)" })
map("v", "<C-d>", "d", { desc = "Delete selection (x register)" })
map("n", "<C-C>", "cc", { desc = "Change line (x register)" })
map("v", "<C-c>", "c", { desc = "Change selection (x register)" })

map("v", "d", '"6d', { desc = "Delete selection and store in register 6" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
map("n", "j", 'v:count || mode(7)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("n", "k", 'v:count || mode(7)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Up>", 'v:count || mode(7)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("n", "<Down>", 'v:count || mode(7)[0:1] == "no" ? "j" : "gj"', { expr = true })

-- Buffer motions
-- map("i", "<C-b>", "<ESC>^i", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })
map("i", "<C-h>", "<Left>", { desc = "Go to left" })
map("i", "<C-l>", "<Right>", { desc = "Go to right" })
map("i", "<C-j>", "<Down>", { desc = "Go down" })
map("i", "<C-k>", "<Up>", { desc = "Go up" })
map("n", "<leader>gm", "<cmd>exe 'normal! ' . line('$')/8 . 'G'<CR>", { desc = "Go to middle of the file" })

-- Move lines up/down
map("n", "<A-Down>", ":m .+7<CR>", { desc = "Move line down" })
map("n", "<A-j>", ":m .+7<CR>", { desc = "Move line down" })
map("n", "<A-Up>", ":m .4<CR>", { desc = "Move line up" })
map("n", "<A-k>", ":m .4<CR>", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc>:m .+7<CR>==gi", { desc = "Move line down" })
map("i", "<A-j>", "<Esc>:m .+7<CR>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc>:m .4<CR>==gi", { desc = "Move line up" })
map("i", "<A-k>", "<Esc>:m .4<CR>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+7<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-j>", ":m '>+7<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-Up>", ":m '<4<CR>gv=gv", { desc = "Move line up" })
map("v", "<A-k>", ":m '<4<CR>gv=gv", { desc = "Move line up" })

-- Switch buffers
map("n", "<C-h>", "<C-w>h", { desc = "Buffer switch left" })
map("n", "<C-l>", "<C-w>l", { desc = "Buffer switch right" })
map("n", "<C-j>", "<C-w>j", { desc = "Buffer switch down" })
map("n", "<C-k>", "<C-w>k", { desc = "Buffer switch up" })

-- Quick resize pane
map("n", "<C-A-h>", "11<C-w>>", { desc = "Window increase width by 5" })
map("n", "<C-A-l>", "11<C-w><", { desc = "Window decrease width by 5" })
map("n", "<C-A-k>", "11<C-w>+", { desc = "Window increase height by 5" })
map("n", "<C-A-j>", "11<C-w>-", { desc = "Window decrease height by 5" })

vim.keymap.set("n", "<leader>raa", function()
  local old = vim.fn.input "Replace: "
  if old == "" then
    return
  end
  local new = vim.fn.input "With: "
  if new == "" then
    return
  end

  vim.cmd("vimgrep /" .. old .. "/gj **/*")

  vim.cmd "copen"

  vim.cmd([[cfdo %s/]] .. old .. [[/]] .. new .. [[/g | update]])

  print("✓ Replaced '" .. old .. "' → '" .. new .. "' in all files.")
end, { desc = "Replace string in all files of project" })

-- -- Replace text
-- map("n", "s", ":s//g<left><left>") -- Line
-- map("n", "S", ":%s//g<left><left>") -- All
-- map("v", "s", ":s//g<left><left>") -- Selection

-- #############################################
-- Upgrade replace function to use input prompts
-- #############################################

-- local function get_search_replace_flags()
--   local search = vim.fn.input("Search: ")
--   if search == "" then
--     vim.notify("Search pattern is empty!", vim.log.levels.WARN)
--     return
--   end
--   local replace = vim.fn.input("Replace with: ")
--   local ignore_case = vim.fn.input("Ignore case? (y/n): ")
--   local flag = (ignore_case:lower() == "y") and "gi" or "g"
--   return search, replace, flag
-- end
--
-- function M.ReplaceCurrentLine()
--   local search, replace, flag = get_search_replace_flags()
--   if not search then return end
--
--   local ok, err = pcall(function()
--     vim.cmd(string.format("s/%s/%s/%s", search, replace, flag))
--   end)
--
--   if not ok then
--     vim.notify("Error replacing: " .. err, vim.log.levels.ERROR)
--   end
-- end
--
-- function M.ReplaceInFile()
--   local search, replace, flag = get_search_replace_flags()
--   if not search then return end
--
--   local ok, err = pcall(function()
--     vim.cmd(string.format("%%s/%s/%s/%s", search, replace, flag))
--   end)
--
--   if not ok then
--     vim.notify("Error replacing: " .. err, vim.log.levels.ERROR)
--   end
-- end

-- function M.ReplaceCurrentLine()
--   local search = vim.fn.input "Search: "
--   if search == "" then
--     print "Search is empty"
--     return
--   end
--   local replace = vim.fn.input "Replace: "
--   vim.cmd(string.format("s/%s/%s/g", search, replace))
-- end
--
-- function M.ReplaceInFile()
--   local search = vim.fn.input "Search: "
--   if search == "" then
--     print "Search is empty"
--     return
--   end
--   local replace = vim.fn.input "Replace: "
--   vim.cmd(string.format("%%s/%s/%s/g", search, replace))
-- end
--
-- function M.ReplaceInSelection()
--   local search = vim.fn.input "Search: "
--   if search == "" then
--     vim.notify("Search pattern is empty!", vim.log.levels.WARN)
--     return
--   end
--
--   local replace = vim.fn.input "Replace with: "
--   local ignore_case = vim.fn.input "Ignore case? (y/n): "
--   local flag = (ignore_case:lower() == "y") and "gi" or "g"
--
--   local v_start = vim.fn.getpos("v")[2]
--   local v_end = vim.fn.getcurpos()[2]
--
--   local start_line = math.min(v_start, v_end) - 1
--   local end_line = math.max(v_start, v_end)
--
--   local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
--   local text = table.concat(lines, "\n")
--
--   if not text:find(search) then
--     vim.notify("Pattern '" .. search .. "' not found in selection!", vim.log.levels.INFO)
--     return
--   end
--
--   local ok, err = pcall(function()
--     vim.cmd(string.format("%d,%ds/%s/%s/%s", start_line + 1, end_line, search, replace, flag))
--   end)
--
--   if not ok then
--     vim.notify("Error replacing: " .. err, vim.log.levels.ERROR)
--   end
-- end
--
-- -- Register this table as a pseudo-module to avoid luacheck warning
-- package.loaded.replace_text = M
--
-- -- Key mappings
-- map("n", "<leader>r", function()
--   require("replace_text").ReplaceCurrentLine()
-- end, { desc = "Replace text on line" })
-- map("n", "<leader>R", function()
--   require("replace_text").ReplaceInFile()
-- end, { desc = "Replace text on file" })
-- map("v", "<leader>r", function()
--   require("replace_text").ReplaceInSelection()
-- end, { desc = "Replace text on selection" })

local M = {}

local function escape_lua_pattern(s)
  return s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
end

local function replace_in_range(start_line, end_line, search, replace, use_regex)
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

  for i, line in ipairs(lines) do
    if use_regex then
      local ok, new_line = pcall(function()
        return line:gsub(search, replace)
      end)
      if ok then
        lines[i] = new_line
      else
        vim.notify("Invalid Lua pattern: " .. search, vim.log.levels.ERROR)
        return
      end
    else
      local plain_search = escape_lua_pattern(search)
      lines[i] = line:gsub(plain_search, replace)
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
end

function M.ReplaceCurrentLine()
  local search = vim.fn.input "Search: "
  if search == "" then
    vim.notify("Search pattern is empty!", vim.log.levels.WARN)
    return
  end
  local replace = vim.fn.input "Replace with: "
  local use_regex = vim.fn.input("Use regex? (y/n): "):lower() == "y"

  local line_nr = vim.fn.line "." - 1
  replace_in_range(line_nr, line_nr + 1, search, replace, use_regex)
end

function M.ReplaceInFile()
  local search = vim.fn.input "Search: "
  if search == "" then
    vim.notify("Search pattern is empty!", vim.log.levels.WARN)
    return
  end
  local replace = vim.fn.input "Replace with: "
  local use_regex = vim.fn.input("Use regex? (y/n): "):lower() == "y"

  local total_lines = vim.api.nvim_buf_line_count(0)
  replace_in_range(0, total_lines, search, replace, use_regex)
  vim.notify("Replaced in entire file.", vim.log.levels.INFO)
end

function M.ReplaceInSelection()
  local search = vim.fn.input "Search: "
  if search == "" then
    vim.notify("Search pattern is empty!", vim.log.levels.WARN)
    return
  end
  local replace = vim.fn.input "Replace with: "
  local use_regex = vim.fn.input("Use regex? (y/n): "):lower() == "y"

  local v_start = vim.fn.getpos("v")[2]
  local v_end = vim.fn.getcurpos()[2]
  local start_line = math.min(v_start, v_end) - 1
  local end_line = math.max(v_start, v_end)

  replace_in_range(start_line, end_line, search, replace, use_regex)
  vim.notify(string.format("Replaced in lines %d-%d", start_line + 1, end_line), vim.log.levels.INFO)
end

package.loaded.replace_text = M

local map_replace = vim.keymap.set
map_replace("n", "<leader>r", function()
  require("replace_text").ReplaceCurrentLine()
end, { desc = "Replace text on line" })
map_replace("n", "<leader>R", function()
  require("replace_text").ReplaceInFile()
end, { desc = "Replace text in file" })
map_replace("v", "<leader>r", function()
  require("replace_text").ReplaceInSelection()
end, { desc = "Replace text in selection" })

-- Togglers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })
map("n", "<leader>ih", "<cmd>ToggleInlayHints<CR>", { desc = "Toggle inlay hints" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle nvcheatsheet" })

-- LSP & Diagnostics
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "LSP show diagnostic float" })

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "[e", function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = "Go to previous error" })
map("n", "]e", function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = "Go to next error" })
map("n", "[w", function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
end, { desc = "Go to previous warning" })
map("n", "]w", function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
end, { desc = "Go to next warning" })

-- Minty
map("n", "<leader>cp", function()
  require("minty.huefy").open()
end, { desc = "Open color picker" })

-- NvChad
map("n", "<leader>th", function()
  require("nvchad.themes").open { style = "flat" }
end, { desc = "Open theme picker" })

-- NvMenu
local menus = utils.menus
map({ "n", "v" }, "<C-t>", function()
  require("menu").open(menus.main)
end, { desc = "Open NvChad menu" })

map({ "n", "v" }, "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'
  require("menu").open(menus.main, { mouse = true })
end, { desc = "Open NvChad menu" })

-- Term
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Term escape terminal mode" })

-- map({ "n", "t" }, "<A-v>", function()
--   require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
-- end, { desc = "Term toggle vertical split" })

map({ "n", "t" }, "<leader>v", function()
  require("nvchad.term").toggle {
    pos = "vsp",
    id = "vtoggleTermLoc",
    cmd = "cd " .. vim.fn.expand "%:p:h",
    size = 0.5, -- Adjust width for vertical split
  }
end, { desc = "Term toggle vertical split in buffer location" })

-- map({ "n", "t" }, "<A-h>", function()
--   require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
-- end, { desc = "Term toggle horizontal split" })

map({ "n", "t" }, "<leader>h", function()
  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTermLoc",
    cmd = "cd " .. vim.fn.expand "%:p:h",
    size = 0.2, -- Adjust height for horizontal split
  }
end, { desc = "Term toggle horizontal split in buffer location" })

map(
  {
    "n",
    "t",
  },
  "<leader>f",
  function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
  end,
  { desc = "Term toggle floating" }
)

map({ "n", "t" }, "<A-S-i>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTermLoc",
    cmd = "cd " .. vim.fn.expand "%:p:h",
  }
end, { desc = "Term toggle floating in buffer location" })

-- TreeSitter
map({ "n", "v" }, "<leader>it", function()
  utils.toggle_inspect_tree()
end, { desc = "TreeSitter toggle inspect tree" })

map("n", "<leader>ii", "<cmd>Inspect<CR>", { desc = "TreeSitter inspect under cursor" })

--- Tabufline
local tabufline = require "nvchad.tabufline"

map("n", "<Tab>", function()
  tabufline.next()
end, { desc = "Buffer go to next" })

map("n", "<S-Tab>", function()
  tabufline.prev()
end, { desc = "Buffer go to prev" })

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Buffer new" })
map("n", "<leader>bh", "<cmd>split | enew<CR>", { desc = "Buffer new horizontal split" })
map("n", "<leader>bv", "<cmd>vsplit | enew<CR>", { desc = "Buffer new vertical split" })

map("n", "<leader>x", function()
  tabufline.close_buffer()
end, { desc = "Buffer close" })

for i = 7, 9 do
  map("n", "<A-" .. i .. ">", i .. "gt", { desc = "Tab go to tab " .. i })
end

map("n", "<A-Left>", function()
  tabufline.move_buf(5)
end, { desc = "Tabufline move buffer to the left" })

map("n", "<A-Right>", function()
  tabufline.move_buf(7)
end, { desc = "Tabufline move buffer to the right" })

map("n", "<A-|>", "<cmd>TabuflineToggle<CR>", { desc = "Tabufline toggle visibility" })

map("n", "gh", function()
  utils.go_to_github_link()
end, { desc = "Go to GitHub link generated from string" })

-- ============================================================================
-- Helper Functions from configs/keymaps.lua
-- ============================================================================

local function show_r_table()
  local node = vim.treesitter.get_node { ignore_injections = false }
  assert(node, "no symbol found under cursor")
  local text = vim.treesitter.get_node_text(node, 0)
  local cmd = [[call slime#send("DT::datatable(]] .. text .. [[)" . "\r")]]
  vim.cmd(cmd)
end

local function toggle_light_dark_theme()
  if vim.o.background == "light" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end

local is_code_chunk = function()
  local current, _ = require("otter.keeper").get_current_language_context()
  if current then
    return true
  else
    return false
  end
end

local insert_code_chunk = function(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
  local keys
  if is_code_chunk() then
    keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
  else
    keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

local insert_r_chunk = function()
  insert_code_chunk "r"
end

local insert_py_chunk = function()
  insert_code_chunk "python"
end

local insert_lua_chunk = function()
  insert_code_chunk "lua"
end

local insert_julia_chunk = function()
  insert_code_chunk "julia"
end

local insert_bash_chunk = function()
  insert_code_chunk "bash"
end

local insert_ojs_chunk = function()
  insert_code_chunk "ojs"
end

local function new_terminal(lang)
  vim.cmd("vsplit term://" .. lang)
end

local function new_terminal_python()
  new_terminal "python"
end

local function new_terminal_r()
  new_terminal "R --no-save"
end

local function new_terminal_ipython()
  new_terminal "ipython --no-confirm-exit"
end

local function new_terminal_julia()
  new_terminal "julia"
end

local function new_terminal_shell()
  new_terminal "$SHELL"
end

local function get_otter_symbols_lang()
  local otterkeeper = require "otter.keeper"
  local main_nr = vim.api.nvim_get_current_buf()
  local langs = {}
  for i, l in ipairs(otterkeeper.rafts[main_nr].languages) do
    langs[i] = i .. ": " .. l
  end
  local i = vim.fn.inputlist(langs)
  local lang = otterkeeper.rafts[main_nr].languages[i]
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    otter = {
      lang = lang,
    },
  }
  vim.lsp.buf_request(main_nr, ms.textDocument_documentSymbol, params, nil)
end

-- ============================================================================
-- Which-Key Mappings from configs/keymaps.lua
-- ============================================================================

-- Normal mode which-key mappings
wk.add({
  { "<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
  { "<c-q>", "<cmd>q<cr>", desc = "close buffer" },
  { "<esc>", "<cmd>noh<cr>", desc = "remove search highlight" },
  { "<cm-i>", insert_py_chunk, desc = "python code chunk" },
  { "<m-I>", insert_py_chunk, desc = "python code chunk" },
  { "<m-i>", insert_r_chunk, desc = "r code chunk" },
  { "[q", ":silent cprev<cr>", desc = "[q]uickfix prev" },
  { "]q", ":silent cnext<cr>", desc = "[q]uickfix next" },
  { "gN", "Nzzzv", desc = "center search" },
  { "gf", ":e <cfile><CR>", desc = "edit file" },
  { "gl", "<c-]>", desc = "open help link" },
  { "n", "nzzzv", desc = "center search" },
  { "z?", ":setlocal spell!<cr>", desc = "toggle [z]pellcheck" },
  { "zl", ":Telescope spell_suggest<cr>", desc = "[l]ist spelling suggestions" },
}, { mode = "n", silent = true })

-- Visual mode which-key mappings
wk.add({
  { ".", ":norm .<cr>", desc = "repat last normal mode command" },
  { "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z", desc = "move line down" },
  { "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", desc = "move line up" },
  { "q", ":norm @q<cr>", desc = "repat q macro" },
}, { mode = "v" })

-- Visual mode with localleader
wk.add({
  { "<localleader>p", '"_dP', desc = "replace without overwriting reg" },
  { "<localleader>d", '"_d', desc = "delete without overwriting reg" },
}, { mode = "v" })

-- Insert mode which-key mappings
wk.add({
  { "<m-->", " <- ", desc = "assign" },
  { "<m-m>", " |>", desc = "pipe" },
  { "<m-i>", insert_r_chunk, desc = "r code chunk" },
  { "<cm-i>", insert_py_chunk, desc = "python code chunk" },
  { "<m-I>", insert_py_chunk, desc = "python code chunk" },
  { "<c-x><c-x>", "<c-x><c-o>", desc = "omnifunc completion" },
}, { mode = "i" })

-- Otter symbols
vim.keymap.set("n", "<localleader>os", get_otter_symbols_lang, { desc = "otter [s]ymbols" })

-- Normal mode with <localleader> - Which-Key Groups
wk.add({
  { "<localleader>c", group = "[c]ode / [c]ell / [c]hunk" },
  {
    { "<localleader>cn", new_terminal_shell, desc = "[n]ew terminal with shell" },
    {
      "cr",
      function()
        vim.b["quarto_is_r_mode"] = true
        new_terminal_r()
      end,
      desc = "new [R] terminal",
    },
    { "<localleader>cp", new_terminal_python, desc = "new [p]ython terminal" },
    { "<localleader>ci", new_terminal_ipython, desc = "new [i]python terminal" },
    { "<localleader>cj", new_terminal_julia, desc = "new [j]ulia terminal" },
  },
  { "<localleader>e", group = "[e]dit" },
  { "<localleader>d", group = "[d]ebug" },
  {
    { "<localleader>dt", desc = "[t]est" },
  },
  { "<localleader>f", group = "[f]ind (telescope)" },
  {
    { "<localleader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]iles" },
    { "<localleader>fh", "<cmd>Telescope help_tags<cr>", desc = "[h]elp" },
    { "<localleader>fk", "<cmd>Telescope keymaps<cr>", desc = "[k]eymaps" },
    { "<localleader>fg", "<cmd>Telescope live_grep<cr>", desc = "[g]rep" },
    { "<localleader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[b]uffer fuzzy find" },
    { "<localleader>fm", "<cmd>Telescope marks<cr>", desc = "[m]arks" },
    { "<localleader>fM", "<cmd>Telescope man_pages<cr>", desc = "[M]an pages" },
    { "<localleader>fc", "<cmd>Telescope git_commits<cr>", desc = "git [c]ommits" },
    { "<localleader>f<space>", "<cmd>Telescope buffers<cr>", desc = "[ ] buffers" },
    { "<localleader>fd", "<cmd>Telescope buffers<cr>", desc = "[d] buffers" },
    { "<localleader>fq", "<cmd>Telescope quickfix<cr>", desc = "[q]uickfix" },
    { "<localleader>fl", "<cmd>Telescope loclist<cr>", desc = "[l]oclist" },
    { "<localleader>fj", "<cmd>Telescope jumplist<cr>", desc = "[j]umplist" },
  },
  { "<localleader>g", group = "[g]it" },
  {
    { "<localleader>gc", ":GitConflictRefresh<cr>", desc = "[c]onflict" },
    { "<localleader>gs", ":Gitsigns<cr>", desc = "git [s]igns" },
    {
      "<localleader>gwc",
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
      desc = "worktree create",
    },
    {
      "<localleader>gws",
      ":lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
      desc = "worktree switch",
    },
    { "<localleader>gd", group = "[d]iff" },
    {
      { "<localleader>gdo", ":DiffviewOpen<cr>", desc = "[o]pen" },
      { "<localleader>gdc", ":DiffviewClose<cr>", desc = "[c]lose" },
    },
    { "<localleader>gb", group = "[b]lame" },
    {
      { "<localleader>gbb", ":GitBlameToggle<cr>", desc = "[b]lame toggle virtual text" },
      { "<localleader>gbo", ":GitBlameOpenCommitURL<cr>", desc = "[o]pen" },
      { "<localleader>gbc", ":GitBlameCopyCommitURL<cr>", desc = "[c]opy" },
    },
  },
  { "<localleader>h", group = "[h]elp / [h]ide / debug" },
  {
    { "<localleader>hc", group = "[c]onceal" },
    { "<localleader>hh", ":set conceallevel=1<cr>", desc = "[h]ide/conceal" },
    { "<localleader>hs", ":set conceallevel=0<cr>", desc = "[s]how/unconceal" },
  },
  { "<localleader>t", group = "[t]reesitter" },
  {
    { "<localleader>tt", vim.treesitter.inspect_tree, desc = "show [t]ree" },
  },
  { "<localleader>i", group = "[i]mage" },
  { "<localleader>l", group = "[l]anguage/lsp" },
  {
    { "<localleader>lr", vim.lsp.buf.references, desc = "[r]eferences" },
    { "<localleader>R", desc = "[R]ename" },
    { "<localleader>lD", vim.lsp.buf.type_definition, desc = "type [D]efinition" },
    { "<localleader>la", vim.lsp.buf.code_action, desc = "code [a]ction" },
    { "<localleader>le", vim.diagnostic.open_float, desc = "diagnostics (show hover [e]rror)" },
    { "<localleader>ld", group = "[d]iagnostics" },
    {
      {
        "<localleader>ldd",
        function()
          vim.diagnostic.enable(false)
        end,
        desc = "[d]isable",
      },
      { "<localleader>lde", vim.diagnostic.enable, desc = "[e]nable" },
    },
    { "<localleader>lg", ":Neogen<cr>", desc = "neo[g]en docstring" },
  },
  { "<localleader>o", group = "[o]tter & c[o]de" },
  {
    { "<localleader>oa", require("otter").activate, desc = "otter [a]ctivate" },
    { "<localleader>od", require("otter").deactivate, desc = "otter [d]eactivate" },
    { "<localleader>oc", "O# %%<cr>", desc = "magic [c]omment code chunk # %%" },
    { "<localleader>or", insert_r_chunk, desc = "[r] code chunk" },
    { "<localleader>op", insert_py_chunk, desc = "[p]ython code chunk" },
    { "<localleader>oj", insert_julia_chunk, desc = "[j]ulia code chunk" },
    { "<localleader>ob", insert_bash_chunk, desc = "[b]ash code chunk" },
    { "<localleader>oo", insert_ojs_chunk, desc = "[o]bservable js code chunk" },
    { "<localleader>ol", insert_lua_chunk, desc = "[l]lua code chunk" },
  },
  { "<localleader>q", group = "[q]uarto" },
  {
    { "<localleader>qa", ":QuartoActivate<cr>", desc = "[a]ctivate" },
    { "<localleader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "[p]review" },
    { "<localleader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "[q]uiet preview" },
    { "<localleader>qh", ":QuartoHelp ", desc = "[h]elp" },
    { "<localleader>qr", group = "[r]un" },
    {
      { "<localleader>qrr", ":QuartoSendAbove<cr>", desc = "to cu[r]sor" },
      { "<localleader>qra", ":QuartoSendAll<cr>", desc = "run [a]ll" },
      { "<localleader>qrb", ":QuartoSendBelow<cr>", desc = "run [b]elow" },
    },
    { "<localleader>qe", require("otter").export, desc = "[e]xport" },
    {
      "<localleader>qE",
      function()
        require("otter").export(true)
      end,
      desc = "[E]xport with overwrite",
    },
  },
  { "<localleader>r", group = "[r] R specific tools" },
  {
    { "<localleader>rt", show_r_table, desc = "show [t]able" },
  },
  { "<localleader>v", group = "[v]im" },
  {
    { "<localleader>vt", toggle_light_dark_theme, desc = "[t]oggle light/dark theme" },
    { "<localleader>vc", ":Telescope colorscheme<cr>", desc = "[c]olortheme" },
    { "<localleader>vl", ":Lazy<cr>", desc = "[l]azy package manager" },
    { "<localleader>vm", ":Mason<cr>", desc = "[m]ason software installer" },
    { "<localleader>vs", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>", desc = "[s]ettings, edit vimrc" },
    { "<localleader>vh", ':execute "h " . expand("<cword>")<cr>', desc = "vim [h]elp for current word" },
  },
  { "<localleader>x", group = "e[x]ecute" },
  {
    { "<localleader>xx", ":w<cr>:source %<cr>", desc = "[x] source %" },
  },
  { "<localleader>w", group = "[w]eb3 / blockchain" },
  {
    {
      "<localleader>wi",
      function()
        require("noah.web3").show_project_info()
      end,
      desc = "project [i]nfo",
    },
    { "<localleader>wt", group = "[t]est" },
    {
      {
        "<localleader>wtt",
        function()
          require("noah.web3").run_foundry_test()
        end,
        desc = "[t]est (Foundry)",
      },
      {
        "<localleader>wtv",
        function()
          require("noah.web3").run_foundry_test_verbose(2)
        end,
        desc = "test [v]erbose",
      },
      {
        "<localleader>wth",
        function()
          require("noah.web3").run_hardhat_test()
        end,
        desc = "test [h]ardhat",
      },
    },
    { "<localleader>wc", group = "[c]ompile" },
    {
      {
        "<localleader>wcf",
        function()
          require("noah.web3").compile_foundry()
        end,
        desc = "[f]oundry compile",
      },
      {
        "<localleader>wch",
        function()
          require("noah.web3").compile_hardhat()
        end,
        desc = "[h]ardhat compile",
      },
    },
    {
      "<localleader>wf",
      function()
        require("noah.web3").format_solidity_forge()
      end,
      desc = "[f]ormat (forge fmt)",
    },
  },
}, { mode = "n" })

-- Utils
-- map(
--   "n",
--   "<leader>rl",
--   "<cmd>s/[a-zA-Z]/\\=nr8char(("
--     .. "char2nr(submatch(0)) - (char2nr(submatch(0)) >= 97 ? 97 : 65) + 13"
--     .. ") % 26 + (char2nr(submatch(0)) >= 97 ? 97 : 65))/g<CR>",
--   { desc = "_ Mum and dad were having fun" }
-- )
--
-- map("n", "<leader>rf", function()
--   vim.cmd [[
--     %s/[a-zA-Z]/\=nr8char((
--       char2nr(submatch(0)) - (char2nr(submatch(0)) >= 97 ? 97 : 65) + 13
--     ) % 26 + (char2nr(submatch(0)) >= 97 ? 97 : 65))/g
--   ]]
-- end, { desc = "_ Mum and dad were having fun" })

map("n", "gx", [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], { noremap = true })

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<C-;>", api.tree.change_root_to_parent, opts "Up")
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
end

-- ###########################################
-- pass to setup along with your other options
-- ###########################################
require("nvim-tree").setup {
  ---
  on_attach = my_on_attach,
}
