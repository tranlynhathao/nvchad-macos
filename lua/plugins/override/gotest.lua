---@type NvPluginSpec
return {
  "cademichael/gotest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- defaults
    vim.g.gotest = {
      test_cmd = "go test -run ",
      preview_cutoff = 0,
      preview_width = 0.67,
    }
    local goTest = require "gotest"
    vim.keymap.set("n", "<Space>tf", goTest.goFuncTester)
    vim.keymap.set("n", "<Space>tm", goTest.goModTester)
  end,
}
