-- ~/.config/nvim/init.lua
-- require module
require "bootstrap"
require "gale.globals"
require "gale.usercmds"
require "gale.autocmds"
require "gale.aliases"
-- require "gale.wsl"
-- require "gale.linux"
require "gale.macos"
require "gale.vim"
require "gale.filetypes"
require "options"
require "mappings"
require "configs.keymaps"
-- end require

-- Autocommand to reload config on save
vim.cmd "source ~/.config/nvim/lua/chadrc.lua"

vim.cmd [[
augroup LuaAutoSource
  autocmd!
  autocmd BufWritePost *.lua luafile %
augroup END
]]

-- vim.cmd [[
-- augroup StatusLineGroup
--   autocmd!
--   autocmd BufEnter * setlocal statusline=%f\ %m\ %r
-- augroup END
-- ]]

-- Other custom configurations
vim.opt.colorcolumn = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 500

-- ###### Custom functions and mappings #####
local function InsertBackLink()
  local backlink_text = vim.fn.input "Backlink Text: "
  local backlink_url = vim.fn.input "Backlink URL: "
  vim.api.nvim_put({ "[" .. backlink_text .. "](" .. backlink_url .. ")" }, "c", true, true)
end
_G.InsertBackLink = InsertBackLink

-- Open Lazygit
vim.api.nvim_create_user_command("Lazygit", function()
  require("lazygit").lazygit()
end, {})

-- Lua configuration for telescope to open markdown links
function OpenMarkdownLink()
  local line = vim.api.nvim_get_current_line()
  local path = string.match(line, "%]%((.-)%)")

  if path then
    vim.cmd("edit " .. path)
  else
    print "No markdown link found on this line"
  end
end

vim.api.nvim_set_keymap("n", "<C-o>", ":lua OpenMarkdownLink()<CR>", { noremap = true, silent = true })

-- Toggle wrap for long lines
function ToggleWrap()
  if vim.bo.filetype == "markdown" then
    if vim.wo.wrap then
      vim.wo.wrap = false
      vim.wo.linebreak = false
      vim.wo.breakindent = false
      print "Markdown Wrap OFF"
    else
      vim.wo.wrap = true
      vim.wo.linebreak = true
      vim.wo.breakindent = true
      vim.wo.showbreak = "↪ "
      print "Markdown Wrap ON"
    end
  else
    print "Not a markdown file"
  end
end

vim.api.nvim_set_keymap("n", "<leader>w", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })

-- notify config
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:match "Re-sourcing your config is not supported with lazy.nvim" then
    return
  end
  if original_notify then
    original_notify(msg, level, opts)
  else
    print("Notify triggered:", msg)
  end
end

-- update statusline when switching via buffers
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = "*",
--   callback = function()
--     vim.cmd "redrawstatus"
--   end,
-- })

-- slime config
vim.g.slime_target = "neovim"
vim.api.nvim_set_keymap("v", "<C-c>", "<Plug>SlimeSend", { noremap = true, silent = true })
vim.g.slime_target = "tmux" -- Or "neovim" if you want to send 1 shell-terminal inside neovim
vim.g.slime_bracketed_paste = 1

vim.g.base47_cache = vim.fn.stdpath "cache" .. "/base47/"

-- Autocommand to reload Lua files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    vim.cmd "luafile %"
  end,
})

-- Function to toggle comment for Pug
local function toggle_pug_comment(mode)
  local comment_prefix = mode == "html" and "//" or "//-"
  local line_start = vim.fn.getpos("'<")[2] -- Get start line of selection
  local line_end = vim.fn.getpos("'>")[2] -- Get end line of selection

  for line = line_start, line_end do
    local content = vim.fn.getline(line) -- Get the content of the line
    if vim.startswith(content, comment_prefix) then
      -- Uncomment: Remove the prefix if it exists
      vim.fn.setline(line, content:sub(#comment_prefix + 2)) -- Remove `//` or `//-` plus a space
    else
      -- Comment: Add the prefix
      vim.fn.setline(line, comment_prefix .. " " .. content)
    end
  end
end

-- Keymaps for commenting in Normal mode
vim.keymap.set("n", "<leader>ch", function()
  vim.cmd "normal! I// "
end, { desc = "Insert HTML comment (//) in Normal mode" })

vim.keymap.set("n", "<leader>cp", function()
  vim.cmd "normal! I//- "
end, { desc = "Insert Pug comment (//-) in Normal mode" })

-- Keymaps for commenting in Visual mode
vim.keymap.set("v", "<leader>ch", function()
  toggle_pug_comment "html"
end, { desc = "Toggle HTML comments (//) in Visual mode" })

vim.keymap.set("v", "<leader>cp", function()
  toggle_pug_comment "pug"
end, { desc = "Toggle Pug comments (//-) in Visual mode" })
