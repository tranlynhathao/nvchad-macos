---@type NvPluginSpec
return {
  "kassio/neoterm",
  config = function()
    vim.g.neoterm_default_mod = "vertical"
    vim.g.neoterm_autoscroll = 1

    vim.api.nvim_set_keymap("n", "<leader>ts", ":Tsend<CR>", { noremap = true, silent = true }) -- send codeblock
    vim.api.nvim_set_keymap("v", "<leader>ts", ":TsendVisual<CR>", { noremap = true, silent = true }) -- send selected codeblock
    vim.api.nvim_set_keymap("n", "<leader>tr", ":Treset<CR>", { noremap = true, silent = true }) -- Reset terminal
    vim.api.nvim_set_keymap("n", "<leader>tq", ":Tclose<CR>", { noremap = true, silent = true }) -- close terminal
  end,
}
