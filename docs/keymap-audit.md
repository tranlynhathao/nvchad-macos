# Neovim Keymap Audit

**Config root:** `/Users/tranlynhathao/.config/nvim`
**Neovim version:** 0.11.6
**Audit date:** 2026-03-31

---

## Quick Reference: `<leader>f` Conflict (Why This Audit Was Done)

| Key | Action | File | Status |
|-----|--------|------|--------|
| `<leader>f` | Float terminal toggle (n,t) | `lua/mappings.lua:736` | **REMOVED** — was shadowing Telescope prefix |
| `<leader>f*` | Telescope pickers (20+ bindings) | `lua/plugins/override/telescope.lua` | Active |
| `<A-i>` | Float terminal toggle (n,t) | NvChad built-in defaults | Active — **is the replacement** |

---

## How Neovim Resolves `<leader>f` Ambiguity

With `timeoutlen=300` (set in `init.lua:108`):

| What you type | What happens |
|--------------|-------------|
| `<leader>f` + wait 300ms | Float terminal fires (from `<leader>f` mapping) |
| `<leader>ff` (fast) | Telescope find_files |
| `<leader>fw` | Telescope live grep |
| `<leader>fs` | Telescope grep word |
| `<leader>fb` | Telescope buffers |
| Any `<leader>f<X>` fast | Corresponding Telescope picker |

**The problem:** Every Telescope `<leader>f*` invocation requires Neovim to first check if there is a longer sequence. The bare `<leader>f` terminal binding forces a 300ms pause on every `<leader>ff`, `<leader>fw`, etc. to resolve disambiguation. Additionally, `<leader>f` and `<leader>ft` both exist independently, which-key cannot show the `<leader>f` group cleanly.

**Resolution:** Remove `<leader>f` → terminal. Use `<A-i>` (NvChad built-in, same function, same target: `id = "floatTerm"`).

---

## Complete Keymap Inventory

### Layer 1: Core Config (`lua/mappings.lua`)

#### Editor motions

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `E` | `ge` | ~19 | Move to prev word-end |
| n | `yw` | `yiw` | ~20 | Yank inner word |
| n | `U` | `<C-r>` | ~21 | Redo |
| n | `;` | `:` | ~23 | Enter command mode |
| n | `z-` | `z^` | ~24 | Remap z^ |
| n | `g-` | `g;` | ~25 | Remap g; |
| n | `<C-s>` | `:w` | ~26 | Save (normal) |
| i | `<C-s>` | `:w` | ~27 | Save (insert) |
| n | `<C-c>` | `:%y+` | ~28 | Copy whole file |
| n | `<Esc>` | `:noh` | ~29 | Clear search highlight |
| i | `jk` | `<ESC>` | ~31 | Exit insert |
| t | `jk` | `<C-\><C-n>` | ~111 | Exit terminal mode |
| t | `<C-h>` | `<C-\><C-n><C-w>h` | ~112 | Terminal → left window |
| t | `<C-j>` | `<C-\><C-n><C-w>j` | ~113 | Terminal → down window |
| t | `<C-k>` | `<C-\><C-n><C-w>k` | ~114 | Terminal → up window |
| t | `<C-l>` | `<C-\><C-n><C-w>l` | ~115 | Terminal → right window |
| i | `,` | `,<c-g>u` | ~119 | Undo breakpoint |
| i | `.` | `.<c-g>u` | ~120 | Undo breakpoint |
| i | `;` | `;<c-g>u` | ~121 | Undo breakpoint |

#### Register / yank / paste overrides

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n,v | `y` | `"6ygv<Esc>` | ~340 | Yank to reg 6 |
| n | `Y` | `"6y$` | ~341 | Yank EOL to reg 6 |
| n,v | `yy` | `"6yy` | ~342 | Yank line to reg 6 |
| n,v | `p` | `"6p` | ~343 | Paste from reg 6 |
| n,v | `P` | `"6P` | ~344 | Paste above reg 6 |
| n | `x` | `"6x` | ~345 | Delete char to reg 6 |
| n | `cc` | `"6cc` | ~347 | Change line to reg 6 |
| v | `c` | `"6c` | ~348 | Change selection reg 6 |
| v | `d` | `"6d` | ~393 | Delete selection reg 6 |
| n,v | `<C-y>` | `"+ygv<Esc>` | ~357 | Yank to system clipboard |
| n | `<c-y>` | `"+y$` | ~358 | Yank EOL to clipboard |
| n,v | `<C-yy>` | `"+yy` | ~359 | Yank line to clipboard |
| n,v | `<C-p>` | `"+p` | ~360 | Paste from clipboard |
| n,v | `<C-P>` | `"+P` | ~361 | Paste above from clipboard |
| n | `<C-x>` | `"6x` | ~362 | Delete char |
| n | `<C-D>` | `dd` | ~363 | Delete line |
| v | `<C-d>` | `d` | ~364 | Delete selection |
| n | `<C-C>` | `cc` | ~365 | Change line |
| v | `<C-c>` | `c` | ~366 | Change selection |

