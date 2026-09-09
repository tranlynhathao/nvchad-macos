-- mapleader / maplocalleader are set at the very top of init.lua so lazy.setup
-- below sees the intended values (avoids the "set BEFORE loading lazy" warning).
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- Install lazy if not in path
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
  vim.cmd "autocmd User LazyDone lua require('nvchad.mason').install_all()"
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"
require("lazy").setup({
  { import = "noah.wezterm" },
  { import = "noah.types" },
  {
    "NvChad/NvChad",
    dev = false,
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- Load themes
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

-- NvChad disables remote providers in options.lua, which loads after this file.
-- Re-enable discovery at VimEnter without eagerly sourcing either provider.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.g.loaded_python3_provider = nil
    vim.g.loaded_node_provider = nil
  end,
})
