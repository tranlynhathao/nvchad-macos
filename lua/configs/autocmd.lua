local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local language_group = augroup("LanguageConfigs", { clear = true })

autocmd("FileType", {
  group = language_group,
  pattern = "angular",
  callback = function()
    require "vincent.angular"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "csharp",
  callback = function()
    require "vincent.csharp"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "dockerfile",
  callback = function()
    require "vincent.docker"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "elixir",
  callback = function()
    require "vincent.elixir"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "flutter",
  callback = function()
    require "vincent.flutter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "go",
  callback = function()
    require "vincent.go"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "java",
  callback = function()
    require "vincent.java"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "julia",
  callback = function()
    require "vincent.julia"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "jupyter",
  callback = function()
    require "vincent.jupyter"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "kotlin",
  callback = function()
    require "vincent.kotlin"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "lua",
  callback = function()
    require "vincent.lua"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "rust",
  callback = function()
    require "vincent.rust"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "ruby",
  callback = function()
    require "vincent.ruby"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "scala",
  callback = function()
    require "vincent.scala"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "solidity",
  callback = function()
    require "vincent.solidity"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "svelte",
  callback = function()
    require "vincent.svelte"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "tailwind",
  callback = function()
    require "vincent.tailwind"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "terraform",
  callback = function()
    require "vincent.terraform"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "typescript",
  callback = function()
    require "vincent.typescript"
  end,
})

autocmd("FileType", {
  group = language_group,
  pattern = "vue",
  callback = function()
    require "vincent.vue"
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