#### Motion / wrap-aware

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `j` | expr: `gj` or `j` | ~396 | Wrap-aware down |
| n | `k` | expr: `gk` or `k` | ~397 | Wrap-aware up |
| n | `<Up>` | expr: `gk` | ~398 | Wrap-aware up |
| n | `<Down>` | expr: `gj` | ~399 | Wrap-aware down |
| i | `<C-e>` | `<End>` | ~403 | End of line |
| i | `<C-h>` | `<Left>` | ~404 | Left |
| i | `<C-l>` | `<Right>` | ~405 | Right |
| i | `<C-j>` | `<Down>` | ~406 | Down |
| i | `<C-k>` | `<Up>` | ~407 | Up |

#### Move line/block

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `<ESC>j` | `:m .+1` | ~144 | Move line down |
| n | `<ESC>k` | `:m .-2` | ~145 | Move line up |
| i | `<ESC>j` | `<Esc>:m .+1==gi` | ~148 | Move line down (insert) |
| i | `<ESC>k` | `<Esc>:m .-2==gi` | ~149 | Move line up (insert) |
| v | `<ESC>j` | `:move '>+1<CR>gv` | ~150 | Move selection down |
| v | `<ESC>k` | `:move '<-2<CR>gv` | ~151 | Move selection up |
| n | `<A-Down>` | `:m .+1` | 411 | Move line down |
| n | `<A-j>` | `:m .+1` | 412 | Move line down |
| n | `<A-Up>` | `:m .-2` | 413 | Move line up |
| n | `<A-k>` | `:m .-2` | 414 | Move line up |
| i | `<A-Down>` | `<Esc>:m .+1==gi` | 415 | Move line down (insert) |
| i | `<A-j>` | `<Esc>:m .+1==gi` | 416 | Move line down (insert) |
| i | `<A-Up>` | `<Esc>:m .-2==gi` | 417 | Move line up (insert) |
| i | `<A-k>` | `<Esc>:m .-2==gi` | 418 | Move line up (insert) |
| v | `<A-Down>` | `:m '>+1<CR>gv=gv` | 419 | Move selection down |
| v | `<A-j>` | `:m '>+1<CR>gv=gv` | 420 | Move selection down |
| v | `<A-Up>` | `:m '<-2<CR>gv=gv` | 421 | Move selection up |
| v | `<A-k>` | `:m '<-2<CR>gv=gv` | 422 | Move selection up |

#### Window / buffer navigation

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `<C-h>` | `<C-w>h` | ~424 | Switch window left |
| n | `<C-l>` | `<C-w>l` | ~425 | Switch window right |
| n | `<C-j>` | `<C-w>j` | ~426 | Switch window down |
| n | `<C-k>` | `<C-w>k` | ~427 | Switch window up |
| n | `<C-A-h>` | `11<C-w>>` | ~430 | Resize width +11 |
| n | `<C-A-l>` | `11<C-w><` | ~431 | Resize width -11 |
| n | `<C-A-k>` | `11<C-w>+` | ~432 | Resize height +11 |
| n | `<C-A-j>` | `11<C-w>-` | ~433 | Resize height -11 |
| n | `<C-w><left>` | `<C-w><` | ~445 | Resize left |
| n | `<C-w><right>` | `<C-w>>` | ~446 | Resize right |
| n | `<C-w><up>` | `<C-w>+` | ~447 | Resize up |
| n | `<C-w><down>` | `<C-w>-` | ~448 | Resize down |
| n | `<C-a>` | `gg<S-v>G` | ~450 | Select all |
| n | `<C-z>` | `<C-d>zz` | ~451 | Scroll down |
| n | `<Tab>` | `tabufline.next()` | ~761 | Next buffer |
| n | `<S-Tab>` | `tabufline.prev()` | ~762 | Prev buffer |
| n | `<leader>x` | `tabufline.close_buffer()` | ~763 | Close buffer |
| n | `<leader>bn` | `:enew` | ~769 | New buffer |
| n | `<leader>bh` | `:split \| enew` | ~770 | New buffer (hsplit) |
| n | `<leader>bv` | `:vsplit \| enew` | ~771 | New buffer (vsplit) |
| n | `<A-7>` | `7gt` | ~775 | Go to tab 7 |
| n | `<A-8>` | `8gt` | ~776 | Go to tab 8 |
| n | `<A-9>` | `9gt` | ~777 | Go to tab 9 |
| n | `<A-Left>` | `tabufline.move_buf(5)` | ~779 | Move buffer left |
| n | `<A-Right>` | `tabufline.move_buf(7)` | ~780 | Move buffer right |
| n | `<A-\|>` | `:TabuflineToggle` | ~781 | Toggle tabufline |

