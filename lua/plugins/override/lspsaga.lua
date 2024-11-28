---@type NvPluginSpec
return {
  "glepnir/lspsaga.nvim",
  branch = "main",
  config = function()
    require("lspsaga").init_lsp_saga {
      symbol_in_winbar = { enable = false },
      code_action = { num_shortcut = true },
      finder_action_keys = {
        quit = "q",
        vsplit = "<C-v>",
      },
      definition_action_keys = { edit = "o" },
    }

    -- Key mappings
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show documentation" })
    vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
    vim.keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { desc = "Find references" })
    vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", { desc = "Show code actions" })
    vim.keymap.set("n", "gi", "<cmd>Lspsaga implementations<CR>", { desc = "Go to implementations" })
  end,
}
