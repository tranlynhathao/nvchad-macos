local M = {}

-- Reload lua on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    local file = vim.fn.expand "%:p"
    local size = vim.fn.getfsize(file)
    vim.notify(string.format("File saved: %s (%.2f KB)", file, size / 1024))
  end,
})

-- Cursor highlight settings
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.cmd [[
  highlight Cursor guibg=#ffcc00 guifg=black
  highlight lCursor guibg=#ffcc00 guifg=black
]]

return M