#### Terminal

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| t | `<C-x>` | `<C-\><C-N>` | 703 | Escape terminal mode |
| n,t | `<leader>v` | Float term in buf dir (vsp) | 709 | Vertical split terminal |
| n,t | `<leader>h` | Float term in buf dir (sp) | 722 | Horizontal split terminal |
| ~~n,t~~ | ~~`<leader>f`~~ | ~~Float terminal toggle~~ | ~~731~~ | **REMOVED** (was conflict) |
| n,t | `<A-S-i>` | Float terminal at buf location | 743 | Float terminal (alt) |

#### Misc leader

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `<leader>l` | `InsertBackLink()` | 333 | Insert backlink (Obsidian) |
| n | `<leader>lg` | `:LazyGit` | 336 | Open Lazygit |
| n | `<leader>m` | Build project | ~305 | Build/make |
| n | `<leader>a` | Insert python block | ~255 | Insert code block |
| n | `<leader>j` | Insert js block | ~264 | Insert JS code block |
| x | `` <leader>` `` | Wrap with ` ``` ` | 272 | Wrap in code block |
| n,x | `<leader>~` | Wrap in ` ```lang ` | 283,298 | Wrap with lang code block |
| v | `<leader>b` | `c**<C-r>"**` | ~315 | Bold text |
| v | `<leader>i` | `c*<C-r>"*` | ~316 | Italic text |
| v | `<leader>u` | Underline | ~317 | Underline text |
| n | `<leader>n` | `:set nu!` | 656 | Toggle line numbers |
| n | `<leader>rn` | `:set rnu!` | 657 | Toggle relative numbers |
| n | `<leader>ih` | `:ToggleInlayHints` | ~660 | Toggle inlay hints |
| n | `<leader>ch` | `:NvCheatsheet` | 659 | Toggle cheatsheet |
| n | `<leader>ds` | `vim.diagnostic.setloclist` | 662 | Diagnostic loclist |
| n | `<leader>de` | `vim.diagnostic.open_float` | 663 | Diagnostic float |
| n | `[d` | `vim.diagnostic.goto_prev` | ~665 | Prev diagnostic |
| n | `]d` | `vim.diagnostic.goto_next` | ~666 | Next diagnostic |
| n | `[e` | goto_prev error | ~667 | Prev error |
| n | `]e` | goto_next error | ~668 | Next error |
| n | `[w` | goto_prev warning | ~669 | Prev warning |
| n | `]w` | goto_next warning | ~670 | Next warning |
| n | `<leader>th` | Theme picker | 687 | NvChad theme picker |
| n,v | `<C-t>` | `require("menu").open()` | ~694 | NvChad context menu |
| n,v | `<RightMouse>` | `require("menu").open()` | ~695 | Right-click menu |
| n,v | `<leader>it` | `toggle_inspect_tree()` | 752 | TreeSitter inspect tree |
| n | `<leader>ii` | `:Inspect` | 756 | TreeSitter inspect cursor |
| n | `<C-g>` | `vim.notify(expand("%:p"))` | ~460 | Show file path |
| n | `<leader>w` | `ToggleWrap()` | ~310 | Toggle word wrap |
| n | `<leader>ol` | `vim.ui.open()` | ~330 | Open file location |
| n | `<leader>sn` | `:Telescope scissors` | 71 | Search snippets |
| n | `<leader>cf` | `vim.lsp.buf.format()` | 107 | Format file (LSP) |
| n | `<leader>r` | `ReplaceCurrentLine()` | ~440 | Replace on line |
| n | `<leader>R` | `ReplaceInFile()` | ~441 | Replace in file |
| v | `<leader>r` | `ReplaceInSelection()` | ~442 | Replace in selection |
| n | `<leader>raa` | Replace in project | ~443 | Replace all in project |
| n | `<leader>pp` | popup 10 lines | ~250 | Popup context |
| n | `<leader>ph` | popup file header | ~251 | Popup header |
| n | `<leader>pf` | popup fold | ~252 | Popup fold |
| v | `<leader>pv` | popup visual | ~253 | Popup selection |
| n | `<leader>db` | `:DapToggleBreakpoint` | 68 | DAP breakpoint |
| n | `<C-b>` | `:NvimTreeToggle` | ~100 | Toggle nvim-tree |
| c | `<C-a>` | `<Home>` | ~122 | Command: go to start |
| i | `<C-c>` | `<ESC>` | ~130 | Exit insert mode |
| n | `gh` | `go_to_github_link()` | ~790 | Open GitHub link |

