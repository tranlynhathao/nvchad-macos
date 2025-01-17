vim.keymap.set("n", "<leader>ce", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 })
  if #diagnostics > 0 then
    local message = diagnostics[1].message
    vim.fn.setreg("+", message)
    print("Copied diagnostics: " .. message)
  else
    print "No diagnostics at cursor"
  end
end, { noremap = true, silent = true })

-- go to errors in a file
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
