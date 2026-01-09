return {
  dev = {
    path = "/home/noah/workspace/neovim/",
    fallback = true,
  },
  change_detection = {
    notify = false,
  },
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },
  -- Git configuration to handle fetch failures better
  git = {
    -- Increase timeout for slow networks (in seconds)
    timeout = 300, -- 5 minutes (default is 120)
    -- Explicitly set git executable path
    cmd = "/opt/homebrew/bin/git",
    -- Reduce concurrent git operations to avoid spawning too many processes
    cooldown = 1000, -- milliseconds between operations
  },
  concurrency = 5, -- Limit concurrent operations (default is 50)
  ui = {
    border = "rounded",
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
