---@type NvPluginSpec
return {
  "folke/which-key.nvim",
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "WhichKey show all keymaps" })
    map("n", "<leader>wk", function()
      vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
    end, { desc = "WhichKey query lookup" })
  end,
  opts = {
    icons = {
      rules = false,
    },
    notify = false,
    spec = {
      -- top-level namespaces
      { "<leader>f", group = "Find / Telescope" },
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Git hunks" },
      { "<leader>gm", group = "Git merge / conflicts" },
      { "<leader>d", group = "Debug / DAP" },
      { "<leader>b", group = "Blockchain / Build" },
      { "<leader>r", group = "Run / Rust" },
      { "<leader>m", group = "Marks" },
      { "<leader>p", group = "Popup / Preview" },
      { "<leader>n", group = "Navigate / Next" },
      { "<leader>w", group = "Workspace / Window" },
      { "<leader>t", group = "Toggle / Theme" },
      { "<leader>c", group = "Code" },
      { "<leader>s", group = "Surround / Snippet" },
      { "<leader>o", group = "Open / Oil" },
      { "<leader>z", group = "Zen / Fold" },
    },
  },
}
