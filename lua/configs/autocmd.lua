local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local language_group = augroup("LanguageConfigs", { clear = true })

autocmd("FileType", {
  group = language_group,
  pattern = "angular",
  callback = function()
    require "noah.angular"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "csharp",
  callback = function()
    require "noah.csharp"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "dockerfile",
  callback = function()
    require "noah.docker"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "elixir",
  callback = function()
    require "noah.elixir"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "flutter",
  callback = function()
    require "noah.flutter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "go",
  callback = function()
    require "noah.go"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "java",
  callback = function()
    require "noah.java"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "julia",
  callback = function()
    require "noah.julia"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "jupyter",
  callback = function()
    require "noah.jupyter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "kotlin",
  callback = function()
    require "noah.kotlin"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "lua",
  callback = function()
    require "noah.lua"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "rust",
  callback = function()
    require "noah.rust"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "ruby",
  callback = function()
    require "noah.ruby"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "scala",
  callback = function()
    require "noah.scala"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "solidity",
  callback = function()
    require "noah.solidity"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "svelte",
  callback = function()
    require "noah.svelte"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "tailwind",
  callback = function()
    require "noah.tailwind"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "terraform",
  callback = function()
    require "noah.terraform"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "typescript",
  callback = function()
    require "noah.typescript"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "vue",
  callback = function()
    require "noah.vue"
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
