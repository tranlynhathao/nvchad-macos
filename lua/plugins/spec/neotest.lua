---@type NvPluginSpec
-- neotest: unified test runner. `:Neotest run` from ANY test file - Rust,
-- Lua/plenary, Go, Python, TS/Jest, etc. Adapters below determine coverage.
-- Add more adapters as you use more languages.
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "rouge8/neotest-rust", -- Rust: cargo test
    "nvim-neotest/neotest-plenary", -- Lua plenary tests
    "nvim-neotest/neotest-go", -- Go: go test
    "nvim-neotest/neotest-python", -- Python: pytest / unittest
  },
  cmd = { "Neotest" },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test: current file" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: summary panel" },
    { "<leader>to", function() require("neotest").output.open { enter = true } end, desc = "Test: output" },
    { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Test: output panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: stop" },
    { "<leader>td", function() require("neotest").run.run { strategy = "dap" } end, desc = "Test: debug nearest" },
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-rust" { args = { "--no-capture" } },
        require "neotest-plenary",
        require "neotest-go",
        require "neotest-python" { dap = { justMyCode = false } },
      },
      output = { open_on_run = true },
      quickfix = { enabled = false },
      diagnostic = { enabled = true },
      status = { virtual_text = true, signs = true },
    }
  end,
}
