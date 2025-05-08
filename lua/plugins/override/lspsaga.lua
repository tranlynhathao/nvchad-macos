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
      hover = {
        max_width = 80,
        max_height = 20,
        open_link = "gx",
        open_cmd = "!xdg-open",
        keys = {
          quit = "q",
          toggle_or_open = "<CR>",
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
      },
      ui = {
        title = true,
        border = "rounded",
        winblend = 0,
        kind = nil,
      },
    }

    -- Key mappings
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show documentation" })
    vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
    vim.keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", { desc = "Find references" })
    vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", { desc = "Show code actions" })
    vim.keymap.set("n", "gi", "<cmd>Lspsaga implementations<CR>", { desc = "Go to implementations" })

    -- finder
    -- vim.keymap.set("n", "gi", "<cmd>Lspsaga finder<CR>")

    vim.cmd [[
    highlight FloatBorder guifg=#7aa2f7 guibg=#1a1b26
    highlight NormalFloat guibg=#1a1b26
  ]]
  end,
}
