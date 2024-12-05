-- ~/.config/nvim/lua/functions.lua

-- Function to insert backlink in markdown
function InsertBackLink()
  local backlink_text = vim.fn.input "Backlink Text: "
  local backlink_url = vim.fn.input "Backlink URL: "
  vim.api.nvim_put({ "[" .. backlink_text .. "](" .. backlink_url .. ")" }, "c", true, true)
end

-- Function to open markdown link
function OpenMarkdownLink()
  local line = vim.api.nvim_get_current_line()
  local path = string.match(line, "%]%((.-)%)")
  if path then
    vim.cmd("edit " .. path)
  else
    print "No markdown link found on this line"
  end
end

-- Function to toggle wrap for markdown
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
