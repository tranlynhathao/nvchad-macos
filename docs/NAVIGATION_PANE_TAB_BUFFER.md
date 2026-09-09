# Navigation: Buffer / Window (pane) / Tab

Navigating many files in one terminal — the Vim model differs from VSCode-style editors.

## Project workflow

`Space fe` browses files recursively from the current project, including from Oil, nvim-tree or MiniFiles. It starts with an empty query in Normal mode: browse relative paths with `j/k` and read the preview before opening a file. No filename is required. Press `i` to filter by a fragment such as `plugins/` when useful.

| Inside `Space fe`                  | Action                                                                 |
| ---------------------------------- | ---------------------------------------------------------------------- |
| `j/k`, `PageDown/PageUp`           | Browse results                                                         |
| `s` in Normal / `Ctrl-s` in Insert | Show Flash labels; type a label to select that row, then Enter to open |
| `Ctrl-d/u`                         | Scroll preview                                                         |
| `Enter`                            | Open selected file                                                     |
| `Ctrl-v/x/t`                       | Open in vertical split / horizontal split / tab                        |
| `Tab`                              | Mark files                                                             |
| `Ctrl-q`                           | Send marked files (or all results if none marked) to quickfix          |
| `Esc` in Normal mode               | Close picker                                                           |

Git/ignore rules are respected; `.git`, `.backups` and `.ruff_cache` are excluded. `Space fa` remains the explicit hidden/ignored-file finder. The browser does not change cwd or the explorer root. Flash labels also work in other Telescope result lists; FFF keeps its existing `Ctrl-s` split mapping.

FFF (`Space ff/fw/fz`), project browsing (`Space fe`), tracked files (`Space fg`), Git changes (`Space ge`), MiniFiles and sessions share one root resolver: current file/explorer context → nearest Git root → language/project marker → current window cwd. A file outside cwd falls back to its own directory. A Git worktree's `.git` file is supported. `Space fE` explicitly browses cwd instead; project-switching pickers pass their selected directory to FFF.

For a task spanning several files, open each useful file and press `Alt-a` to pin it with Harpoon. `Alt-q/w/e/r/t/y` jumps to slots 1–6; `Alt-m` shows the editable list; `Alt-d` unpins the current file. Keep cwd at the project root because the existing Harpoon lists are keyed by cwd.

Use `Space fb` for open buffers, `Space fo` for recent files in this project, `Space fO` for recent files across all projects, and `Space ge` for Git changes. After `gd` or another jump, `Ctrl-o` goes back and `Ctrl-i` goes forward. Markdown links use `gx`.

In nvim-tree, `E` expands the tree, `W` collapses it, and `f` starts its live filter (`F` clears it). Use expansion on a manageable subtree/project; a huge fully expanded tree is still expensive to browse.

### Column browsing with MiniFiles

`Space E` opens at the current file/directory. Parent, current directory and preview stay adjacent where space permits; narrow terminals show fewer columns. Oil remains the default directory explorer.

| Inside MiniFiles    | Action                                   |
| ------------------- | ---------------------------------------- |
| `j/k`, `h/l`        | Choose entry, go out/in                  |
| `Enter`             | Open file and close explorer             |
| `'p` / `'w`         | Jump to project root / cwd bookmark      |
| `Ctrl-v` / `Ctrl-x` | Open file in vertical / horizontal split |
| `Ctrl-k`            | File info                                |
| `q` / `Esc`         | Close                                    |
| `g?`                | Local help                               |

Create, rename and delete by editing the listing as a normal buffer, then press `=` and confirm. Deleted entries go to MiniFiles' trash, not permanent deletion. Preview/navigation do not themselves change files.

### Project sessions

| Key        | Command        | Action                                                          |
| ---------- | -------------- | --------------------------------------------------------------- |
| `Space Qs` | `:SessionSave` | Save current project's files, tabs, splits and cursor positions |
| `Space Ql` | `:SessionLoad` | Restore this project's saved session                            |
| `Space Qp` | `:SessionPick` | Choose another saved project session                            |
| `Space Qd` | `:SessionStop` | Stop exit autosave; keep saved sessions                         |

