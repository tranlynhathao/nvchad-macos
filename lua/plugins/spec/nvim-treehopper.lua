---@type NvPluginSpec

-- Select super smart text objects based on AST
-- Smart text object selection via AST
return {
  "mfussenegger/nvim-treehopper",
  keys = {
    {
      "m",
      mode = { "o", "x" },
      function()
        require("tsht").nodes()
      end,
      desc = "Treehopper select",
    },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
