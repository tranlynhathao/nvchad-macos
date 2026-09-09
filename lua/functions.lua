-- ~/.config/nvim/lua/functions.lua

-- Function to insert backlink in markdown
function InsertBackLink()
  local backlink_text = vim.fn.input "Backlink Text: "
  local backlink_url = vim.fn.input "Backlink URL: "
  vim.api.nvim_put({ "[" .. backlink_text .. "](" .. backlink_url .. ")" }, "c", true, true)
end

-- Kept for backwards compatibility with the <C-o> mapping in mappings.lua.
-- Delegates to the single authoritative resolver in noah/markdown_open.lua so
-- inline links, autolinks, bare URLs and trailing-punctuation handling all
-- behave identically to the buffer-local `gx` on Markdown filetypes.
function OpenMarkdownLink() require("noah.markdown_open").open() end

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
