---@type NvPluginSpec
return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    opts.sources = opts.sources or {}

    ----------------------------------------------------------------
    -- 🧮 SAGE SUPPORT
    ----------------------------------------------------------------
    vim.filetype.add { extension = { sage = "sage" } }

    vim.treesitter.language.register("python", "sage")

    -- Diagnostics (ruff + mypy)
    table.insert(
      opts.sources,
      null_ls.builtins.diagnostics.ruff.with {
        filetypes = { "python", "sage" },
        extra_args = { "--ignore", "E501" },
      }
    )
    table.insert(
      opts.sources,
      null_ls.builtins.diagnostics.mypy.with {
        filetypes = { "python", "sage" },
      }
    )

    table.insert(
      opts.sources,
      null_ls.builtins.formatting.custom {
        name = "sagefmt",
        method = null_ls.methods.FORMATTING,
        filetypes = { "sage" },
        generator_opts = {
          command = "bash",
          args = {
            "-c",
            [[sage --preparse /dev/stdin 2>/dev/null || cat /dev/stdin]],
          },
          to_stdin = true,
        },
      }
    )
    ----------------------------------------------------------------

    -- JS/TS/JSX/TSX
    table.insert(
      opts.sources,
      null_ls.builtins.formatting.prettier.with {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      }
    )
    table.insert(
      opts.sources,
      null_ls.builtins.diagnostics.eslint.with {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      }
    )
    table.insert(opts.sources, null_ls.builtins.code_actions.eslint)

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

    -- Nix (requires: alejandra)
    table.insert(opts.sources, null_ls.builtins.formatting.alejandra)

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

    table.insert(opts.sources, null_ls.builtins.diagnostics.mypy)
    table.insert(
      opts.sources,
      null_ls.builtins.diagnostics.ruff.with {
        extra_args = { "--ignore", "E501" },
      }
    )

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

    opts.on_attach = function(client, bufnr)
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { bufnr = bufnr }
          end,
        })
      end
    end
  end,
}
