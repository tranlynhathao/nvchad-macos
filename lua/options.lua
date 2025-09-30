require "nvchad.options"

local g = {
  dap_virtual_text = true,
  bookmark_sign = "",
  skip_ts_context_commentstring_module = true,
  tabufline_visible = true,
}

local opt = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  clipboard = "unnamedplus", -- extended via "vincent.wsl"
  -- Folds
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldcolumn = "0",
  foldtext = "",
  foldlevel = 99,
  foldlevelstart = 5,
  foldnestmax = 5,
  -- Prevent issues with some language servers
  backup = false,
  swapfile = false,
  -- Always show minimum n lines after/before current line
  scrolloff = 10,
  -- True color support
  termguicolors = true,
  emoji = false,
  relativenumber = true,
  -- Line break/wrap behaviours
  wrap = true,
  linebreak = true,
  textwidth = 0,
  wrapmargin = 0,
  -- Indentation values
  tabstop = 2,
  shiftwidth = 0, -- 0 forces same value as tabstop
  expandtab = true,
  autoindent = true,
  cursorline = true,
  cursorlineopt = "both",
  inccommand = "split",
  ignorecase = true,
  updatetime = 100,
  lazyredraw = false,
  path = vim.opt.path:append { "**", "lua", "src" },
}

for k, v in pairs(g) do
  vim.g[k] = v
end

for k, v in pairs(opt) do
  vim.opt[k] = v
end

-- set up interface and colorscheme
-- vim.opt.background = "dark"
-- vim.cmd.colorscheme "solarize_osaka" -- gruvbox

-- local filename = {
--   "filename",
--   path = 1,
--   symbols = {
--     modified = "[+]",
--     readonly = "[]",
--     unnamed = "[No Name]",
--     newfile = "[New]",
--   },
-- }

-- local function location()
--   local total = vim.api.nvim_buf_line_count(0)
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return tostring(row) .. "/" .. total .. ":" .. tostring(col + 1)
-- end

-- local function md_wordcount()
--   if vim.bo.filetype == "markdown" then
--     local wc = vim.fn.wordcount()
--     local words = "/" .. tostring(wc.words) .. " words"
--     if wc.visual_words ~= nil then
--       return tostring(wc.visual_words) .. words
--     end
--     return tostring(wc.cursor_words) .. words
--   end
--   return ""
-- end

require("lualine").setup {
  options = {
    theme = "gruvbox",
    -- - `16color`
    -- - `auto` (default theme)
    -- - `ayu_dark`
    -- - `ayu_light`
    -- - `ayu_mirage`
    -- - `catppuccin` *(Catpucin was set up)*
    -- - `dracula`
    -- - `everforest`
    -- - `gruvbox`
    -- - `gruvbox_material`
    -- - `horizon`
    -- - `iceberg`
    -- - `material`
    -- - `molokai`
    -- - `nightfly`
    -- - `nord`
    -- - `onedark`
    -- - `palenight`
    -- - `powerline`
    -- - `powerline_dark`
    -- - `rose-pine`
    -- - `solarized`
    -- - `solarized_dark`
    -- - `solarized_light`
    -- - `tokyonight`
    -- - `wombat`

    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    icons_enabled = true,
  },
  sections = {
    lualine_a = { "mode" },
    -- lualine_a = {
    --   {
    --     "mode",
    --     icon = "",
    --                                                             
    --   },
    -- },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        file_status = true, -- Displays file status (readonly, modified)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      },
    },
    lualine_x = {
      "encoding",
      {
        "fileformat",
        icons_enabled = false, -- disable default icons
        fmt = function()
          return "%#MyIconColor#%#Normal#"
        end,
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

vim.cmd "highlight MyIconColor guifg=#FF5733"

-- New config

-- vim.cmd("set expandtab")
-- vim.cmd("set tabstop=4")
-- vim.cmd("set softtabstop=4")
-- vim.cmd("set shiftwidth=4")
-- vim.g.mapleader = " "
-- vim.cmd("set number")
-- vim.cmd("set relativenumber")
-- vim.cmd("set cursorline")
-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "white" })
-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })
-- vim.api.nvim_set_option("clipboard", "unnamed")
-- vim.opt.hlsearch = true
-- vim.opt.incsearch = true
-- -- move selected lines
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- -- paste over highlight word
-- vim.keymap.set("x", "<leader>p", '"_dP')
-- vim.opt.colorcolumn = "94"
-- vim.opt.clipboard = "unnamedplus"
-- -- fk llm-ls
-- local notify_original = vim.notify
-- vim.notify = function(msg, ...)
-- 	if
-- 		msg
-- 		and (
-- 			msg:match("position_encoding param is required")
-- 			or msg:match("Defaulting to position encoding of the first client")
-- 			or msg:match("multiple different client offset_encodings")
-- 		)
-- 	then
-- 		return
-- 	end
-- 	return notify_original(msg, ...)
-- end
-- vim.opt.swapfile = false
--
