# Git Workflow

This Neovim config uses a small Git stack with clear roles:

- `gitsigns.nvim`: inline hunk navigation, staging, reset, blame, and diff.
- `neogit`: repository status, commit, branch, merge, pull/push, and rebase UI.
- `diffview.nvim`: visual diff review, repository history, file history, and merge context.
- `git-conflict.nvim`: in-buffer conflict detection and fast conflict resolution.
- `telescope.nvim`: fast Git pickers for status, branches, commits, file commits, and stash.
- `vim-fugitive`: command fallback for raw `:Git` workflows when needed.

## Primary Keymaps

### Repository workflow

- `<leader>gg`: open Neogit status in a split
- `<leader>gc`: open Neogit commit popup
- `<leader>gM`: open Neogit merge popup
- `<leader>gR`: open Neogit rebase popup
- `<leader>gp`: open Neogit pull popup
- `<leader>gP`: open Neogit push popup

### Diff and history

- `<leader>gv`: open Diffview against local changes (`--imply-local`)
- `<leader>gV`: close Diffview
- `<leader>gl`: repository history in Diffview
- `<leader>gf`: current-file history in Diffview

### Telescope Git pickers

- `<leader>ge`: Git status picker
- `<leader>gb`: branch picker
- `<leader>gC`: repository commit picker
- `<leader>gB`: current-file commit picker
- `<leader>gS`: stash picker

### Hunk workflow

- `]h` / `[h`: next / previous hunk
- `<leader>ghs`: stage hunk
- `<leader>ghr`: reset hunk
- `<leader>ghu`: undo staged hunk
- `<leader>ghS`: stage buffer
- `<leader>ghU`: unstage buffer
- `<leader>ghR`: reset buffer
- `<leader>ghp`: preview hunk
- `<leader>ghd`: diff current buffer
- `<leader>ghD`: diff against previous revision
- `<leader>ghb`: blame line
- `<leader>ght`: toggle current-line blame
- `<leader>ghx`: toggle deleted lines

Visual mode:

- `<leader>ghs`: stage selected hunk range
- `<leader>ghr`: reset selected hunk range

## Merge Conflict Workflow

When a file has conflict markers, `git-conflict.nvim` highlights each side and the config adds direct conflict actions that work immediately on the current buffer markers.

### Fast navigation

- `]x` / `[x`: next / previous conflict
- `<leader>gmn` / `<leader>gmp`: next / previous conflict
- `<leader>gml`: send all conflicts in the current repo to quickfix

### Choose a side

- `co`: choose ours
- `ct`: choose theirs
- `cb`: choose both
- `c0`: choose none

Leader alternatives:

- `<leader>gmo`: choose ours
- `<leader>gmt`: choose theirs
- `<leader>gmb`: choose both
- `<leader>gm0`: choose none
- `<leader>gmr`: refresh conflict detection

### Visual merge review

1. Open the conflicted file.
2. Use `]x` / `[x` to move conflict-to-conflict.
3. Resolve straightforward conflicts with `co`, `ct`, `cb`, or `c0`.
4. If the conflict needs more context, open `<leader>gv` for Diffview.
5. In Diffview, use the file panel to inspect conflicted files and apply whole-file conflict actions:
   - `<leader>gmo`: choose ours for the file
   - `<leader>gmt`: choose theirs for the file
   - `<leader>gm0`: choose none for the file
   - `<leader>gma`: choose all versions for the file
6. Stage resolved hunks or files with the `gh` mappings or directly from Diffview / Neogit.
7. Finish in Neogit with `<leader>gg` and commit with `<leader>gc`.

## Practical Daily Flow

### Review what changed

- Use `<leader>ge` for a quick picker view of changed files.
- Use `<leader>gg` for the full status UI.
- Use `<leader>ghp` to preview a hunk before staging it.

### Stage and commit

1. Stage hunks with `<leader>ghs` or buffers with `<leader>ghS`.
2. Open `<leader>gc` for the commit popup.
3. Use Neogit’s staged diff preview while composing the commit message.

### Review history

- `<leader>gl`: repo history with visual diff review
- `<leader>gf`: current-file history
- `<leader>gC`: quick commit picker
- `<leader>gB`: quick current-file commit picker

### Raw Git fallback

If you want direct fugitive commands, they are still available:

- `:Git`
- `:Gdiffsplit`
- `:Gvdiffsplit`
- `:GBrowse`
