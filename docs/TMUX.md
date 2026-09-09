# tmux ↔ Neovim integration

Deep, safe integration via [`mrjones2014/smart-splits.nvim`]. Zero data
mutation, zero global side effects — only key handling on both sides.

## What you get

| Key                                   | In Neovim                               | At Neovim edge                           |
| ------------------------------------- | --------------------------------------- | ---------------------------------------- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move cursor between splits              | Move focus to the tmux pane on that side |
| `<A-h>` / `<A-j>` / `<A-k>` / `<A-l>` | Resize the current split by 3 rows/cols | Resize the tmux pane in that direction   |

Terminal mode included — no more `<C-\><C-n><C-w>h` dance from inside a
`:terminal` buffer.

## Neovim side (already installed)

- Spec: `lua/plugins/spec/smart-splits.lua`
- Old manual `<C-h/j/k/l>` bindings in `mappings.lua` are commented out
  (see the `smart-splits` note near lines 205 and 550).

## tmux side — add to `~/.config/tmux/tmux.conf`

Append this block. It detects when the active pane is running Neovim (or
any process matching `[Vv]im`) and forwards the key across. Otherwise it
falls back to native tmux `select-pane` / `resize-pane`.

```tmux
# ── smart-splits: unified nav/resize with Neovim ─────────────────────────

# Detect whether the current pane is running Vim/Neovim.
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

# Navigate: Ctrl-h/j/k/l
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

# Same, but from copy-mode too (so navigation works when scrolling).
bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R

# Resize: Alt-h/j/k/l
bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'

bind-key -T copy-mode-vi 'M-h' resize-pane -L 3
bind-key -T copy-mode-vi 'M-j' resize-pane -D 3
bind-key -T copy-mode-vi 'M-k' resize-pane -U 3
bind-key -T copy-mode-vi 'M-l' resize-pane -R 3
```

Reload tmux config:

```
tmux source-file ~/.config/tmux/tmux.conf
```

or `<prefix> r` if you have that bound.

## Verifying end-to-end

1. Start tmux, split a pane: `<prefix> "` (horizontal) or `<prefix> %`
   (vertical).
2. In one pane run `nvim`, in the other keep a shell.
3. From inside nvim, press `<C-h>` at the left-most split — focus jumps to
   the shell pane. Press `<C-l>` back — focus returns to nvim.
4. `<A-l>` inside nvim grows the current split; at the right edge it
   grows the nvim tmux pane by pushing the neighbour.

## Ghostty note

Ghostty passes `<C-h/j/k/l>` and `<A-h/j/k/l>` through to tmux without
intercepting on macOS with default settings — no Ghostty config change
needed for this integration. If you also want Ghostty-native pane nav (no
tmux), don't bind these globally in Ghostty — let tmux own them.

## Related in this config (not tmux-specific but adjacent)

- `<leader>fH` — SSH host picker → new tab terminal with `ssh <host>`
- `<leader>fZ` — Zoxide dir jump + FFF
- `toggleterm.nvim` — floating Neovim-internal terminal
- `noah/oil_git_agg.lua` — Oil directory Git aggregation
