---@type NvPluginSpec
return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require("lint").linters_by_ft = {
      -- Solidity: solhint catches security anti-patterns, style violations,
      -- and best-practice issues that the LSP (solidity_ls_nomicfoundation) misses.
      solidity = { "solhint" },

      -- JS/TS: ESLint LSP in lspconfig is used instead of nvim-lint here.
      -- Re-enable if you need lint-on-save separate from LSP diagnostics:
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
