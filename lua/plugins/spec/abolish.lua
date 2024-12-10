---@type NvPluginSpec
return {
  "tpope/vim-abolish", -- Substitute plugin
  event = "BufReadPost", -- "VimEnter", "BufReadPost", "BufRead"
  config = function()
    -- Key mapping for :Subvert
    -- Allows you to substitute text globally with advanced case handling.
    vim.api.nvim_set_keymap("n", "<leader>s", ":%Subvert//g<Left><Left>", { noremap = true, silent = false })

    -- Key mapping for :Abolish
    -- Used to correct spelling or replace text patterns.
    vim.api.nvim_set_keymap("n", "<leader>c", ":Abolish ", { noremap = true, silent = false })

    -- Key mapping for case coercion (:S)
    -- Helps convert text between snake_case, camelCase, PascalCase, etc.
    vim.api.nvim_set_keymap("n", "<leader>co", ":%S/", { noremap = true, silent = false })
  end,
}
