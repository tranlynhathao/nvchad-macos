---@type NvPluginSpec
return {
  "akinsho/nvim-doc-view",
  config = function()
    require("docview").setup {
      filetypes = { "python", "javascript", "typescript", "lua", "go", "rust" },
      default_browser = "google-chrome", -- change
      floating = true, -- display
    }

    vim.keymap.set("n", "K", "<cmd>DocView<CR>", { desc = "Show LSP documentation" })
  end,
}