Sessions use the already-installed `mini.sessions` and live in `stdpath("state")/project-sessions`, outside Git. Save/load opts into exit autosave for that project; switching to another project does not overwrite the old session. Startup never restores a session automatically. Unsaved buffers block restore; sessions do not save unsaved file contents, running processes, or picker popups.

Projections remains available at `Space fV` for registered workspaces, without competing automatic session hooks. `Space fp` is still Telescope's list of pickers. Existing Projections session files are untouched.

## Model

| Concept           | What it really is                     | Notes                                                     |
| ----------------- | ------------------------------------- | --------------------------------------------------------- |
| **Buffer**        | In-memory contents of one loaded file | Exists independently, needs no window to survive          |
| **Window (pane)** | A viewport onto one buffer            | Many windows can view the same buffer                     |
| **Tab**           | A layout of windows                   | NOT a "file tab" like VSCode — used for different layouts |

Principle: closing a window ≠ closing a buffer; switching tabs ≠ switching files.

---

## Buffer

### Built-in commands

| Command                | What it does                                                  |
| ---------------------- | ------------------------------------------------------------- |
| `:e <file>`            | Open a file (as a buffer + show it in the current window)     |
| `:ls` / `:buffers`     | List the current buffers                                      |
| `:b <name>` / `:b <n>` | Switch to a buffer by name or number                          |
| `:bn` / `:bp`          | Next / previous buffer                                        |
| `:bd`                  | Close the current buffer (the window stays)                   |
| `:bd!`                 | Close, discarding any unsaved changes                         |
| `<C-^>`                | Quickly switch between the current and alternate buffer (`#`) |

### Custom keymaps

| Keymap       | Function                      | File                             |
| ------------ | ----------------------------- | -------------------------------- |
| `<leader>bn` | New empty buffer              | `mappings.lua:797`               |
| `<leader>bh` | New buffer + horizontal split | `mappings.lua:798`               |
| `<leader>bv` | New buffer + vertical split   | `mappings.lua:799`               |
| `<C-q>`      | Close buffer                  | `configs/keymaps.lua`            |
| `<leader>fb` | Fuzzy pick buffer (Telescope) | `plugins/override/telescope.lua` |

---

## Window (pane)

### Create a split

| Command                      | What it does                             |
| ---------------------------- | ---------------------------------------- |
| `:sp` / `<C-w>s`             | Horizontal split (new window below)      |
| `:vsp` / `<C-w>v`            | Vertical split (new window to the right) |
| `:sp <file>` / `:vsp <file>` | Split then open another file             |
| `<C-w>n`                     | Horizontal split + new empty buffer      |

### Move between windows

| Keymap              | Function                    | File               |
| ------------------- | --------------------------- | ------------------ |
| `<C-h>`             | Go to the left window       | `mappings.lua:490` |
| `<C-j>`             | Go to the window below      | `mappings.lua:492` |
| `<C-k>`             | Go to the window above      | `mappings.lua:493` |
| `<C-l>`             | Go to the right window      | `mappings.lua:491` |
| `<C-w>w`            | Cycle to the next window    | built-in           |
| `<C-w>p`            | Back to the last window     | built-in           |
| `<C-w>t` / `<C-w>b` | Jump to first / last window | built-in           |

### Resize

| Keymap                      | Function                         | File                            |
| --------------------------- | -------------------------------- | ------------------------------- |
| `<C-A-h>`                   | Widen by 11 columns              | `mappings.lua:496`              |
| `<C-A-l>`                   | Narrow by 11 columns             | `mappings.lua:497`              |
| `<C-A-k>`                   | Taller by 11 rows                | `mappings.lua:498`              |
| `<C-A-j>`                   | Shorter by 11 rows               | `mappings.lua:499`              |
| `<C-w><left/right/up/down>` | Resize by 1 unit                 | `mappings.lua:216-219`          |
| `<C-w>=`                    | Balance all windows              | built-in                        |
| `<C-w>_`                    | Max height of the current window | built-in                        |
| `` <C-w>                    | ``                               | Max width of the current window | built-in |

