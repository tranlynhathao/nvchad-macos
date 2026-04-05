local config = require "nvconfig"
local get_theme_tb = require("base46").get_theme_tb
local colors = get_theme_tb "base_30"
local theme_type = get_theme_tb "type"
local lighten = require("base46.colors").change_hex_lightness

local statusline_bg = config.base46.transparency and "NONE" or lighten(colors.statusline_bg, 1)
local panel = colors.one_bg3
local panel_alt = lighten(colors.one_bg2, 6)
local panel_soft = lighten(colors.one_bg, 8)
local text = theme_type == "light" and lighten(colors.light_grey, -18) or lighten(colors.light_grey, 8)
local muted = theme_type == "light" and lighten(colors.grey_fg, -12) or lighten(colors.grey_fg, 12)
local strong = theme_type == "light" and colors.black or colors.white
local dark_text = colors.black

local M = {
  StatusLine = { fg = text, bg = statusline_bg },
  StText = { fg = text, bg = statusline_bg },
  StPremiumDivider = { fg = muted, bg = statusline_bg },

  StPremiumProjectSep = { fg = panel, bg = statusline_bg },
  StPremiumProject = { fg = text, bg = panel },
  StPremiumProjectIcon = { fg = colors.yellow, bg = panel },
  StPremiumProjectText = { fg = text, bg = panel, bold = true },

  StPremiumFileSep = { fg = panel_alt, bg = statusline_bg },
  StPremiumFile = { fg = text, bg = panel_alt },
  StPremiumFileIcon = { fg = colors.blue, bg = panel_alt },
  StPremiumFilePath = { fg = muted, bg = panel_alt },
  StPremiumFileName = { fg = strong, bg = panel_alt, bold = true },
  StPremiumFileFlagModified = { fg = colors.yellow, bg = panel_alt, bold = true },
  StPremiumFileFlagReadOnly = { fg = colors.red, bg = panel_alt },
  StPremiumFileFlagNew = { fg = colors.green, bg = panel_alt, italic = true },

  StPremiumHarpoonSep = { fg = panel, bg = statusline_bg },
  StPremiumHarpoon = { fg = text, bg = panel },
  StPremiumHarpoonIcon = { fg = colors.purple, bg = panel },
  StPremiumHarpoonText = { fg = text, bg = panel, bold = true },

  StPremiumGitSep = { fg = panel, bg = statusline_bg },
  StPremiumGit = { fg = text, bg = panel },
  StPremiumGitBranch = { fg = colors.baby_pink, bg = panel, bold = true },
  StPremiumGitAdd = { fg = colors.green, bg = panel },
  StPremiumGitChange = { fg = colors.yellow, bg = panel },
  StPremiumGitRemove = { fg = colors.red, bg = panel },

  StPremiumDiagSep = { fg = panel_alt, bg = statusline_bg },
  StPremiumDiag = { fg = text, bg = panel_alt },
  StPremiumDiagError = { fg = colors.red, bg = panel_alt, bold = true },
  StPremiumDiagWarn = { fg = colors.yellow, bg = panel_alt, bold = true },
  StPremiumDiagInfo = { fg = colors.blue, bg = panel_alt },
  StPremiumDiagHint = { fg = colors.purple, bg = panel_alt },

  StPremiumLspSep = { fg = panel, bg = statusline_bg },
  StPremiumLsp = { fg = text, bg = panel },
  StPremiumLspIcon = { fg = colors.green, bg = panel },
  StPremiumLspText = { fg = text, bg = panel, bold = true },

  StPremiumWriteSep = { fg = panel_alt, bg = statusline_bg },
  StPremiumWrite = { fg = text, bg = panel_alt },
  StPremiumWriteIcon = { fg = colors.orange, bg = panel_alt },
  StPremiumWriteText = { fg = text, bg = panel_alt },

  StPremiumMetaSep = { fg = panel, bg = statusline_bg },
  StPremiumMeta = { fg = text, bg = panel },
  StPremiumMetaIcon = { fg = colors.cyan, bg = panel },
  StPremiumMetaText = { fg = muted, bg = panel },

  StPremiumCenterSep = { fg = panel_soft, bg = statusline_bg },
  StPremiumCenter = { fg = text, bg = panel_soft },
  StPremiumCenterIcon = { fg = colors.orange, bg = panel_soft },
  StPremiumCenterText = { fg = muted, bg = panel_soft },

  StPremiumPosSep = { fg = colors.green, bg = statusline_bg },
  StPremiumPos = { fg = dark_text, bg = colors.green, bold = true },
  StPremiumPosIcon = { fg = dark_text, bg = colors.green, bold = true },
  StPremiumPosText = { fg = dark_text, bg = colors.green, bold = true },
  StPremiumPosMeta = { fg = dark_text, bg = colors.green },

  StPremiumInactiveIcon = { fg = muted, bg = statusline_bg },
  StPremiumInactivePath = { fg = muted, bg = statusline_bg },
  StPremiumInactiveName = { fg = text, bg = statusline_bg },
  StPremiumInactiveMeta = { fg = muted, bg = statusline_bg },
}

local function add_mode_hl(name, color)
  M["StPremiumMode" .. name .. "Sep"] = { fg = colors[color], bg = statusline_bg }
  M["StPremiumMode" .. name] = { fg = dark_text, bg = colors[color], bold = true }
end

add_mode_hl("Normal", "blue")
add_mode_hl("Insert", "green")
add_mode_hl("Visual", "cyan")
add_mode_hl("Replace", "orange")
add_mode_hl("Command", "yellow")
add_mode_hl("Select", "purple")
add_mode_hl("Confirm", "teal")
add_mode_hl("Terminal", "green")
add_mode_hl("NTerminal", "yellow")

return M
