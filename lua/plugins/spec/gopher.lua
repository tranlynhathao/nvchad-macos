---@type NvPluginSpec
return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function(_, opts)
    require("gopher").setup(opts)

    -- Keymaps cho struct tags
    vim.keymap.set("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { desc = "Add json struct tags" })
    vim.keymap.set("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { desc = "Add yaml struct tags" })
    vim.keymap.set("n", "<leader>gss", "<cmd>GoTagAdd sql<CR>", { desc = "Add sql struct tags" })
    vim.keymap.set("n", "<leader>gsv", "<cmd>GoTagAdd validate<CR>", { desc = "Add validate struct tags" })
    vim.keymap.set("n", "<leader>gst", "<cmd>GoTagAdd json,yaml,sql,validate<CR>", { desc = "Add all common struct tags" })

    -- Keymaps for removing struct tags
    vim.keymap.set("n", "<leader>grj", "<cmd>GoTagRm json<CR>", { desc = "Remove json struct tags" })
    vim.keymap.set("n", "<leader>gry", "<cmd>GoTagRm yaml<CR>", { desc = "Remove yaml struct tags" })
    vim.keymap.set("n", "<leader>grs", "<cmd>GoTagRm sql<CR>", { desc = "Remove sql struct tags" })
    vim.keymap.set("n", "<leader>grv", "<cmd>GoTagRm validate<CR>", { desc = "Remove validate struct tags" })
  end,
  build = function()
    vim.cmd [[silent! GoInstallDeps]]
  end,
}