---

### Layer 2: `lua/helpers.lua`

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n | `<leader>ce` | Copy diagnostic message | 2 | Copies diag to `+` reg |
| n | `<leader>ne` | `vim.diagnostic.goto_next` | 14 | Next error |
| n | `<leader>pe` | `vim.diagnostic.goto_prev` | 15 | Prev error |
| v | `J` | `:m '>+1<CR>gv=gv` | 17 | Move block down |
| v | `K` | `:m '<-2<CR>gv=gv` | 18 | Move block up |
| n | `<leader>e` | `vim.diagnostic.open_float` | 20 | Diagnostic float |
| n | `<leader>vt` | `:ShowTree` | 186 | Directory tree popup |

---

### Layer 3: `lua/floating_term.lua`

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| n,t | `<leader>T` | `toggle_term()` | 40 | Custom floating term (separate impl) |

---

### Layer 4: `lua/configs/keymaps.lua` (which-key + direct)

#### Direct mappings

| Mode | LHS | RHS | Line | Notes |
|------|-----|-----|------|-------|
| c | `<C-a>` | `<Home>` | ~10 | Command home |
| i | `jk` | `<esc>` | ~15 | Exit insert |
| i | `,` | `,<c-g>u` | ~18 | Undo breakpoint |
| i | `.` | `.<c-g>u` | ~19 | Undo breakpoint |
| i | `;` | `;<c-g>u` | ~20 | Undo breakpoint |
| n | `Q` | `<Nop>` | ~22 | Disable Q |
| n | `<c-LeftMouse>` | `vim.lsp.buf.definition()` | ~115 | Click → definition |
| n | `<c-q>` | `:q` | ~116 | Close buffer |
| n | `<esc>` | `:noh` | ~117 | Clear search highlight |
| n | `[q` | `:cprev` | ~122 | Quickfix prev |
| n | `]q` | `:cnext` | ~123 | Quickfix next |
| n | `gN` | `Nzzzv` | ~124 | Centered search prev |
| n | `gf` | `:e <cfile>` | ~125 | Edit file under cursor |
| n | `gl` | `<c-]>` | ~126 | Open help link |
| n | `n` | `nzzzv` | ~127 | Centered search next |
| n | `z?` | `:setlocal spell!` | ~128 | Toggle spellcheck |
| n | `zl` | `:Telescope spell_suggest` | ~129 | Spell suggestions |
| n | `<localleader>os` | `get_otter_symbols_lang()` | ~195 | Otter symbols |
| v | `.` | `:norm .<cr>` | ~183 | Repeat last normal cmd |
| v | `<M-j>` | `:m'>+<cr>` | ~184 | Move line down |
| v | `<M-k>` | `:m'<-2<cr>` | ~185 | Move line up |
| v | `q` | `:norm @q<cr>` | ~186 | Run @q macro |
| i | `<m-->` | ` <- ` | ~198 | R assign operator |
| i | `<m-m>` | `\|>` | ~199 | R pipe |

#### which-key groups (`<localleader>` namespace)

| Group key | Description |
|-----------|-------------|
| `<localleader>c` | Code/cell/chunk |
| `<localleader>e` | Edit |
| `<localleader>d` | Debug |
| `<localleader>f` | Find (Telescope) |
| `<localleader>g` | Git |
| `<localleader>h` | Help/hide |
| `<localleader>i` | Image |
| `<localleader>l` | Language/LSP |
| `<localleader>o` | Otter & code |
| `<localleader>q` | Quarto |
| `<localleader>r` | R-specific tools |
| `<localleader>t` | Treesitter |
| `<localleader>v` | Vim |
| `<localleader>w` | Web3 / blockchain |
| `<localleader>x` | Execute |

#### Key `<localleader>f` Telescope sub-mappings

