---@type NvPluginSpec
return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    opts.sources = opts.sources or {}

    -- JS/TS/JSX/TSX
    table.insert(
      opts.sources,
      null_ls.builtins.formatting.prettier.with {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      }
    )

    -- HTML
    table.insert(
      opts.sources,
      null_ls.builtins.formatting.custom {
        name = "html-minifier",
        method = null_ls.methods.FORMATTING,
        filetypes = { "html" },
        generator_opts = {
          command = "html-minifier",
          args = { "--collapse-whitespace", "--remove-comments", "--minify-css", "--minify-js" },
          to_stdin = true,
        },
      }
    )

    -- CSS/SCSS
    table.insert(
      opts.sources,
      null_ls.builtins.formatting.custom {
        name = "csso",
        method = null_ls.methods.FORMATTING,
        filetypes = { "css", "scss" },
        generator_opts = {
          command = "csso",
          args = { "-" },
          to_stdin = true,
        },
      }
    )
  end,
}
