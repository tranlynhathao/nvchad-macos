# NvChad Neovim configuration

<p align="center">
    <!-- <img width="45%" src="https://i.imgur.com/UlaUGNg.png"> -->
    <img with="45%" src="https://i.ibb.co/xmLqQG0/Screenshot-2025-01-17-at-10-13-05.png">
    <!-- <img width="45%" src="https://i.imgur.com/ON6aN9p.jpeg"> -->
</p>
<hr>

<!-- toc -->

- [NvChad Neovim configuration](#nvchad-neovim-configuration)
  - [Features](#features)
  - [Dependencies](#dependencies)
  - [Check List](#checklist)

<!-- tocstop -->

### Features

- features [nvchad v2.5](https://nvchad.com/news/v2.5_release)
- target os: wsl2/linux/macos
- modularised setup of plugins and configurations
- scripting with bash, lua and toml as smooth as it gets
- web development with js/ts, react and astro **fully covered**
- development with rust, c and go
- git integrated using [neogit](https://github.com/neogitorg/neogit),
  [gitsigns](https://github.com/lewis6991/gitsigns.nvim),
  [diffview](https://github.com/sindrets/diffview.nvim),
  [telescope](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers)
  and [vimfugitive](https://github.com/tpope/vim-fugitive)
- [markdown preview](https://github.com/iamcco/markdown-preview.nvim) with live
  changes in browser
- round borders as a priority over sharp borders

>[!WARNING]
> **Disclaimer**: I frequently use `git rebase -i` to streamline my
> configuration. if you plan to use `lazy-lock.json` to stick with certain
> snapshots of the config, you might have a hard time due to changing commit
> hashes.

<hr>

### Dependencies

Required:

- NVIM Stable v0.10.1+ (Nightlies might work)
- NvChad v2.5
- Python 3.11.7+ & pip
- pip: `pynvim==0.4.3+`
- Node.js v22+
- npm: `neovim@4.10.1+`

Recommended:

- Cargo 1.74.1+

### Checklist

- [ ] Require plugin module
  - officer
  - savior
  - gotest
  - Auto-session
  - nvim-tree-text-objects
- [ ] Fix:
  - Format Rust, Ruby,...
  - Attempt to call local 'module' (a nil value) [issue 2](https://github.com/tranlynhathao/nvchad-macos/issues/2)
  - Change UI theme [issue 3](https://github.com/tranlynhathao/nvchad-macos/issues/3)
- [ ] Optimize plugin
- [ ] Rebuild module structure
- [ ] Add LSP
- [ ] Adjust keymaps: abolish