| Key | Action |
|-----|--------|
| `<localleader>ff` | `Telescope find_files` |
| `<localleader>fh` | `Telescope help_tags` |
| `<localleader>fk` | `Telescope keymaps` |
| `<localleader>fg` | `Telescope live_grep` |
| `<localleader>fb` | `Telescope current_buffer_fuzzy_find` |
| `<localleader>fm` | `Telescope marks` |
| `<localleader>fM` | `Telescope man_pages` |
| `<localleader>fc` | `Telescope git_commits` |
| `<localleader>f<space>` | `Telescope buffers` |
| `<localleader>fd` | `Telescope buffers` |
| `<localleader>fq` | `Telescope quickfix` |
| `<localleader>fl` | `Telescope loclist` |
| `<localleader>fj` | `Telescope jumplist` |

---

### Layer 5: `lua/noah/lsp.lua` (`on_attach` — buffer-local)

Applied when an LSP server attaches to a buffer.

| Mode | LHS | RHS | Notes |
|------|-----|-----|-------|
| n | `K` | `vim.lsp.buf.hover` | Buffer-local |
| n | `gd` | `vim.lsp.buf.definition` | Buffer-local |
| n | `gi` | `vim.lsp.buf.implementation` | Buffer-local |
| n | `<leader>gd` | `vim.lsp.buf.declaration` | Buffer-local |
| n | `<leader>sh` | `vim.lsp.buf.signature_help` | Buffer-local |
| n | `<leader>wa` | `vim.lsp.buf.add_workspace_folder` | Buffer-local |
| n | `<leader>wr` | `vim.lsp.buf.remove_workspace_folder` | Buffer-local |
| n | `<leader>gr` | `vim.lsp.buf.references` | Buffer-local |
| n | `<leader>gt` | `vim.lsp.buf.type_definition` | Buffer-local |
| n | `<leader>wl` | List workspace folders | Buffer-local |
| n | `<leader>ra` | `nvchad.lsp.renamer()` | Buffer-local |
| n | `<leader>me` | `Telescope lsp_document_symbols` | Buffer-local |

---

### Layer 6: `lua/plugins/override/telescope.lua`

#### `<leader>f` Telescope namespace

| Mode | LHS | Action | Notes |
|------|-----|--------|-------|
| n | `<leader>fa` | All files (hidden+ignored) | Custom pickers wrapper |
| n | `<leader>ff` | Find files | Custom pickers wrapper |
| n | `<leader>fo` | Recent files | Custom pickers wrapper |
| n | `<leader>fw` | Live grep | Custom pickers wrapper |
| n | `<leader>fs` | Grep word under cursor | Custom pickers wrapper |
| v | `<leader>fs` | Grep visual selection | Custom pickers wrapper |
| n | `<leader>fb` | Open buffers | Custom pickers wrapper |
| n | `<leader>fc` | Current buffer fuzzy find | Builtin direct |
| n | `<leader>f.` | Resume last search | Builtin direct |
| n | `<leader>fj` | Jumplist | Builtin (ivy theme) |
| n | `<leader>fq` | Quickfix | Builtin direct |
| n | `<leader>fl` | Location list | Builtin direct |
| n | `<leader>fR` | Registers | Builtin (dropdown theme) |
| n | `<leader>f:` | Command history | Builtin (dropdown theme) |
| n | `<leader>f?` | Help tags | Builtin direct |
| n | `<leader>fk` | Keymaps | Builtin (ivy theme) |
| n | `<leader>fp` | All pickers / builtin | Builtin direct |
| n | `<leader>ft` | Terms | NvChad extension |
| n | `<leader>fh` | Highlights | Builtin direct |
| n | `<leader>fr` | LSP references | Builtin direct |
| n | `<leader>fd` | Diagnostics | Builtin (ivy theme) |
| n | `<leader>fS` | Workspace symbols | Builtin direct |

