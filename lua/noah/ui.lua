-- Floating UI polish for which-key + telescope.
--
-- Single source of truth for float / picker highlight groups. Re-applied on
-- every ColorScheme so theme swaps keep the same visual language. Palette is
-- resolved from the current theme, not hard-coded, so any NvChad theme works.

local M = {}

---@return {fg:integer?, bg:integer?}
local function resolve(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and hl or {}
end

---Palette derived from the currently-loaded colorscheme.
local function palette()
  return {
    accent = resolve("Function").fg,
    muted = resolve("Comment").fg,
    bg = resolve("Normal").bg,
    -- URLs: prefer a colour that survives across themes and clearly differs
    -- from Normal.fg. String is green in most themes (Gruvbox included) and
    -- reads as "resource"; Identifier (blue) is the classic web-link tint;
    -- fall back to Special before giving up on Normal so a stripped-down
    -- theme still produces *some* colour.
    link = resolve("String").fg or resolve("Identifier").fg or resolve("Special").fg,
    -- Link labels ([text]): Function is theme-accent and pops as clickable.
    link_label = resolve("Function").fg or resolve("Identifier").fg,
  }
end

---Highlight spec table.
---Values may reference {accent,muted,bg} placeholders as {"accent"} etc.
---This is expanded per apply() call so themes swap cleanly.
local groups = function(p)
  return {
    -- Shared float baseline.
    FloatBorder = { fg = p.muted, bg = p.bg },
    FloatTitle = { fg = p.accent, bg = p.bg, bold = true },
    NormalFloat = { bg = p.bg },

    -- Telescope: distinct prompt border draws the eye first.
    TelescopeNormal = { bg = p.bg },
    TelescopeBorder = { fg = p.muted, bg = p.bg },
    TelescopePromptNormal = { bg = p.bg },
    TelescopePromptBorder = { fg = p.accent, bg = p.bg },
    TelescopePromptTitle = { fg = p.accent, bg = p.bg, bold = true },
    TelescopePromptPrefix = { fg = p.accent, bg = p.bg, bold = true },
    TelescopeResultsNormal = { bg = p.bg },
    TelescopeResultsBorder = { fg = p.muted, bg = p.bg },
    TelescopeResultsTitle = { link = "FloatTitle" },
    TelescopePreviewNormal = { bg = p.bg },
    TelescopePreviewBorder = { fg = p.muted, bg = p.bg },
    TelescopePreviewTitle = { link = "FloatTitle" },
    TelescopeSelection = { link = "CursorLine" },
    TelescopeSelectionCaret = { fg = p.accent, bold = true },
    TelescopeMatching = { fg = p.accent, bold = true },
    -- File paths read as secondary information.
    TelescopeResultsComment = { link = "Comment" },
    TelescopePathSeparator = { link = "Comment" },

    -- which-key: three tiers (key / desc / value).
    WhichKeyFloat = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyTitle = { link = "FloatTitle" },
    WhichKey = { fg = p.accent, bold = true },
    WhichKeyGroup = { link = "Function" },
    WhichKeyDesc = { link = "Normal" },
    WhichKeySeparator = { link = "Comment" },
    WhichKeyValue = { link = "Comment" },
    WhichKeyIcon = { link = "Special" },

    -- Markdown links: distinct colour + underline so URLs stand out from prose.
    -- Covers three sources: treesitter (@markup.link.*), Vim's built-in
    -- markdown syntax (markdownUrl, markdownLinkText), and markview.nvim
    -- (MarkviewHyperlink, MarkviewEmail).
    ["@markup.link"] = { fg = p.link, underline = true },
    ["@markup.link.markdown_inline"] = { fg = p.link, underline = true },
    ["@markup.link.label"] = { fg = p.link_label, bold = true },
    ["@markup.link.label.markdown_inline"] = { fg = p.link_label, bold = true },
    ["@markup.link.url"] = { fg = p.link, underline = true, italic = true },
    ["@markup.link.url.markdown_inline"] = { fg = p.link, underline = true, italic = true },

    markdownUrl = { fg = p.link, underline = true, italic = true },
    markdownLink = { fg = p.link, underline = true },
    markdownLinkText = { fg = p.link_label, bold = true },
    markdownLinkTextDelimiter = { link = "Comment" },
    markdownLinkDelimiter = { link = "Comment" },
    markdownAutomaticLink = { fg = p.link, underline = true },
    markdownIdDeclaration = { fg = p.link, underline = true },

    MarkviewHyperlink = { fg = p.link, underline = true },
    MarkviewEmail = { fg = p.link, underline = true, italic = true },
    MarkviewImage = { fg = p.link_label, bold = true },
    MarkviewImageLink = { fg = p.link, underline = true },

    -- Bare URLs in Markdown: the tree-sitter markdown grammar does NOT tokenize
    -- unwrapped URLs (only <autolink> and [text](url) get @markup.link.url).
    -- A window-local matchadd() paints this group over any http(s):// run.
    MarkdownBareUrl = { fg = p.link, underline = true, italic = true },
  }
end

---Bare-URL matchadd: window-local so it survives buffer navigation.
---Idempotent via a window variable so re-firing the FileType autocmd doesn't
---stack duplicate matches.
local BARE_URL_PATTERN = [[\v<(https?|ftp)://[^ \t\r\n<>"'`]+]]

local function apply_bare_url_match()
  if vim.bo.filetype ~= "markdown" then return end
  local win = vim.api.nvim_get_current_win()
  local ok, existing = pcall(vim.api.nvim_win_get_var, win, "noah_bare_url_match")
  if ok and existing then pcall(vim.fn.matchdelete, existing, win) end
  local id = vim.fn.matchadd("MarkdownBareUrl", BARE_URL_PATTERN, 10)
  vim.api.nvim_win_set_var(win, "noah_bare_url_match", id)
end

---Apply every group to namespace 0 (global).
function M.apply()
  local p = palette()
  for name, spec in pairs(groups(p)) do
    vim.api.nvim_set_hl(0, name, spec)
  end
  -- Shared Git status vocabulary (Oil + nvim-tree). Colours resolve from
  -- theme diagnostics/semantic groups, so a colorscheme swap keeps parity.
  local ok, git_ui = pcall(require, "noah.git_ui")
  if ok then git_ui.apply_highlights() end
end

---Register the ColorScheme autocmd and do a first-run apply.
function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UIPolish", { clear = true }),
    callback = M.apply,
  })
  -- Deferred: theme may not be loaded when this runs at init.
  vim.schedule(M.apply)

  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("NoahMarkdownBareUrls", { clear = true }),
    pattern = { "markdown", "*.md", "*.markdown" },
    callback = apply_bare_url_match,
  })

  -- Oil directory Git-status set aggregation (see noah/oil_git_agg.lua).
  local ok, oil_agg = pcall(require, "noah.oil_git_agg")
  if ok then oil_agg.setup() end

  -- Symbol legend + toggle helpers (see noah/symbols.lua). Loading it here
  -- registers :SymbolLegend at startup with negligible cost.
  pcall(require, "noah.symbols")
end

return M
