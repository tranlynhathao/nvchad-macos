-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local modules = require("gale.chadrc_aux").modules
local themes_customs = require("gale.chadrc_aux").themes_customs

M.base46 = {
  transparency = true,
  theme = "gruvbox", ---@diagnostic disable-line -- TODO: remove kanagawa
  theme_toggle = { "gruvbox", "gruvbox" }, ---@diagnostic disable-line --TODO remove kanagawa
  integrations = {
    "blankline",
    "cmp",
    "codeactionmenu",
    "dap",
    "devicons",
    "hop",
    "lsp",
    "mason",
    "neogit",
    "notify",
    "nvimtree",
    "rainbowdelimiters",
    "semantic_tokens",
    "todo",
    "whichkey",
  },
}

M.base46.hl_override = {
  DevIconMd = { fg = "#FFFFFF", bg = "NONE" },
  FloatTitle = { link = "FloatBorder" },
  CursorLineNr = { bold = true },
  CmpBorder = { link = "FloatBorder" },
  CmpDocBorder = { link = "FloatBorder" },
  TelescopeBorder = { link = "FloatBorder" },
  TelescopePromptBorder = { link = "FloatBorder" },
  NeogitDiffContext = { bg = "NONE" },
  NeogitDiffContextHighlight = { bg = "NONE" },
  TbBufOffModified = { fg = { "green", "black", 50 } },
  Comment = { italic = true },
  ["@comment"] = { link = "Comment" },
  ["@keyword"] = { italic = true },
  ["@markup.heading"] = { fg = "NONE", bg = "NONE" },
}

M.base46.hl_add = {
  YankVisual = { bg = "lightbg" },
  Border = { link = "FloatBorder" },
  St_HarpoonInactive = { link = "StText" },
  St_HarpoonActive = { link = "St_LspHints" },
  St_GitBranch = { fg = "baby_pink", bg = M.base46.transparency and "NONE" or "statusline_bg" },
  St_Oil = { fg = "grey_fg", bg = M.base46.transparency and "NONE" or "statusline_bg" },
  MarkviewLayer2 = { bg = "#171B21" },
  MarkviewCode = { link = "MarkviewLayer2" },
  HelpviewCode = { link = "MarkviewLayer2" },
  HelpviewInlineCode = { link = "MarkviewInlineCode" },
  HelpviewCodeLanguage = { link = "MarkviewCode" },
  OilWinbar = { fg = "vibrant_green", bold = true },
  CodeActionSignHl = { fg = "#F9E2AF" },
  ["@number.luadoc"] = { fg = "Comment" },
  ["@markup.quote.markdown"] = { bg = "NONE" },
  ["@markup.raw.block.markdown"] = { link = "MarkviewLayer2" },
}

local theme_customs = themes_customs[M.base46.theme]
M.base46 = theme_customs and vim.tbl_deep_extend("force", M.base46, theme_customs) or M.base46

M.ui = {
  cmp = {
    style = "vscode",
  },
  statusline = {
    theme = "vscode",
    order = {
      "mode",
      "tint",
      "filename",
      "modified",
      "tint",
      "git_custom",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "harpoon",
      "word_count",
      "separator",
      "cwd",
    },
    modules = {
      hack = modules.statusline.hack,
      filename = modules.statusline.filename,
      harpoon = modules.statusline.harpoon,
      git_custom = modules.statusline.git_custom,
      modified = modules.statusline.modified,
      separator = modules.statusline.separator,
      word_count = modules.statusline.word_count,
      tint = modules.statusline.tint,
    },
  },

  tabufline = {
    order = { "buffers", "tabs", "btns" },
  },

  telescope = { style = "bordered" },
}

M.cheatsheet = {
  excluded_groups = { "_" },
}

M.colorify = {
  enabled = true,
  mode = "virtual",
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

M.lsp = {
  signature = true,
}

M.term = {
  float = {
    border = "rounded",
    height = 0.5,
    width = 0.58,
    col = 0.2,
    row = 0.2,
  },
  sizes = {},
}

return M
