---@type NvPluginSpec
return {
  "psliwka/vim-smoothie",
  event = "WinScrolled",
  config = function()
    vim.g.smoothie_default_duration = 200 -- (ms)
    vim.g.smoothie_default_easing = "cubic" -- or linear, quadratic, sinusoidal, exponential, circular, elastic, back, bounce

    local opts = { noremap = true, silent = true }
    -- scroll up
    vim.api.nvim_set_keymap("n", "<C-u>", "<Plug>(SmoothieUpwards)", opts) -- 1/2 page
    vim.api.nvim_set_keymap("n", "<C-kk>", "<Plug>(SmoothiePageUp)", opts) -- 1

    -- scroll down
    vim.api.nvim_set_keymap("n", "<C-f>", "<Plug>(SmoothieDownwards)", opts) -- 1/2 page
    vim.api.nvim_set_keymap("n", "<C-jj>", "<Plug>(SmoothiePageDown)", opts) -- 1 page
  end,
}
