# Complete Keymaps Reference

This document consolidates all keymaps in your Neovim configuration, organized by functional groups.

## Main Prefixes

- `<leader>` = Space (spacebar)
- `<localleader>` = Backslash (`\`) or as configured in options
- `<C-...>` = Ctrl + ...
- `<A-...>` = Alt + ...
- `<M-...>` = Meta/Alt + ...

---

## Basic Mappings (Normal, Insert, Visual, Command, Terminal)

### Normal Mode

| Keymap | Function | File |
|--------|----------|------|
| `Q` | Disable (no-op) | `configs/keymaps.lua` |
| `<c-LeftMouse>` | Go to definition (LSP) | `configs/keymaps.lua` |
| `<c-q>` | Close buffer | `configs/keymaps.lua` |
| `<esc>` | Remove search highlight | `configs/keymaps.lua` |
| `[q` | Quickfix previous | `configs/keymaps.lua` |
| `]q` | Quickfix next | `configs/keymaps.lua` |
| `gN` | Center search (previous) | `configs/keymaps.lua` |
| `n` | Center search (next) | `configs/keymaps.lua` |
| `gf` | Edit file | `configs/keymaps.lua` |
| `gl` | Open help link | `configs/keymaps.lua` |
| `z?` | Toggle spellcheck | `configs/keymaps.lua` |
| `zl` | List spelling suggestions | `configs/keymaps.lua` |
| `E` | Move to previous end of word | `mappings.lua` |
| `yw` | Yank inner word | `mappings.lua` |
| `<C-g>` | Show absolute file path | `mappings.lua` |
| `<C-w><left>` | Resize window left | `mappings.lua` |
| `<C-w><right>` | Resize window right | `mappings.lua` |
| `<C-w><up>` | Resize window up | `mappings.lua` |
| `<C-w><down>` | Resize window down | `mappings.lua` |
| `<C-a>` | Select all | `mappings.lua` |
| `<C-z>` | Scroll down and center | `mappings.lua` |
| `<C-p>` | Scroll up and center | `mappings.lua` |
| `<ESC>j` | Move line down | `mappings.lua` |
| `<ESC>k` | Move line up | `mappings.lua` |
| `<ESC>nj` | Move line/block down (with count) | `mappings.lua` |
| `<ESC>nk` | Move line/block up (with count) | `mappings.lua` |
| `U` | Redo | `mappings.lua` |
| `j` | Move down (respects wrapped lines) | `mappings.lua` |
| `k` | Move up (respects wrapped lines) | `mappings.lua` |
| `<Up>` | Move up (respects wrapped lines) | `mappings.lua` |
| `<Down>` | Move down (respects wrapped lines) | `mappings.lua` |
| `z-` | Remap z^ | `mappings.lua` |
| `g-` | Remap g; | `mappings.lua` |
| `;` | Enter command mode | `mappings.lua` |
| `<C-s>` | Save file | `mappings.lua` |
| `<C-c>` | Copy entire file content | `mappings.lua` |
| `<Esc>` | Clear search highlights | `mappings.lua` |
| `gx` | Open URL under cursor | `mappings.lua` |
| `gh` | Go to GitHub link | `mappings.lua` |
| `<Tab>` | Next buffer | `mappings.lua` |
| `<S-Tab>` | Previous buffer | `mappings.lua` |
| `<A-7>`, `<A-8>`, `<A-9>` | Go to tab 7/8/9 | `mappings.lua` |
| `<A-Left>` | Move buffer left | `mappings.lua` |
| `<A-Right>` | Move buffer right | `mappings.lua` |
| `<A-\|>` | Toggle tabufline | `mappings.lua` |

### Insert Mode

| Keymap | Function | File |
|--------|----------|------|
| `jk` | Exit insert mode | `configs/keymaps.lua`, `mappings.lua` |
| `,` | Add undo breakpoint | `configs/keymaps.lua` |
| `.` | Add undo breakpoint | `configs/keymaps.lua` |
| `;` | Add undo breakpoint | `configs/keymaps.lua` |
| `<m-->` | Insert ` <- ` (R assignment) | `configs/keymaps.lua` |
| `<m-m>` | Insert `\|>` (R pipe) | `configs/keymaps.lua` |
| `<m-i>` | Insert R code chunk | `configs/keymaps.lua` |
| `<cm-i>`, `<m-I>` | Insert Python code chunk | `configs/keymaps.lua` |
| `<c-x><c-x>` | Omnifunc completion | `configs/keymaps.lua` |
| `<C-c>` | ESC | `mappings.lua` |
| `<C-e>` | Go to end of line | `mappings.lua` |
| `<C-h>` | Go left | `mappings.lua` |
| `<C-l>` | Go right | `mappings.lua` |
| `<C-j>` | Go down | `mappings.lua` |
| `<C-k>` | Go up | `mappings.lua` |
| `<A-BS>` | Remove word | `mappings.lua` |
| `<ESC>j` | Move line down | `mappings.lua` |
| `<ESC>k` | Move line up | `mappings.lua` |
| `<A-Down>`, `<A-j>` | Move line down | `mappings.lua` |
| `<A-Up>`, `<A-k>` | Move line up | `mappings.lua` |

### Visual Mode

| Keymap | Function | File |
|--------|----------|------|
| `.` | Repeat last normal command | `configs/keymaps.lua` |
| `<M-j>` | Move line down | `configs/keymaps.lua` |
| `<M-k>` | Move line up | `configs/keymaps.lua` |
| `q` | Repeat q macro | `configs/keymaps.lua` |
| `J` | Move selection down | `helpers.lua`, `mappings.lua` |
| `K` | Move selection up | `helpers.lua`, `mappings.lua` |
| `<leader>b` | Bold text (markdown) | `mappings.lua` |
| `<leader>i` | Italic text (markdown) | `mappings.lua` |
| `<leader>u` | Underline text (markdown) | `mappings.lua` |
| `<leader>\`` | Wrap selection with code block | `mappings.lua` |
| `<leader>~` | Wrap selection with code block (with language) | `mappings.lua` |
| `<C-c>` | Send to slime | `mappings.lua` |
| `<ESC>j` | Move selection down | `mappings.lua` |
| `<ESC>k` | Move selection up | `mappings.lua` |
| `<ESC>nj` | Move selection down (with count) | `mappings.lua` |
| `<ESC>nk` | Move selection up (with count) | `mappings.lua` |
| `<A-Down>`, `<A-j>` | Move selection down | `mappings.lua` |
| `<A-Up>`, `<A-k>` | Move selection up | `mappings.lua` |
| `y` | Yank to register 6 | `mappings.lua` |
| `yy` | Yank line to register 6 | `mappings.lua` |
| `p` | Paste from register 6 | `mappings.lua` |
| `P` | Paste above from register 6 | `mappings.lua` |
| `cc` | Change line to register 6 | `mappings.lua` |
| `c` | Change selection to register 6 | `mappings.lua` |
| `d` | Delete selection to register 6 | `mappings.lua` |
| `<C-y>` | Yank to system clipboard | `mappings.lua` |
| `<C-yy>` | Yank line to system clipboard | `mappings.lua` |
| `<C-p>` | Paste from system clipboard | `mappings.lua` |
| `<C-P>` | Paste above from system clipboard | `mappings.lua` |
| `<C-d>` | Delete selection | `mappings.lua` |
| `<C-c>` | Change selection | `mappings.lua` |

### Command Mode

| Keymap | Function | File |
|--------|----------|------|
| `<C-a>` | Go to beginning of line | `configs/keymaps.lua` |

### Terminal Mode

| Keymap | Function | File |
|--------|----------|------|
| `jk` | Exit terminal mode | `mappings.lua` |
| `<C-h>` | Switch to left window | `mappings.lua` |
| `<C-j>` | Switch to down window | `mappings.lua` |
| `<C-k>` | Switch to up window | `mappings.lua` |
| `<C-l>` | Switch to right window | `mappings.lua` |
| `<C-x>` | Exit terminal mode | `mappings.lua` |

---

## Leader Keymaps (`<leader>` = Space)

### General

| Keymap | Function | File |
|--------|----------|------|
| `<leader>fm` | Format current file | `plugins/override/conform.lua` |
| `<leader>w` | Toggle wrap | `mappings.lua` |
| `<leader>n` | Toggle line number | `mappings.lua` |
| `<leader>rn` | Toggle relative number | `mappings.lua` |
| `<leader>ih` | Toggle inlay hints | `mappings.lua` |
| `<leader>ch` | Toggle nvcheatsheet | `mappings.lua` |
| `<leader>cs` | Clear statusline | `mappings.lua` |
| `<leader>cm` | Clear messages | `mappings.lua` |
| `<leader>cn` | Clear notifications | `mappings.lua` |
| `<leader><F10>` | Stop Neovim | `mappings.lua` |
| `<leader>ol` | Open file location in explorer | `mappings.lua` |
| `<leader>gm` | Go to middle of file | `mappings.lua` |
| `<leader>vt` | Show directory tree | `helpers.lua` |

### Navigation & Files

| Keymap | Function | File |
|--------|----------|------|
| `<leader>pp` | Popup 10 lines from current | `mappings.lua` |
| `<leader>ph` | Popup file header | `mappings.lua` |
| `<leader>pf` | Popup fold content | `mappings.lua` |
| `<leader>pv` | Popup visual selection | `mappings.lua` |
| `<C-b>` | Toggle NvimTree | `mappings.lua` |
| `<C-o>` | Open markdown link | `mappings.lua` |

### Code Actions

| Keymap | Function | File |
|--------|----------|------|
| `<leader>a` | Insert Python code block | `mappings.lua` |
| `<leader>j` | Insert JavaScript code block | `mappings.lua` |
| `<leader>~` | Insert code block (with language prompt) | `mappings.lua` |
| `<leader>r` | Replace text on line | `mappings.lua` |
| `<leader>R` | Replace text in file | `mappings.lua` |
| `<leader>raa` | Replace string in all project files | `mappings.lua` |
| `<leader>cf` | Format code (LSP) | `mappings.lua` |
| `<leader>ch` | Insert HTML comment (normal) / Toggle HTML comment (visual) | `mappings.lua` |
| `<leader>cp` | Insert Pug comment (normal) / Toggle Pug comment (visual) | `mappings.lua` |

### LSP (Language Server Protocol)

| Keymap | Function | File |
|--------|----------|------|
| `K` | Hover documentation | `noah/lsp.lua` |
| `gd` | Go to definition | `noah/lsp.lua` |
| `gi` | Go to implementation | `noah/lsp.lua` |
| `<leader>gd` | Go to declaration | `noah/lsp.lua` |
| `<leader>sh` | Show signature help | `noah/lsp.lua` |
| `<leader>wa` | Add workspace folder | `noah/lsp.lua` |
| `<leader>wr` | Remove workspace folder | `noah/lsp.lua` |
| `<leader>wl` | List workspace folders | `noah/lsp.lua` |
| `<leader>gr` | Show references | `noah/lsp.lua` |
| `<leader>gt` | Go to type definition | `noah/lsp.lua` |
| `<leader>ra` | Rename symbol | `noah/lsp.lua` |
| `<leader>me` | Show document symbols | `noah/lsp.lua` |
| `<leader>ds` | Diagnostic loclist | `mappings.lua` |
| `<leader>de` | Open diagnostic float | `mappings.lua`, `helpers.lua` |
| `<leader>ne` | Next error | `helpers.lua` |
| `<leader>pe` | Previous error | `helpers.lua` |
| `<leader>ce` | Copy diagnostic message | `helpers.lua` |
| `<leader>e` | Open diagnostic float | `helpers.lua` |

### Debugging (DAP)

| Keymap | Function | File |
|--------|----------|------|
| `<leader>dt` | Toggle breakpoint | `plugins/spec/dap.lua` |
| `<leader>dc` | Continue/Start debugging | `plugins/spec/dap.lua` |
| `<leader>do` | Step over | `plugins/spec/dap.lua` |
| `<leader>di` | Step into | `plugins/spec/dap.lua` |
| `<leader>du` | Step out | `plugins/spec/dap.lua` |
| `<leader>db` | Toggle breakpoint | `mappings.lua` |
| `<leader>dr` | Continue debugger | `mappings.lua` |

### Buffers & Windows

| Keymap | Function | File |
|--------|----------|------|
| `<leader>bn` | New buffer | `mappings.lua` |
| `<leader>bh` | New buffer (horizontal split) | `mappings.lua` |
| `<leader>bv` | New buffer (vertical split) | `mappings.lua` |
| `<leader>x` | Close buffer | `mappings.lua` |
| `<C-h>` | Switch to left window | `mappings.lua` |
| `<C-l>` | Switch to right window | `mappings.lua` |
| `<C-j>` | Switch to down window | `mappings.lua` |
| `<C-k>` | Switch to up window | `mappings.lua` |
| `<C-A-h>` | Increase window width | `mappings.lua` |
| `<C-A-l>` | Decrease window width | `mappings.lua` |
| `<C-A-k>` | Increase window height | `mappings.lua` |
| `<C-A-j>` | Decrease window height | `mappings.lua` |

### Terminal

| Keymap | Function | File |
|--------|----------|------|
| `<leader>v` | Toggle vertical split terminal (buffer location) | `mappings.lua` |
| `<leader>h` | Toggle horizontal split terminal (buffer location) | `mappings.lua` |
| `<leader>f` | Toggle floating terminal | `mappings.lua` |
| `<leader>T` | Toggle floating terminal | `floating_term.lua` |
| `<A-S-i>` | Toggle floating terminal (buffer location) | `mappings.lua` |

### Git

| Keymap | Function | File |
|--------|----------|------|
| `<leader>lg` | Open Lazygit | `mappings.lua` |

### Project & Build

| Keymap | Function | File |
|--------|----------|------|
| `<leader>m` | Build project (with command prompt) | `mappings.lua` |
| `<leader>cb` | Build C/C++ project | `core/project.lua` |
| `<leader>ct` | Test C/C++ project | `core/project.lua` |
| `<leader>rb` | Build Rust project | `core/project.lua` |
| `<leader>bc` | Compile Solidity | `core/project.lua` |
| `<leader>bt` | Test with Forge | `core/project.lua` |

### Treesitter

| Keymap | Function | File |
|--------|----------|------|
| `<leader>it` | Toggle inspect tree | `mappings.lua` |
| `<leader>ii` | Inspect under cursor | `mappings.lua` |

### Other

| Keymap | Function | File |
|--------|----------|------|
| `<leader>l` | Insert backlink | `mappings.lua` |
| `<leader>sn` | Search snippets | `mappings.lua` |
| `<leader>cp` | Open color picker (Minty) | `mappings.lua` |
| `<leader>th` | Open theme picker | `mappings.lua` |
| `<C-t>` | Open NvChad menu | `mappings.lua` |
| `<RightMouse>` | Open NvChad menu | `mappings.lua` |
| `<leader>oo` | Toggle Outline | `plugins/spec/outline.lua` |
| `<leader>ut` | Toggle UndoTree | `plugins/spec/undo-tree.lua` |
| `<leader>ct` | Toggle Cloak | `plugins/spec/cloak.lua` |
| `<leader>mp` | Toggle Markdown Preview | `plugins/spec/md-preview.lua` |
| `<leader>pc` | Toggle Precognition | `plugins/spec/precognition.lua` |
| `<leader>dv` | Toggle DocsView | `plugins/override/docs_view.lua` |
| `<leader>yb` | Toggle Yerbreak | `plugins/local/yerbreak.lua` |
| `<leader>jp` | Run JSPlayground | `plugins/local/js-playground.lua` |
| `<leader>jx` | Stop JSPlayground | `plugins/local/js-playground.lua` |

---

## Localleader Keymaps (`<localleader>`)

### Code / Cell / Chunk

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>cn` | New terminal with shell | `configs/keymaps.lua` |
| `<localleader>cr` | New R terminal | `configs/keymaps.lua` |
| `<localleader>cp` | New Python terminal | `configs/keymaps.lua` |
| `<localleader>ci` | New IPython terminal | `configs/keymaps.lua` |
| `<localleader>cj` | New Julia terminal | `configs/keymaps.lua` |

### Find (Telescope)

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>ff` | Find files | `configs/keymaps.lua` |
| `<localleader>fh` | Help tags | `configs/keymaps.lua` |
| `<localleader>fk` | Keymaps | `configs/keymaps.lua` |
| `<localleader>fg` | Live grep | `configs/keymaps.lua` |
| `<localleader>fb` | Buffer fuzzy find | `configs/keymaps.lua` |
| `<localleader>fm` | Marks | `configs/keymaps.lua` |
| `<localleader>fM` | Man pages | `configs/keymaps.lua` |
| `<localleader>fc` | Git commits | `configs/keymaps.lua` |
| `<localleader>f<space>` | Buffers | `configs/keymaps.lua` |
| `<localleader>fd` | Buffers | `configs/keymaps.lua` |
| `<localleader>fq` | Quickfix | `configs/keymaps.lua` |
| `<localleader>fl` | Loclist | `configs/keymaps.lua` |
| `<localleader>fj` | Jumplist | `configs/keymaps.lua` |

### Git

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>gc` | Git conflict refresh | `configs/keymaps.lua` |
| `<localleader>gs` | Git signs | `configs/keymaps.lua` |
| `<localleader>gwc` | Git worktree create | `configs/keymaps.lua` |
| `<localleader>gws` | Git worktree switch | `configs/keymaps.lua` |
| `<localleader>gdo` | Diffview open | `configs/keymaps.lua` |
| `<localleader>gdc` | Diffview close | `configs/keymaps.lua` |
| `<localleader>gbb` | Git blame toggle | `configs/keymaps.lua` |
| `<localleader>gbo` | Git blame open commit URL | `configs/keymaps.lua` |
| `<localleader>gbc` | Git blame copy commit URL | `configs/keymaps.lua` |

### Language / LSP

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>lr` | References | `configs/keymaps.lua` |
| `<localleader>R` | Rename | `configs/keymaps.lua` |
| `<localleader>lD` | Type definition | `configs/keymaps.lua` |
| `<localleader>la` | Code action | `configs/keymaps.lua` |
| `<localleader>le` | Diagnostics (show hover error) | `configs/keymaps.lua` |
| `<localleader>ldd` | Disable diagnostics | `configs/keymaps.lua` |
| `<localleader>lde` | Enable diagnostics | `configs/keymaps.lua` |
| `<localleader>lg` | Neogen docstring | `configs/keymaps.lua` |
| `<localleader>os` | Otter symbols | `configs/keymaps.lua` |

### Otter & Code

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>oa` | Otter activate | `configs/keymaps.lua` |
| `<localleader>od` | Otter deactivate | `configs/keymaps.lua` |
| `<localleader>oc` | Magic comment code chunk | `configs/keymaps.lua` |
| `<localleader>or` | R code chunk | `configs/keymaps.lua` |
| `<localleader>op` | Python code chunk | `configs/keymaps.lua` |
| `<localleader>oj` | Julia code chunk | `configs/keymaps.lua` |
| `<localleader>ob` | Bash code chunk | `configs/keymaps.lua` |
| `<localleader>oo` | Observable JS code chunk | `configs/keymaps.lua` |
| `<localleader>ol` | Lua code chunk | `configs/keymaps.lua` |

### Quarto

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>qa` | Quarto activate | `configs/keymaps.lua` |
| `<localleader>qp` | Quarto preview | `configs/keymaps.lua` |
| `<localleader>qq` | Quarto close preview | `configs/keymaps.lua` |
| `<localleader>qh` | Quarto help | `configs/keymaps.lua` |
| `<localleader>qrr` | Quarto send to cursor | `configs/keymaps.lua` |
| `<localleader>qra` | Quarto run all | `configs/keymaps.lua` |
| `<localleader>qrb` | Quarto run below | `configs/keymaps.lua` |
| `<localleader>qe` | Quarto export | `configs/keymaps.lua` |
| `<localleader>qE` | Quarto export with overwrite | `configs/keymaps.lua` |

### R Specific

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>rt` | Show R table | `configs/keymaps.lua` |

### Vim

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>vt` | Toggle light/dark theme | `configs/keymaps.lua` |
| `<localleader>vc` | Colorscheme picker | `configs/keymaps.lua` |
| `<localleader>vl` | Lazy package manager | `configs/keymaps.lua` |
| `<localleader>vm` | Mason software installer | `configs/keymaps.lua` |
| `<localleader>vs` | Edit vimrc | `configs/keymaps.lua` |
| `<localleader>vh` | Vim help for current word | `configs/keymaps.lua` |

### Execute

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>xx` | Source current file | `configs/keymaps.lua` |

### Web3 / Blockchain

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>wi` | Show project info | `configs/keymaps.lua` |
| `<localleader>wtt` | Run Foundry tests | `configs/keymaps.lua` |
| `<localleader>wtv` | Run Foundry tests (verbose) | `configs/keymaps.lua` |
| `<localleader>wth` | Run Hardhat tests | `configs/keymaps.lua` |
| `<localleader>wcf` | Compile Foundry | `configs/keymaps.lua` |
| `<localleader>wch` | Compile Hardhat | `configs/keymaps.lua` |
| `<localleader>wf` | Format with forge fmt | `configs/keymaps.lua` |

### Visual Mode (Localleader)

| Keymap | Function | File |
|--------|----------|------|
| `<localleader>p` | Replace without overwriting register | `configs/keymaps.lua` |
| `<localleader>d` | Delete without overwriting register | `configs/keymaps.lua` |

---

## Plugin-Specific Keymaps

### Rust Tools

| Keymap | Function | File | Buffer |
|--------|----------|------|--------|
| `K` | Hover actions | `plugins/spec/rust-tools.lua` | Rust files |
| `<Leader>a` | Code action group | `plugins/spec/rust-tools.lua` | Rust files |
| `<leader>r` | Rust run | `plugins/spec/rust.lua` | Rust files |
| `<leader>t` | Rust test | `plugins/spec/rust.lua` | Rust files |
| `<leader>e` | Rust expand macro | `plugins/spec/rust.lua` | Rust files |

### Go (Gopher)

| Keymap | Function | File |
|--------|----------|------|
| `<leader>gsj` | Add json struct tags | `plugins/spec/gopher.lua` |
| `<leader>gsy` | Add yaml struct tags | `plugins/spec/gopher.lua` |
| `<leader>gss` | Add sql struct tags | `plugins/spec/gopher.lua` |
| `<leader>gsv` | Add validate struct tags | `plugins/spec/gopher.lua` |
| `<leader>gst` | Add all common struct tags | `plugins/spec/gopher.lua` |
| `<leader>grj` | Remove json struct tags | `plugins/spec/gopher.lua` |
| `<leader>gry` | Remove yaml struct tags | `plugins/spec/gopher.lua` |
| `<leader>grs` | Remove sql struct tags | `plugins/spec/gopher.lua` |
| `<leader>grv` | Remove validate struct tags | `plugins/spec/gopher.lua` |

### TypeScript

| Keymap | Function | File | Buffer |
|--------|----------|------|--------|
| `<leader>lo` | Organize imports | `noah/typescript.lua` | TS/JS files |
| `<leader>lO` | Sort imports | `noah/typescript.lua` | TS/JS files |
| `<leader>lu` | Remove unused | `noah/typescript.lua` | TS/JS files |
| `<leader>lz` | Go to source definition | `noah/typescript.lua` | TS/JS files |
| `<leader>lR` | Remove unused imports | `noah/typescript.lua` | TS/JS files |
| `<leader>lF` | Fix all | `noah/typescript.lua` | TS/JS files |
| `<leader>lA` | Add missing imports | `noah/typescript.lua` | TS/JS files |

### Quarto

| Keymap | Function | File |
|--------|----------|------|
| `<leader>cm` | Mark terminal | `plugins/override/quarto.lua` |
| `<leader>cs` | Set terminal | `plugins/override/quarto.lua` |
| `<leader>ii` | Paste image from clipboard | `plugins/override/quarto.lua` |

### LSP Saga (Alternative LSP UI)

| Keymap | Function | File |
|--------|----------|------|
| `K` | Show documentation | `plugins/override/lspsaga.lua` |
| `gd` | Go to definition | `plugins/override/lspsaga.lua` |
| `gr` | Find references | `plugins/override/lspsaga.lua` |
| `ga` | Show code actions | `plugins/override/lspsaga.lua` |
| `gi` | Go to implementations | `plugins/override/lspsaga.lua` |

### NvimTree

| Keymap | Function | File | Buffer |
|--------|----------|------|--------|
| `<C-;>` | Change root to parent | `mappings.lua` | NvimTree |
| `?` | Toggle help | `mappings.lua` | NvimTree |

### Local Plugins

| Keymap | Function | File |
|--------|----------|------|
| `<leader>pp` | Toggle Popurri | `plugins/local/popurri.lua` |

---

## How to Use

1. **View all keymaps**: Press `<leader>ch` (nvcheatsheet) or `<localleader>fk` (Telescope keymaps)

2. **Search keymaps**: Use Telescope: `<localleader>fk`

3. **View which-key menu**: Press `<leader>` or `<localleader>` and wait for the menu to appear

---

## Notes

- Some keymaps only work in specific buffers (e.g., Rust, TypeScript)
- Some keymaps may be overridden by other plugins
- To see the actual keymaps in use, use `:Telescope keymaps`

---

**Note**: This document is automatically generated from config files. If you add new keymaps, please update this file.