#### Other namespaces in telescope.lua

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>th` | Themes (NvChad extension) |
| n | `<leader>ma` | Marks |
| n | `<leader>ts` | Treesitter |
| n | `<leader>gs` | Git status (dropdown) |
| n | `<leader>gcm` | Git commits |
| n | `<leader>gb` | Git branches (dropdown) |
| n | `<leader>gB` | Git buffer commits |
| n | `<leader>gh` | GitHub issues (ext: not installed) |
| n | `<leader>gp` | GitHub PRs (ext: not installed) |

#### In-picker mappings (defaults merged)

| Mode | LHS | Action |
|------|-----|--------|
| i,n | `<C-j>` | Move selection next |
| i,n | `<C-k>` | Move selection prev |
| i,n | `<C-h>` | Toggle preview |
| i,n | `<C-l>` | Toggle preview |
| i,n | `<F1>` | Toggle preview |
| i,n | `<C-d>` | Preview scroll down |
| i,n | `<C-u>` | Preview scroll up |
| i,n | `<C-g>` | Notify full path |
| n | `q` | Close (NvChad built-in) |

---

### Layer 7: Plugin Specs

#### `plugins/override/nvim-tree.lua`

**Global (init):**

| Mode | LHS | Action |
|------|-----|--------|
| n | `<C-b>` | `:NvimTreeToggle` |

**Buffer-local (custom_on_attach):**

| Mode | LHS | Action |
|------|-----|--------|
| n | `<C-k>` | File info popup (noah.fileinfo) |
| n | `+` | CD to node |
| n | `?` | Toggle help |
| n | `<ESC>` | Close tree |
| n | `d` | Delete file |
| n | `r` | Rename file |
| n | `y` | Copy file |
| n | `a` | Create file |

#### `plugins/override/toggleterm.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>tt` | `:ToggleTerm` |

#### `plugins/override/lspsaga.lua`

| Mode | LHS | Action | Notes |
|------|-----|--------|-------|
| n | `K` | `:Lspsaga hover_doc` | Overrides LSP K |
| n | `gd` | `:Lspsaga goto_definition` | Overrides LSP gd |
| n | `gr` | `:Lspsaga lsp_finder` | Overrides LSP gr |
| n | `ga` | `:Lspsaga code_action` | |
| n | `gi` | `:Lspsaga implementations` | |

#### `plugins/override/conform.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>fm` | Format with conform |

#### `plugins/override/whichkey.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>wK` | `:WhichKey` |
| n | `<leader>wk` | WhichKey query |

#### `plugins/spec/gitsigns.lua` (on_attach, buffer-local)

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>td` | Toggle deleted hunks |
| n | Various `]h`, `[h` | Next/prev hunk |

#### `plugins/spec/neoterm.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>ts` | `:Tsend` (send codeblock) |
| v | `<leader>ts` | `:TsendVisual` |
| n | `<leader>tr` | `:Treset` |
| n | `<leader>tq` | `:Tclose` |

#### `plugins/spec/multicursor.lua`

| Mode | LHS | Action |
|------|-----|--------|
| v | `<leader>t` | Transpose cursors (visual only) |

#### `plugins/spec/rust.lua` (on_attach, buffer-local)

| Mode | LHS | Action |
|------|-----|--------|
| n | `gd` | `vim.lsp.buf.definition` |
| n | `K` | `vim.lsp.buf.hover` |
| n | `<leader>r` | `:RustRun` |
| n | `<leader>t` | `:RustTest` (BUFFER-LOCAL) |
| n | `<leader>e` | `:RustExpandMacro` |

#### `plugins/spec/gopher.lua` (Go struct tags)

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>gsj` | Add json tags |
| n | `<leader>gsy` | Add yaml tags |
| n | `<leader>gss` | Add sql tags |
| n | `<leader>gsv` | Add validate tags |
| n | `<leader>gst` | Add all tags |
| n | `<leader>grj` | Remove json tags |
| n | `<leader>gry` | Remove yaml tags |
| n | `<leader>grs` | Remove sql tags |
| n | `<leader>grv` | Remove validate tags |

#### `plugins/spec/surround.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `ys` | Add surround (normal) |
| n | `yss` | Add surround (line) |
| n | `ds` | Delete surround |
| n | `cs` | Change surround |
| x | `<leader>sr` | Surround visual |
| x | `gS` | Surround visual line |

#### `plugins/spec/treesitter-textobjects.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n,x,o | `;` | Repeat last treesitter move |
| n,x,o | `,` | Repeat opposite |
| n,x,o | `f` | Forward to char |
| n,x,o | `F` | Backward to char |
| n,x,o | `t` | To char |
| n,x,o | `T` | Backward to char |

#### `plugins/spec/smoothie.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<C-u>` | Smooth page up |
| n | `<C-f>` | Smooth page down |
| n | `<C-kk>` | Full page up |
| n | `<C-jj>` | Full page down |

#### `plugins/spec/fugitive.lua`

| Mode | LHS | Action | Conflict |
|------|-----|--------|---------|
| n | `<leader>gs` | `:Git` | ⚠️ Shadows Telescope `<leader>gs` |
| n | `<leader>gd` | `:Gdiffsplit` | ⚠️ Shadows LSP declaration |
| n | `<leader>gb` | `:Git blame` | ⚠️ Shadows Telescope `<leader>gb` |
| n | `<leader>gl` | `:Glog` | |
| n | `<leader>gc` | `:DiffviewOpen` | |

