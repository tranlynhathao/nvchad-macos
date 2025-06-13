---@type NvPluginSpec
return {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("dap-go").setup()

    vim.keymap.set("n", "<leader>dgt", function()
      require("dap-go").debug_test()
    end, { desc = "Debug go test" })

    vim.keymap.set("n", "<leader>dgl", function()
      require("dap-go").debug_last()
    end, { desc = "Debug last go test" })
  end,
}
