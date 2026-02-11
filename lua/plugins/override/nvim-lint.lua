---@type NvPluginSpec
return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require("lint").linters_by_ft = {
      -- JS/TS: eslint not used here (use ESLint LSP in lspconfig).
      -- To re-enable: install eslint in project (npm i -D eslint) or globally (npm i -g eslint).
      -- javascript = { "eslint" },
      -- typescript = { "eslint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