#### `plugins/spec/harpoon.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<A-t>` | Harpoon → buffer 5 |
| n | `<A-y>` | Harpoon → buffer 6 |
| n | (others) | Harpoon navigation |

#### `plugins/spec/conflict-marker.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `]c` | Next conflict marker |
| n | `[c` | Prev conflict marker |
| v | `<leader>cs` | Select conflict side |
| n | `<leader>cx` | Clear conflict markers |

#### `plugins/spec/undo-tree.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>ut` | `:UndotreeToggle` |

#### `plugins/spec/cloak.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>ct` | `:CloakToggle` |

#### `plugins/spec/crates.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>cu` | Update crate |

#### `plugins/spec/md-preview.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>mp` | `:MarkdownPreviewToggle` |

#### `plugins/spec/dap-python.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>pdr` | DAP Python run |

#### `plugins/spec/nvim-dap-go.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>dgt` | DAP Go test function |
| n | `<leader>dgl` | DAP Go test latest |

#### `plugins/spec/jupyter.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>jc` | Send cell to Jupyter |
| v | `<leader>js` | Send range to Jupyter |
| n | `<leader>jk` | Connect to Jupyter |

#### `plugins/spec/precognition.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>pc` | `:Precognition toggle` |

#### `plugins/override/gotest.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<Space>tf` | Go test function |
| n | `<Space>tm` | Go test module |

#### `plugins/override/docs_view.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>dv` | `:DocsViewToggle` |

#### `plugins/override/quarto.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>cm` | Mark terminal |
| n | `<leader>cs` | Set terminal |
| n | `<leader>ii` | `:PasteImage` |

#### `plugins/spec/abolish.lua`

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>s` | `:%Subvert//g` |
| n | `<leader>c` | `:Abolish` |

