return {
  "rachartier/tiny-code-action.nvim",
  keys = {
    {
      "<leader>ca",
      function() require("tiny-code-action").code_action() end,
      mode = { "n", "v" },
      desc = "Tiny code action",
    },
  },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function() require("tiny-code-action").setup() end,
}
