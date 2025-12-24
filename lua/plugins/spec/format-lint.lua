return {
  -- Formatter
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          rust = { "rustfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      }
    end,
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        c = { "clang-tidy" },
        cpp = { "clang-tidy" },
        rust = { "clippy" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
