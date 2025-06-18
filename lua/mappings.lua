local utils = require "gale.utils"
local map = utils.glb_map
local comments = require "utils.comments"
local popup = require "utils.popup"

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
map(
  "n",
  "<leader>cf",
  "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
  { desc = "Compress code (all supported formats)" }
)

-- Better escape using jk in insert and terminal mode
map("i", "jk", "<ESC>")
map("t", "jk", "<C-\\><C-n>")
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", ";", ";<c-g>u")

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
map("n", "<leader>a", "o```python<CR><ESC>O<ESC>o```")
map("n", "<leader>j", "o```javascript<CR><ESC>O<ESC>o```")
map("x", "<leader>`", ":<C-u>normal! I```<CR><ESC>gv:normal! A```<ESC>")

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

-- -- Replace text
-- map("n", "s", ":s//g<left><left>") -- Line
-- map("n", "S", ":%s//g<left><left>") -- All
-- map("v", "s", ":s//g<left><left>") -- Selection

local M = {}

function M.ReplaceCurrentLine()
  local search = vim.fn.input "Search: "
  if search == "" then
    print "Search is empty"
    return
  end
  local replace = vim.fn.input "Replace: "
  vim.cmd(string.format("s/%s/%s/g", search, replace))
end

function M.ReplaceInFile()
  local search = vim.fn.input "Search: "
  if search == "" then
    print "Search is empty"
    return
  end
  local replace = vim.fn.input "Replace: "
  vim.cmd(string.format("%%s/%s/%s/g", search, replace))
end

function M.ReplaceInSelection()
  local search = vim.fn.input "Search: "
  if search == "" then
    print "Search is empty"
    return
  end
  local replace = vim.fn.input "Replace: "
  vim.cmd(string.format("'<,'>s/%s/%s/g", search, replace))
end

-- Register this table as a pseudo-module to avoid luacheck warning
package.loaded.replace_text = M

-- Key mappings
map("n", "<leader>r", function()
  require("replace_text").ReplaceCurrentLine()
end, { desc = "Replace text on line" })
map("n", "<leader>R", function()
  require("replace_text").ReplaceInFile()
end, { desc = "Replace text on file" })
map("v", "<leader>r", function()
  require("replace_text").ReplaceInSelection()
end, { desc = "Replace text on selection" })

-- Togglers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })
map("n", "<leader>ih", "<cmd>ToggleInlayHints<CR>", { desc = "Toggle inlay hints" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle nvcheatsheet" })

-- LSP
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<leader>de", vim.diagnostic.open_float)

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
