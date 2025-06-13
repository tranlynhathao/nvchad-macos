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

    -- C#
    table.insert(
      opts.sources,
      null_ls.builtins.formatting.custom {
        name = "dotnet_format",
        method = null_ls.methods.FORMATTING,
        filetypes = { "cs" },
        generator_opts = {
          command = "dotnet-format",
          args = { "--include", "$FILENAME", "--folder", "--verbosity", "quiet" },
          to_stdin = false,
          to_temp_file = true,
        },
      }
    )

    -- Python (requires: black)
    table.insert(opts.sources, null_ls.builtins.formatting.black)

    -- Swift (requires: swiftformat)
    table.insert(opts.sources, null_ls.builtins.formatting.swiftformat)

    -- Go (requires: gofumpt, golines, goimports-reviser)
    table.insert(opts.sources, null_ls.builtins.formatting.gofumpt)
    table.insert(opts.sources, null_ls.builtins.formatting.golines)
    table.insert(opts.sources, null_ls.builtins.formatting.goimports_reviser)

    -- Ruby (requires: rufo)
    table.insert(opts.sources, null_ls.builtins.formatting.rufo)

    -- Zig (requires: zig installed)
    table.insert(opts.sources, null_ls.builtins.formatting.zigfmt)

    -- Rust (requires: rustfmt)
    table.insert(opts.sources, null_ls.builtins.formatting.rustfmt)
  end,
}
