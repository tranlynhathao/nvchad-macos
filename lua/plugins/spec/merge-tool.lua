-- TODO: Configuration for vim-mergetool plugin
-- This configuration is for the vim-mergetool plugin that helps you handle conflicts during git merges in Neovim.
-- The default key mappings from the plugin will help you easily navigate and resolve conflicts.

-- Main key mappings:
-- <leader>m - Start mergetool to handle conflicts.
-- <leader>mc - Commit the changes after resolving conflicts.
-- <leader>ms - Skip the current conflict and continue with the rest.
-- <leader>ma - Abort the conflict resolution process and return to the pre-merge state.
-- ]m - Move to the next conflict.
-- [m - Move to the previous conflict.

---@type NvPluginSpec
return {
  {
    "rhysd/vim-mergetool", -- Install the vim-mergetool plugin
    cmd = { "Mergetool" }, -- Ensure the plugin is loaded only when using the Mergetool command
    config = function()
      -- Key mappings for handling conflicts
      vim.api.nvim_set_keymap("n", "<leader>m", ":MergetoolStart<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>mc", ":MergetoolCommit<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>ms", ":MergetoolSkip<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>ma", ":MergetoolAbort<CR>", { noremap = true, silent = true })

      -- Merge view mode (3-way merge)
      vim.g.mergetool_popup = 1 -- Enable popup mode when viewing the merge
      vim.g.mergetool_layout = "diff3" -- Use diff3 layout (3-way merge)
      vim.g.mergetool_no_mappings = 0 -- Enable the default key mappings

      -- Default key mappings from the vim-mergetool plugin
      -- `]m` and `[m` to navigate through conflicts
      vim.api.nvim_set_keymap("n", "]m", ":MergetoolNext<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "[m", ":MergetoolPrev<CR>", { noremap = true, silent = true })
    end,
  },
}
