---@diagnostic disable: different-requires

---@type NvPluginSpec
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  init = function()
    vim.keymap.set("n", "<leader>fm", function()
      require("conform").format { lsp_fallback = true }
    end, { desc = "General format file" })
  end,
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      -- C, C++, Objective-C
      c = { "clangformat" }, -- or: "uncrustify", "astyle"
      cpp = { "clangformat" }, -- or: "uncrustify", "astyle"
      objc = { "clangformat" }, -- or: "uncrustify", "astyle"

      -- C#, .NET
      c_sharp = { "dotnet-format" }, -- or: "clangformat", "uncrustify"
      cs = { "dotnet-format" },
      csharp = { "dotnet-format" }, -- or: "clangformat", "uncrustify"

      -- macOS/iOS
      -- objectivec = { "clangformat" },
      -- swift = { "swiftformat" }, -- or: "swiftformat", "clangformat"

      -- Dart
      dart = { "dart_format" }, -- or: "dartfmt" (deprecated)

      -- Bash / Shell
      bash = { "shfmt" }, -- or: "beautysh"

      -- CSS / SCSS
      css = { "prettier" }, -- or: "stylelint", "css-beautify"
      scss = { "prettier" }, -- same as above

      -- Gleam
      gleam = { "gleam" }, -- available in the Gleam language server

      -- Go
      go = { "gofmt" }, -- or: "goimports", "goreturns"

      -- HTML
      html = { "prettier" }, -- or: "html-beautify"

      -- JavaScript / TypeScript / Vue / Svelte
      javascript = { "prettier" }, -- or: "biome", "eslint --fix"
      javascriptreact = { "prettier" }, -- same as above
      typescript = { "prettier" }, -- or: "biome", "eslint --fix"
      typescriptreact = { "prettier" }, -- same as above
      vue = { "prettier" }, -- or: "eslint --fix"
      svelte = { "prettier" }, -- or: "svelte-preprocess"

      -- JSON
      json = { "biome" }, -- or: "prettier", "jq"

      -- Markdown
      markdown = { "markdownlint" }, -- or: "prettier", "mdformat"

      -- OCaml
      ocaml = { "ocamlformat" }, -- or: "refmt"

      -- Python
      python = { "black" }, -- or: "isort", "ruff_format", "autopep8", "yapf"

      -- Lua
      lua = { "stylua" }, -- or: "lua-format"

      -- TOML
      toml = { "taplo" }, -- or: "prettier"

      -- YAML
      yaml = { "yamlfmt" }, -- or: "prettier", "yamlfix"

      -- Zig
      zig = { "zigfmt" }, -- available in the Zig langauge server

      -- Ruby
      ruby = { "rufo" }, -- or: "standardrb", "rubocop"

      -- Elixir
      elixir = { "mix" }, -- or: "mix format"

      -- Erlang
      erlang = { "erlfmt" }, -- or: "rebar3", "erlange formatter", available in the Erlang lanhguage server

      -- Rust
      rust = { "rustfmt" }, -- or: "rust-analyzer", "cargo fmt", relase in the Rust language server

      -- Kotlin
      kotlin = { "ktlint" }, -- or: "detekt", "ktfmt"

      -- PHP
      php = { "phpcbf" }, -- or: "php-cs-fixer", "phpcbf"

      -- SQL
      sql = { "sqlfluff" }, -- or: "sqlfluff", "pg_format", "sql-formatter", "sql-formatter-plus"

      -- Solidity
      solidity = { "prettier" }, -- or: "solhint", "solfmt"

      -- Java
      java = { "google-java-format" }, -- or: "clangformat", "eclipse formatter"

      -- JSX Variants
      ["javascriptnext.jsx"] = { "prettier" }, -- or: "biome"
      ["javascriptnuxt.jsx"] = { "prettier" }, -- or: "biome"
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters = {
      yamlfmt = {
        args = { "-formatter", "retain_line_breaks_single=true" },
      },
      sqlfluff = {
        command = "sqlfluff",
        args = { "fix", "--dialect", "postgres", "--disable-progress-bar", "-" },
        stdin = true,
        cwd = function(ctx)
          if ctx.filename == nil or ctx.filename == "" then
            return vim.loop.cwd()
          else
            return vim.fn.fnamemodify(ctx.filename, ":h")
          end
        end,
        timeout_ms = 50000,
      },
    },
  },
}
