local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local language_group = augroup("LanguageConfigs", { clear = true })

autocmd("FileType", {
  group = language_group,
  pattern = "angular",
  callback = function()
    require "gale.angular"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "csharp",
  callback = function()
    require "gale.csharp"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "dockerfile",
  callback = function()
    require "gale.docker"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "elixir",
  callback = function()
    require "gale.elixir"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "flutter",
  callback = function()
    require "gale.flutter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "go",
  callback = function()
    require "gale.go"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "java",
  callback = function()
    require "gale.java"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "julia",
  callback = function()
    require "gale.julia"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "jupyter",
  callback = function()
    require "gale.jupyter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "kotlin",
  callback = function()
    require "gale.kotlin"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "lua",
  callback = function()
    require "gale.lua"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "rust",
  callback = function()
    require "gale.rust"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "ruby",
  callback = function()
    require "gale.ruby"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "scala",
  callback = function()
    require "gale.scala"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "solidity",
  callback = function()
    require "gale.solidity"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "svelte",
  callback = function()
    require "gale.svelte"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "tailwind",
  callback = function()
    require "gale.tailwind"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "terraform",
  callback = function()
    require "gale.terraform"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "typescript",
  callback = function()
    require "gale.typescript"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "vue",
  callback = function()
    require "gale.vue"
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.defer_fn(function()
--       if vim.api.nvim_get_current_win() then
--         vim.cmd "ZenMode"
--       end
--     end, 100)
--   end,
-- })