#### `plugins/spec/dap.lua` (DAP debugger)

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>dt` | Toggle breakpoint |
| n | `<leader>dc` | Continue |
| n | `<leader>do` | Step over |
| n | `<leader>di` | Step into |
| n | `<leader>du` | Step out |

#### `noah/csharp.lua` (on_attach, buffer-local)

| Mode | LHS | Action |
|------|-----|--------|
| n | `<leader>td` | Neotest debug file |
| n | `<leader>tL` | Neotest run last |
| n | `<leader>tN` | Neotest run nearest |

---

### Layer 8: NvChad Built-in Defaults (`NvChad/lua/nvchad/mappings.lua`)

| Mode | LHS | Action |
|------|-----|--------|
| n,t | `<A-i>` | **Float terminal toggle** (same as removed `<leader>f`) |
| n | `<leader>fw` | `Telescope live_grep` (overridden by user) |
| n | `<leader>fb` | `Telescope buffers` (overridden by user) |
| n | `<leader>fh` | `Telescope help_tags` (overridden by user) |
| n | `<leader>fo` | `Telescope oldfiles` (overridden by user) |
| n | `<leader>fz` | `Telescope current_buffer_fuzzy_find` |
| n | `<leader>ma` | `Telescope marks` (overridden by user) |
| n | `<leader>ff` | `Telescope find_files` (overridden by user) |
| n | `<leader>fa` | `Telescope find all files` (overridden by user) |
| n | `<leader>cm` | `Telescope git_commits` |
| n | `<leader>gt` | `Telescope git_status` (overridden by user's `<leader>gs`) |
| n | `<leader>pt` | `Telescope terms` |
| n | `<leader>wK` | `:WhichKey` |
| n | `<leader>e` | `nvim-tree focus` |
| n | `<leader>n` | `:set nu!` |
| n | `<leader>rn` | `:set rnu!` |
| n | `<C-n>` | `nvim-tree toggle` |

---

## Conflict Analysis

### Confirmed Conflicts

| Key | Binding 1 | Binding 2 | Winner | Severity |
|-----|-----------|-----------|--------|----------|
| `<leader>f` | Float terminal (global, n+t) | Prefix for 20+ Telescope (global) | Both coexist via timeout | **HIGH — FIXED** |
| `<leader>gs` | Telescope git_status (telescope.lua) | `fugitive.git` (fugitive.lua) | Telescope wins (loads last) | Medium |
| `<leader>gb` | Telescope git_branches (telescope.lua) | `:Git blame` (fugitive.lua) | Telescope wins (loads last) | Medium |
| `<leader>gd` | LSP declaration (noah/lsp.lua, buf-local) | `:Gdiffsplit` (fugitive.lua, global) | buf-local wins in LSP bufs | Low |
| `<leader>ts` | Treesitter picker (telescope.lua) | Neoterm send (neoterm.lua) | Last-loaded wins | Low |
| `<leader>td` | Gitsigns toggle deleted (buf-local) | Neotest debug (csharp, buf-local) | Scope-specific, no real conflict | Low |
| `<leader>t` (v) | Multicursor transpose (multicursor) | (nothing else in v mode) | Only visual mode | Info |
| `<leader>t` (n) | RustTest (rust.lua, buf-local) | (nothing else globally in n) | buf-local only, fine | Info |
| `K` (global) | `vim.lsp.buf.hover` (noah/lsp) | `:Lspsaga hover_doc` (lspsaga) | lspsaga if both load | Medium |
| `gd` (global) | `vim.lsp.buf.definition` (noah/lsp) | `:Lspsaga goto_definition` (lspsaga) | lspsaga if both load | Medium |
| `<C-h>` (i) | Go left in insert | Telescope toggle preview (inside picker) | Context-specific, fine | Info |
| `<leader>ii` | TreeSitter inspect | `:PasteImage` (quarto.lua) | Last-loaded wins | Low |
| `<leader>cm` | Git commits (NvChad default) | Quarto mark terminal (quarto.lua) | Last-loaded wins | Low |

### Suspicious / Dead Mappings

| Key | Issue |
|-----|-------|
| `<leader>gh`, `<leader>gp` | telescope-github.nvim not installed — silently fails |
| `<leader>fr` (line 79, old file) | Was dead frecency binding before audit cleanup |
| `<localleader>fd` and `<localleader>f<space>` | Both map to `Telescope buffers` (duplicate in keymaps.lua) |
| `<C-p>` | Defined twice: scroll up (vim scroll) and paste from clipboard — last definition wins |
| `jk` | Defined in both `mappings.lua:31` and `configs/keymaps.lua:15` — harmless duplicate |
| `<Space>tf`, `<Space>tm` | gotest.lua uses `<Space>` not `<leader>` — may not do what's intended |
| `telescope-lsp-docs.nvim` | Defines `K` and `gd` — but it's commented out in init.lua, so inactive |

---

## Summary of the `<leader>f` Problem (Resolved)

**Before this audit fix:**

```
<leader>f      → nvchad.term.toggle { pos = "float" }  (mappings.lua:736)
<leader>f + ?  → 20+ Telescope pickers               (telescope.lua)
```

With `timeoutlen=300`:

- Every `<leader>ff`, `<leader>fw`, etc. had an implicit 300ms wait for Neovim to rule out the bare `<leader>f` terminal trigger
- Pressing `<leader>f` alone always waited 300ms before opening the terminal
- which-key could not show a clean `<leader>f` group because the key had a dual role

**After this audit fix:**

```
<leader>f      → (freed — no binding)
<leader>f*     → 20+ Telescope pickers (clean, no disambiguation needed)
<A-i>          → Float terminal toggle (NvChad built-in — was already present)
```

`<A-i>` is the NvChad-idiomatic key for the float terminal. It was already defined by NvChad's default mappings.lua and pointing to the exact same `id = "floatTerm"` — the user's `<leader>f` was always a redundant override.

---

## Files Changed in This Audit Pass

1. **`lua/mappings.lua`** — Removed `<leader>f` → float terminal (lines 731–741)

---

## Suggested Future Cleanup (Not Done in This Pass)

1. **fugitive conflicts**: `<leader>gs`, `<leader>gb` conflict with Telescope git pickers. Remap fugitive to `<leader>Gs`, `<leader>Gb`, or disable if Telescope git pickers cover the same need.
2. **lspsaga vs noah/lsp.lua**: Both define `K` and `gd`. Decide on one source of truth for these keys.
3. **`<leader>ts` conflict**: Telescope treesitter vs neoterm send. Pick one.
4. **`<localleader>fd` duplicate**: Maps to `Telescope buffers` twice in keymaps.lua.
5. **`<Space>tf`, `<Space>tm`** in gotest.lua: Uses `<Space>` literal instead of `<leader>`. May not work as expected if leader is not space (it is, but fragile).
6. **telescope-github.nvim**: Install it or remove `<leader>gh`, `<leader>gp` bindings.
7. **`<C-p>` conflict**: Appears as both scroll-up and clipboard-paste — last-defined wins, meaning clipboard paste.
