---@type NvPluginSpec
return {
  "jose-elias-alvarez/telescope-lsp-docs.nvim",
  requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup {
      defaults = {
        prompt_position = "top",
      },
    }

    -- Load extension lsp_docs
    require("telescope").load_extension "lsp_docs"

    -- Key mappings
    vim.keymap.set("n", "K", function()
      require("telescope").extensions.lsp_docs.document()
    end, { desc = "Search LSP documentation" })

    vim.keymap.set("n", "gd", function()
      require("telescope").extensions.lsp_docs.workspace()
    end, { desc = "Search workspace LSP documentation" })
  end,
}
