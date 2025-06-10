local M = {}

local comment_prefix = {
  html = "<!-- ",
  pug = "//- ",
}

local comment_suffix = {
  html = " -->",
  pug = "",
}

local function toggle_pug_comment(ft)
  local prefix = comment_prefix[ft]
  local suffix = comment_suffix[ft]

  if not prefix then
    print("Unsupported filetype: " .. ft)
    return
  end

  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    print "Visual mode only"
    return
  end

  local _, start_line, _, _ = unpack(vim.fn.getpos "'<")
  local _, end_line, _, _ = unpack(vim.fn.getpos "'>")

  for line = start_line, end_line do
    local content = vim.fn.getline(line)
    if vim.startswith(content, prefix) then
      content = content:gsub(vim.pesc(prefix), "", 1)
      if suffix ~= "" then
        content = content:gsub(vim.pesc(suffix) .. "$", "", 1)
      end
    else
      content = prefix .. content .. suffix
    end
    vim.fn.setline(line, content)
  end
end

M.toggle_pug_comment = toggle_pug_comment
return M
