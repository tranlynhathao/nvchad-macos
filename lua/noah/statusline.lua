local stl = require "nvchad.stl.utils"

local M = {}
local applied_theme_key

local root_markers = {
  ".git",
  "lua",
  "package.json",
  "pyproject.toml",
  "Cargo.toml",
  "go.mod",
  "stylua.toml",
  "Makefile",
}

local writing_filetypes = {
  asciidoc = true,
  gitcommit = true,
  markdown = true,
  mail = true,
  norg = true,
  org = true,
  plaintex = true,
  quarto = true,
  rst = true,
  tex = true,
  text = true,
  typst = true,
}

local lsp_aliases = {
  basedpyright = "pyright",
  cssls = "css",
  eslint = "eslint",
  gopls = "go",
  html = "html",
  jsonls = "json",
  lua_ls = "lua",
  nil_ls = "nil",
  rust_analyzer = "rust",
  tailwindcss = "tailwind",
  taplo = "toml",
  ts_ls = "ts",
  volar = "vue",
  yamlls = "yaml",
}

local function esc(text)
  return (text or ""):gsub("%%", "%%%%")
end

local function stbufnr()
  return stl.stbufnr()
end

local function stwinid()
  return vim.g.statusline_winid or 0
end

local function winwidth()
  local win = stwinid()
  if win ~= 0 and vim.api.nvim_win_is_valid(win) then
    return vim.api.nvim_win_get_width(win)
  end

  return vim.o.columns
end

local function has_width(min_width)
  return winwidth() >= min_width
end

local function is_active()
  return stl.is_activewin()
end

local function append(parts, value)
  if value and value ~= "" then
    table.insert(parts, value)
  end
end

local function join(parts, sep)
  local filtered = {}

  for _, part in ipairs(parts) do
    if part and part ~= "" then
      table.insert(filtered, part)
    end
  end

  return table.concat(filtered, sep or "")
end

local function pill(sep_hl, body_hl, content)
  if not content or content == "" then
    return ""
  end

  return "%#" .. sep_hl .. "#%#" .. body_hl .. "# " .. content .. " %#" .. sep_hl .. "#"
end

local function divider()
  return "%#StPremiumDivider# "
end

local function theme_key()
  local config = require "nvconfig"
  return table.concat({
    config.base46.theme,
    tostring(config.base46.transparency),
    config.ui.statusline.theme,
  }, ":")
end

local function ensure_highlights()
  local key = theme_key()
  if applied_theme_key == key then
    return
  end

  package.loaded["base46.integrations.statusline.noah_premium"] = nil
  local groups = require "base46.integrations.statusline.noah_premium"

  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  applied_theme_key = key
end

local function buffer_path(buf)
  return vim.api.nvim_buf_get_name(buf)
end

local function buffer_root(buf)
  local path = buffer_path(buf)

  if path == "" or path:match "^[%w.+-]+://" then
    return vim.uv.cwd()
  end

  for _, client in ipairs(vim.lsp.get_clients { bufnr = buf }) do
    local root = client.config and client.config.root_dir or client.root_dir
    if type(root) == "string" and root ~= "" and vim.startswith(path, root) then
      return root
    end
  end

  local root = vim.fs.root(path, root_markers)
  if root and root ~= "" then
    return root
  end

  return vim.uv.cwd()
end

