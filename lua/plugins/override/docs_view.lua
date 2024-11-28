return {
  "amrbashir/nvim-docs-view",
  cmd = { "DocsViewToggle" },
  config = function()
    require("docs-view").setup {
      position = "right",
      width = 60,
    }

    vim.keymap.set("n", "<leader>dv", "<cmd>DocsViewToggle<CR>", { desc = "Toggle DocsView" })
  end,
}
