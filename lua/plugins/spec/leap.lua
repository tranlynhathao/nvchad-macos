---@type NvPluginSpec
return {
  "ggandor/leap.nvim",
  config = function()
    local leap = require "leap"

    -- Enable default key mappings:
    --  - `s`: jump within the current window
    --  - `S`: jump across all open windows
    leap.add_default_mappings()

    -- If you want to remap the keys (e.g., to `f`, `F`, and `gf`),
    -- you should disable the default mappings first.
    -- For example:
    -- leap.opts.safe_labels = {} -- disables default labels if needed
    -- vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward-to)', { desc = 'leap forward' })
    -- vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward-to)', { desc = 'leap backward' })
    -- vim.keymap.set({ 'n', 'x', 'o' }, 'gf', '<Plug>(leap-from-window)', { desc = 'leap across windows' })

    -- Show all possible matches even before you choose a label
    leap.opts.highlight_unlabeled_phase_one_targets = true
  end,
}
