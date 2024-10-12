---@type NvPluginSpec
return {
  "jupyter-vim/jupyter-vim",
  config = function()
    vim.api.nvim_set_keymap("n", "<leader>jc", ":JupyterSendCell<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<leader>js", ":JupyterSendRange<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>jk", ":JupyterConnect<CR>", { noremap = true, silent = true })

    -- <leader>jc: send code block (in normal mode)
    -- <leader>js: send code block (in visual mode)
    -- <leader>jk: connect to a kernel
  end,
}