local function relative_path(path, root)
  if path == "" then
    return ""
  end

  if type(root) == "string" and root ~= "" then
    local prefix = root .. "/"
    if vim.startswith(path, prefix) then
      return path:sub(#prefix + 1)
    end
  end

  return vim.fn.fnamemodify(path, ":~:.")
end

local function split_path(path)
  local parts = {}

  for part in (path or ""):gmatch "[^/\\]+" do
    table.insert(parts, part)
  end

  return parts
end

local function truncate_text(text, max_width)
  if #text <= max_width then
    return text
  end

  return text:sub(1, math.max(max_width - 1, 1)) .. "…"
end

local function file_icon(name)
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return "󰈚"
  end

  return devicons.get_icon(name, nil, { default = true }) or "󰈚"
end

local function special_buffer_identity(buf)
  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype
  local path = buffer_path(buf)

  if ft == "oil" then
    local dir = ""
    local ok, oil = pcall(require, "oil")
    if ok then
      local oil_ok, current_dir = pcall(oil.get_current_dir, buf)
      dir = oil_ok and current_dir or ""
    end

    dir = dir ~= "" and dir or path:gsub("^oil://", "")
    dir = dir ~= "" and vim.fn.fnamemodify(dir, ":~:.") or "Oil"
    return { icon = "󰏇", parent = "", name = dir }
  end

  if bt == "terminal" then
    local term = path:match "term://.-:%d+:(.*)" or "terminal"
    return { icon = "", parent = "", name = term }
  end

  if ft == "help" then
    return { icon = "󰋖", parent = "", name = vim.fn.fnamemodify(path, ":t:r") }
  end

  if ft == "qf" then
    return { icon = "󱂬", parent = "", name = "Quickfix" }
  end

  if ft == "lazy" then
    return { icon = "󰒲", parent = "", name = "Lazy" }
  end

  if ft == "alpha" then
    return { icon = "", parent = "", name = "Dashboard" }
  end
end

local function parent_path(parts, inactive)
  if #parts <= 1 then
    return ""
  end

  local parent = table.concat(vim.list_slice(parts, 1, #parts - 1), "/")
  local width = winwidth()

  if inactive then
    width = math.min(width, 100)
  end

  if width < 80 then
    local last_parent = parts[#parts - 1]
    parent = (#parts > 2 and "…/" or "") .. last_parent
  elseif width < 115 then
    parent = vim.fn.pathshorten(parent, 1)
  elseif width < 155 then
    parent = vim.fn.pathshorten(parent, 2)
  end

  if parent ~= "" then
    parent = parent .. "/"
  end

  return parent
end

local function file_identity(buf, inactive)
  local special = special_buffer_identity(buf)
  if special then
    return special
  end

  local path = buffer_path(buf)
  if path == "" then
    return { icon = "󰈔", parent = "", name = "[No Name]" }
  end

  local root = buffer_root(buf)
  local relative = relative_path(path, root)
  local parts = split_path(relative ~= "" and relative or path)
  local name = parts[#parts] or vim.fs.basename(path)

  return {
    icon = file_icon(name),
    parent = parent_path(parts, inactive),
    name = name,
  }
end

local function file_flags(buf, inactive)
  local background = inactive and "StPremiumInactiveMeta" or "StPremiumFile"
  local flags = {}

  if vim.bo[buf].modified then
    table.insert(flags, "%#StPremiumFileFlagModified# ●")
  end

  if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
    table.insert(flags, "%#StPremiumFileFlagReadOnly# ")
  end

  if buffer_path(buf) == "" and vim.bo[buf].buftype == "" then
    table.insert(flags, "%#StPremiumFileFlagNew# new")
  end

  if #flags == 0 then
    return ""
  end

  return "%#" .. background .. "#" .. table.concat(flags)
end

local function mode_segment()
  local current = vim.api.nvim_get_mode().mode
  local mode = stl.modes[current] or { current, "Normal" }
  local name = mode[1]

  if not has_width(115) then
    name = ({
      NORMAL = "N",
      INSERT = "I",
      VISUAL = "V",
      ["V-LINE"] = "VL",
      ["V-BLOCK"] = "VB",
      REPLACE = "R",
      COMMAND = "C",
      TERMINAL = "T",
      NTERMINAL = "NT",
      SELECT = "S",
    })[name] or name
  end

  return pill("StPremiumMode" .. mode[2] .. "Sep", "StPremiumMode" .. mode[2], " " .. esc(name))
end

local function project_segment()
  local buf = stbufnr()
  local path = buffer_path(buf)

  if path == "" or vim.bo[buf].buftype ~= "" or not has_width(100) then
    return ""
  end

  local project = vim.fs.basename(buffer_root(buf))
  if project == "" then
    return ""
  end

  if not has_width(135) then
    project = truncate_text(project, 14)
  end

  return pill("StPremiumProjectSep", "StPremiumProject", "%#StPremiumProjectIcon#󰉋 %#StPremiumProjectText#" .. esc(project))
end

local function file_segment(inactive)
  local buf = stbufnr()
  local item = file_identity(buf, inactive)
  local background = inactive and "StPremiumInactiveMeta" or "StPremiumFile"

  if inactive then
    return "%#StPremiumInactiveIcon#"
      .. item.icon
      .. " %#StPremiumInactivePath#"
      .. esc(item.parent)
      .. "%#StPremiumInactiveName#"
      .. esc(item.name)
      .. file_flags(buf, true)
  end

  local content = "%#StPremiumFileIcon#"
    .. item.icon
    .. " %#StPremiumFilePath#"
    .. esc(item.parent)
    .. "%#StPremiumFileName#"
    .. esc(item.name)
    .. file_flags(buf)

  return pill("StPremiumFileSep", background, content)
end

local function harpoon_segment()
  if not has_width(145) then
    return ""
  end

  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return ""
  end

  local list = harpoon:list()
  local total = list:length()
  if total == 0 then
    return ""
  end

  local current_idx = 0
  local root = list.config and list.config:get_root_dir() or ""
  local path = buffer_path(stbufnr())

  for i = 1, total do
    local item = list:get(i)
    local value = item and item.value or nil

    if type(value) == "string" then
      local full_path = value
      if root ~= "" and not vim.startswith(value, "/") then
        full_path = root .. "/" .. value
      end

      if full_path == path then
        current_idx = i
        break
      end
    end
  end

  local label = current_idx > 0 and (current_idx .. "/" .. total) or tostring(total)
  return pill("StPremiumHarpoonSep", "StPremiumHarpoon", "%#StPremiumHarpoonIcon#󱡅 %#StPremiumHarpoonText#" .. esc(label))
end

local function git_segment(inactive)
  local buf = stbufnr()
  local git = vim.b[buf].gitsigns_status_dict

  if not git or not git.head or vim.b[buf].gitsigns_git_status then
    return ""
  end

  local branch = git.head
  branch = has_width(170) and branch or truncate_text(branch, 14)

  if inactive then
    return "%#StPremiumInactiveMeta# " .. esc(branch)
  end

  local parts = { "%#StPremiumGitBranch# " .. esc(branch) }

  if git.added and git.added > 0 then
    table.insert(parts, "%#StPremiumGitAdd#+" .. git.added)
  end

  if git.changed and git.changed > 0 then
    table.insert(parts, "%#StPremiumGitChange#~" .. git.changed)
  end

  if git.removed and git.removed > 0 then
    table.insert(parts, "%#StPremiumGitRemove#-" .. git.removed)
  end

  return pill("StPremiumGitSep", "StPremiumGit", "%@RunNeogit@" .. join(parts, " ") .. "%X")
end

local function diagnostics_segment()
  local buf = stbufnr()
  local severities = vim.diagnostic.severity
  local counts = {
    error = #vim.diagnostic.get(buf, { severity = severities.ERROR }),
    warn = #vim.diagnostic.get(buf, { severity = severities.WARN }),
    info = #vim.diagnostic.get(buf, { severity = severities.INFO }),
    hint = #vim.diagnostic.get(buf, { severity = severities.HINT }),
  }

  local parts = {}

  if counts.error > 0 then
    table.insert(parts, "%#StPremiumDiagError# " .. counts.error)
  end

  if counts.warn > 0 then
    table.insert(parts, "%#StPremiumDiagWarn# " .. counts.warn)
  end

  if counts.info > 0 and has_width(125) then
    table.insert(parts, "%#StPremiumDiagInfo#󰋼 " .. counts.info)
  end

  if counts.hint > 0 and has_width(145) then
    table.insert(parts, "%#StPremiumDiagHint#󰌶 " .. counts.hint)
  end

  if #parts == 0 then
    return ""
  end

  return pill("StPremiumDiagSep", "StPremiumDiag", join(parts, " "))
end

local function lsp_segment()
  local clients = vim.lsp.get_clients { bufnr = stbufnr() }
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "copilot" then
      table.insert(names, lsp_aliases[client.name] or client.name)
    end
  end

  if #names == 0 then
    return ""
  end

  table.sort(names)

  local label
  if has_width(165) then
    label = join(names, ", ")
  elseif has_width(120) then
    label = names[1] .. (#names > 1 and (" +" .. (#names - 1)) or "")
  else
    label = tostring(#names)
  end

  return pill("StPremiumLspSep", "StPremiumLsp", "%@LspHealthCheck@%#StPremiumLspIcon# %#StPremiumLspText#" .. esc(label) .. "%X")
end

local function line_word_count()
  local count = 0
  for _ in vim.api.nvim_get_current_line():gmatch "%w+" do
    count = count + 1
  end

  return count
end

local function writing_segment()
  local buf = stbufnr()

  if not has_width(115) or not writing_filetypes[vim.bo[buf].filetype] then
    return ""
  end

  local wordcount = vim.fn.wordcount()
  local parts = {}

  if vim.g.st_words_in_line ~= false then
    table.insert(parts, "L " .. line_word_count())
  end

  if vim.g.st_words_in_buffer then
    table.insert(parts, "W " .. tostring(wordcount.words or 0))
  end

  if #parts == 0 then
    return ""
  end

  return pill("StPremiumWriteSep", "StPremiumWrite", "%#StPremiumWriteIcon#󱀽 %#StPremiumWriteText#" .. esc(join(parts, " • ")))
end

local function metadata_segment()
  local buf = stbufnr()
  local parts = {}
  local ft = vim.bo[buf].filetype

  if ft == "" then
    ft = vim.bo[buf].buftype ~= "" and vim.bo[buf].buftype or "text"
  end

  table.insert(parts, ft)

  local encoding = vim.bo[buf].fenc ~= "" and vim.bo[buf].fenc or vim.o.enc
  local fileformat = vim.bo[buf].ff

  if has_width(160) or encoding ~= "utf-8" or fileformat ~= "unix" then
    table.insert(parts, encoding)
    table.insert(parts, fileformat)
  end

  return pill("StPremiumMetaSep", "StPremiumMeta", "%#StPremiumMetaIcon#󰈙 %#StPremiumMetaText#" .. esc(join(parts, " • ")))
end

local function position_segment(inactive)
  if inactive then
    return "%#StPremiumInactiveMeta#%l:%c %P"
  end

  local content
  if has_width(130) then
    content = "%#StPremiumPosIcon# %#StPremiumPosText#%l:%c %#StPremiumPosMeta#%P"
  else
    content = "%#StPremiumPosIcon# %#StPremiumPosText#%l:%c"
  end

  return pill("StPremiumPosSep", "StPremiumPos", content)
end

local function lsp_message_segment()
  local msg = stl.state.lsp_msg
  if msg == "" or not has_width(125) then
    return ""
  end

  local max_len = math.max(24, math.floor(winwidth() * 0.22))
  return pill("StPremiumCenterSep", "StPremiumCenter", "%#StPremiumCenterIcon#󰚩 %#StPremiumCenterText#" .. esc(truncate_text(msg, max_len)))
end

local function render_active()
  local left = {}
  local right = {}

  append(left, mode_segment())
  append(left, project_segment())

  local left_side = join(left, divider())
  local file = file_segment()
  if file ~= "" then
    if left_side ~= "" then
      left_side = left_side .. divider() .. "%<" .. file
    else
      left_side = "%<" .. file
    end
  end

  append(right, harpoon_segment())
  append(right, git_segment())
  append(right, diagnostics_segment())
  append(right, lsp_segment())
  append(right, writing_segment())
  append(right, metadata_segment())
  append(right, position_segment())

  local center = lsp_message_segment()
  local right_side = join(right, divider())

  if center ~= "" and right_side ~= "" then
    return left_side .. "%=" .. center .. "%=" .. right_side
  end

  if center ~= "" then
    return left_side .. "%=" .. center
  end

  if right_side ~= "" then
    return left_side .. "%=" .. right_side
  end

  return left_side
end

local function render_inactive()
  local left = file_segment(true)
  local right = {}

  append(right, git_segment(true))
  append(right, position_segment(true))

  return left .. "%=" .. join(right, "  ")
end

function M.render()
  ensure_highlights()

  if is_active() then
    return render_active()
  end

  return render_inactive()
end

return M
