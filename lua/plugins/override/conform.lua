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
      -- Use prettier as primary, biome as fallback (biome needs --write flag)
      json = { "prettier", "biome" }, -- or: "jq"

      -- Markdown
      markdown = { "markdownlint" }, -- or: "prettier", "mdformat"

      -- OCaml
      ocaml = { "ocamlformat" }, -- or: "refmt"

      -- Lua
      lua = { "stylua" }, -- or: "lua-format"

      -- TOML
      toml = { "taplo" }, -- or: "prettier"

      -- YAML
      -- Use yamlfmt first, prettier as fallback (for complex YAML like pre-commit configs)
      yaml = { "yamlfmt", "prettier" }, -- or: "yamlfix"

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
      -- SQLFluff first (for standard SQL), prettier as fallback (handles templated SQL better)
      sql = { "sqlfluff", "prettier" }, -- or: "pg_format", "sql-formatter", "sql-formatter-plus"

      -- Solidity
      -- Try forge_fmt first (for Foundry), fallback to prettier
      -- Conform will try formatters in order until one succeeds
      solidity = { "forge_fmt", "prettier" },

      -- Java
      java = { "google-java-format" }, -- or: "clangformat", "eclipse formatter"

      -- JSX Variants
      ["javascriptnext.jsx"] = { "prettier" }, -- or: "biome"
      ["javascriptnuxt.jsx"] = { "prettier" }, -- or: "biome"
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 2000, lsp_fallback = true }
    end,

    formatters = {
      yamlfmt = {
        args = { "-formatter", "retain_line_breaks_single=true" },
        timeout_ms = 3000,
      },

      -- Biome formatter
      -- Biome format outputs to stdout when using stdin (no --write needed)
      -- Prettier is the primary formatter for JSON, biome is fallback
      biome = {
        command = "biome",
        args = { "format", "--stdin-file-path", "$FILENAME", "-" },
        stdin = true,
        timeout_ms = 3000,
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
        timeout_ms = 8000, -- Reduced timeout, fail faster
        -- Skip files with templating (common in dbt, jinja, etc.)
        -- This prevents errors on templated SQL files
        condition = function(ctx)
          local filename = ctx.filename or ""
          if filename == "" then
            return true
          end

          -- Check file path for common templating indicators
          local path_lower = filename:lower()
          if path_lower:match "models/" or path_lower:match "dbt/" or path_lower:match "jinja" then
            return false -- Skip dbt/jinja files
          end

          -- Quick check: read first 100 lines for templating syntax
          local ok, lines = pcall(vim.fn.readfile, filename, "", 100)
          if not ok or not lines then
            return true -- If we can't read, let sqlfluff try
          end

          for _, line in ipairs(lines) do
            -- Skip files with common templating syntax (dbt, jinja, etc.)
            -- Check for: {{ }}, {% %}, ${ }, {%- -%}, {{- -}}
            if line:match "{{" or line:match "{%" or line:match "${" or line:match "jinja" or line:match "dbt" then
              return false
            end
          end
          return true
        end,
      },

      -- black = {
      --   timeout_ms = 5000,
      -- },

      markdownlint = {
        timeout_ms = 5000,
      },

      clangformat = {
        command = "clang-format",
        args = { "--assume-filename", "$FILENAME" },
        stdin = true,
        timeout_ms = 3000,
      },

      ["dotnet-format"] = {
        command = "dotnet",
        args = { "format" },
        stdin = false,
        timeout_ms = 5000,
      },

      google_java_format = {
        timeout_ms = 5000,
      },

      -- Forge fmt formatter for Solidity
      -- Automatically finds project root (where foundry.toml is)
      forge_fmt = {
        command = "forge",
        args = { "fmt", "$FILENAME" },
        stdin = false,
        cwd = function(ctx)
          local filename = ctx.filename or ""
          local dir = filename ~= "" and vim.fn.fnamemodify(filename, ":h") or vim.loop.cwd()

          -- Find project root by looking for foundry.toml
          local found = vim.fn.findfile("foundry.toml", dir .. ";")
          if found ~= "" then
            return vim.fn.fnamemodify(found, ":h")
          end

          return dir
        end,
        timeout_ms = 5000,
      },
    },
  },
}
