---@type NvPluginSpec
return {
  "machakann/vim-sandwich", -- Sandwich plugin
  event = "BufReadPost", -- "VimEnter", "BufReadPost", "BufRead"
  config = function()
    -- vim-sandwich doesn't require specific configuration.
    -- However, if you want to customize key mappings or add more functionality, you can modify it.
    vim.g.sandwich_no_default_key_mappings = 1 -- Option: disable default key mappings if you want to define your own.

    -- Example: reassign key mappings if needed.
    vim.api.nvim_set_keymap("n", "saw", "<Plug>(operator-sandwich-add)iw", {})
    vim.api.nvim_set_keymap("n", "sdw", "<Plug>(operator-sandwich-delete)iw", {})
    vim.api.nvim_set_keymap("n", "srw", "<Plug>(operator-sandwich-replace)iw", {})
  end,
}
