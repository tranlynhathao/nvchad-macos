# NvChad Neovim configuration

<p align="center"><img src="https://private-user-images.githubusercontent.com/118340413/375195973-49afb142-a9b3-41aa-979e-9cdfefe52350.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Mjg3MzgzMjIsIm5iZiI6MTcyODczODAyMiwicGF0aCI6Ii8xMTgzNDA0MTMvMzc1MTk1OTczLTQ5YWZiMTQyLWE5YjMtNDFhYS05NzllLTljZGZlZmU1MjM1MC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQxMDEyJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MTAxMlQxMzAwMjJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yZTAwZDY5ZjI4MmRjMTI3MjBhOWJmNTFhYzFiYmVmNzMyMzhmNTk2MzQwMTgwYjg3MGZiNTYzNzE4NDcxZGY2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.JobYqv7PiMCY2to2zeCSHhFTlIjHY3gK9IJxZ-Zqd0k"></p>
<hr>

### Features

- Features [NvChad v2.5](https://nvchad.com/news/v2.5_release)
- Target OS: WSL2/Linux/macOS
- Modularised setup of plugins and configurations
- Scripting with Bash, Lua and Toml as smooth as it gets
- Web development with JS/TS, React and Astro **fully covered**
- Development with Rust, C and Go
- Git integrated using [Neogit](https://github.com/NeogitOrg/neogit),
  [Gitsigns](https://github.com/lewis6991/gitsigns.nvim),
  [DiffView](https://github.com/sindrets/diffview.nvim),
  [Telescope](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#git-pickers)
  and [VimFugitive](https://github.com/tpope/vim-fugitive)
- [Markdown Preview](https://github.com/iamcco/markdown-preview.nvim) with live
  changes in browser
- Round borders as a priority over sharp borders

<!-- >[!TIP] -->
<!-- > Pair with <a href="https://github.com/mgastonportillo/wezterm-config"> my -->
<!-- > Wezterm configuration</a> for a smoother experience -->
<!---->
<!-- >[!WARNING] > **Disclaimer**: I frequently use `git rebase -i` to streamline my -->
<!-- > configuration. if you plan to use `lazy-lock.json` to stick with certain -->
<!-- > snapshots of the config, you might have a hard time due to changing commit -->
<!-- > hashes. -->

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
