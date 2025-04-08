---@type NvPluginSpec
return {
  "GCBallesteros/NotebookNavigator.nvim",
  keys = {
    {
      "]h",
      function()
        require("notebook-navigator").move_cell "d"
      end,
    },
    {
      "[h",
      function()
        require("notebook-navigator").move_cell "u"
      end,
    },
    { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
    { "<leader><leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
  },
  dependencies = {
    "echasnovski/mini.comment",
    "hkupty/iron.nvim", -- repl provider
    "anuvyklack/hydra.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("notebook-navigator").setup() -- KHÔNG truyền activate_hydra_keys vào
  end,
}
