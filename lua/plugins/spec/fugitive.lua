---@type NvPluginSpec
return {
  "tpope/vim-fugitive",
  event = { "CmdlineEnter", "BufReadPre" },
  dependencies = {
    "tpope/vim-rhubarb",
    "tpope/vim-obsession",
    "tpope/vim-unimpaired",
    "sindrets/diffview.nvim",
  },
  config = function()
    -- Keybindings for Fugitive and Git
    vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true }) -- Open Git status
    vim.api.nvim_set_keymap("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true }) -- Diff view
    vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true }) -- Git blame
    vim.api.nvim_set_keymap("n", "<leader>gl", ":Glog<CR>", { noremap = true, silent = true }) -- Git log
    vim.api.nvim_set_keymap("n", "<leader>gc", ":DiffviewOpen<CR>", { noremap = true, silent = true }) -- Open Diffview for commit/branch
  end,
}
