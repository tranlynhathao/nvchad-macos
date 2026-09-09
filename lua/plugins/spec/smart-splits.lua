-- smart-splits.nvim — cross-boundary pane navigation.
--
-- Unifies `<C-h/j/k/l>` navigation across Neovim splits AND tmux panes:
-- inside Neovim = `<C-w>h`; at Neovim edge with a tmux pane on the same
-- side = `tmux select-pane -L`. Also handles ghostty / wezterm / zellij.
--
-- `<A-h/j/k/l>` resizes the current split or tmux pane (matching handler
-- on the tmux side declared in docs/TMUX.md).
--
-- Terminal-mode is bound too, so navigation works from inside :terminal
-- buffers without the manual `<C-\><C-n><C-w>h` dance.

---@type NvPluginSpec
return {
  "mrjones2014/smart-splits.nvim",
  -- lazy load: `keys` below register loader stubs at startup, so first
  -- press of any of them loads the plugin. `lazy = false` here would
  -- suppress the loader stubs and leave <A-*> unbound.
  opts = {
    -- Both lists empty so <C-h/j/k/l> and <A-h/j/k/l> work in EVERY buffer,
    -- including Oil, nvim-tree, quickfix. Prior values disabled navigation
    -- from those buffers (nvim-tree has buftype="nofile", Oil has ft="oil"),
    -- meaning you were stuck inside them until you opened a real file.
    ignored_buftypes = {},
    ignored_filetypes = {},
    default_amount = 3,
    -- wrap: at outer edge, jump to opposite side (feels responsive; no silent stop).
    at_edge = "wrap",
    cursor_follows_swapped_bufs = false,
    resize_mode = { quit_key = "<Esc>", resize_keys = { "h", "j", "k", "l" } },
    log_level = "error",
  },
  keys = {
    -- Navigate
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, mode = { "n", "t" }, desc = "Move left  (split/tmux)" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, mode = { "n", "t" }, desc = "Move down  (split/tmux)" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, mode = { "n", "t" }, desc = "Move up    (split/tmux)" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "t" }, desc = "Move right (split/tmux)" },
    -- Resize
    { "<A-h>", function() require("smart-splits").resize_left() end, mode = { "n", "t" }, desc = "Resize left  (split/tmux)" },
    { "<A-j>", function() require("smart-splits").resize_down() end, mode = { "n", "t" }, desc = "Resize down  (split/tmux)" },
    { "<A-k>", function() require("smart-splits").resize_up() end, mode = { "n", "t" }, desc = "Resize up    (split/tmux)" },
    { "<A-l>", function() require("smart-splits").resize_right() end, mode = { "n", "t" }, desc = "Resize right (split/tmux)" },
  },
}