### Rearrange (move a window)

| Command  | What it does                                              |
| -------- | --------------------------------------------------------- |
| `<C-w>H` | Move the current window to the **far left** (as a column) |
| `<C-w>J` | Move it to the **very bottom** (as a row)                 |
| `<C-w>K` | Move it up                                                |
| `<C-w>L` | Move it right                                             |
| `<C-w>r` | Rotate positions within the same row/column               |
| `<C-w>x` | Swap with the next window                                 |
| `<C-w>T` | Turn the current window into a **new tab**                |

### Close

| Command            | What it does                                   |
| ------------------ | ---------------------------------------------- |
| `:q` / `<C-w>q`    | Close the window (the buffer stays)            |
| `:only` / `<C-w>o` | Close every other window, keep the current one |
| `:hide`            | Hide the window (buffer untouched)             |

---

## Tab (layout)

| Command          | What it does             |
| ---------------- | ------------------------ |
| `:tabnew`        | New tab, empty buffer    |
| `:tabnew <file>` | New tab with a file      |
| `:tabclose`      | Close the current tab    |
| `:tabonly`       | Close every other tab    |
| `gt`             | Next tab                 |
| `gT`             | Previous tab             |
| `<n>gt`          | Jump to tab number `<n>` |
| `:tabmove <n>`   | Reorder the tab          |

Use tabs when you need a **completely different layout** (e.g. tab 1 = code + tests, tab 2 = docs + terminal). Don't use tabs as "file tabs".

---

## Terminal mode (while inside `:terminal`)

If terminal mode swallows every key, these custom keymaps escape it first, then switch window:

| Keymap       | Function                                 | File               |
| ------------ | ---------------------------------------- | ------------------ |
| `<C-h>`      | Leave terminal -> left window            | `mappings.lua:195` |
| `<C-j>`      | Leave terminal -> window below           | `mappings.lua:196` |
| `<C-k>`      | Leave terminal -> window above           | `mappings.lua:197` |
| `<C-l>`      | Leave terminal -> right window           | `mappings.lua:198` |
| `<C-\><C-n>` | Leave terminal mode -> normal (built-in) | —                  |
| `<leader>tf` | Floating terminal                        | `mappings.lua:770` |

---

## Workflow patterns

### Code + test side-by-side

```
:e src/module.lua
:vsp tests/module_spec.lua
<C-h> / <C-l>                # jump back and forth
```

### 3-pane (code / test / terminal)

```
:e src/foo.lua
<C-w>v                        # 2 columns
<C-l>                         # go to the right column
:e tests/foo_spec.lua
<C-w>s                        # split the right column horizontally
<leader>tf                    # floating terminal to run commands
```

### Many buffers, one window (recommended)

Split only when you need to **see two files at once**. Otherwise use buffers + `<leader>fb` to switch quickly — it saves screen space for code.

### Tabs for a different context

- Tab 1: developing feature A (2-3 panes)
- Tab 2: reading docs / debugging feature B
- `gt` switches context, the layout stays put

---

## The 5 commands to memorize

1. `<C-w>v` — vertical split
2. `<C-h>` / `<C-l>` — switch pane left/right
3. `:bd` — close a buffer, keep the window
4. `<C-w>=` — rebalance the layout when it gets skewed
5. `<C-w>o` — close every other pane, focus on one

---

## Cross-references

- Full keymaps for the config: `docs/KEYMAPS_REFERENCE.md`
- Custom window mappings: `lua/mappings.lua:485-500`
- Custom terminal mappings: `lua/mappings.lua:190-200`
- Custom buffer mappings: `lua/mappings.lua:795-800`
