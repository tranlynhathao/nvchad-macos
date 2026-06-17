---@diagnostic disable: different-requires

---@type NvPluginSpec
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  init = function()
    vim.keymap.set("n", "<leader>fm", function()
      require("conform").format { lsp_fallback = true }
    end, { desc = "Format file" })

    -- Toggle format-on-save (per-buffer or global).
    -- `:FormatOff` / `:FormatOn` for quick on/off.
    vim.api.nvim_create_user_command("FormatOff", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable format-on-save (! = buffer only)", bang = true })

    vim.api.nvim_create_user_command("FormatOn", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Enable format-on-save" })
  end,
  ---@type conform.setupOpts
  opts = {
    -- Rule: ONE formatter per language. No fallback chain, to avoid the
    -- output drifting between saves.
    formatters_by_ft = {
      -- C / C++ / Objective-C
      c = { "clang-format" },
      cpp = { "clang-format" },
      objc = { "clang-format" },

      -- C# / .NET
      cs = { "csharpier" },
      ["c_sharp"] = { "csharpier" },

      -- Dart
      dart = { "dart_format" },

      -- Shell
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      -- CSS / SCSS / Less
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },

      -- Go
      go = { "goimports" },

      -- HTML
      html = { "prettier" },

      -- JS / TS / JSX / TSX
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },

      -- Frontend frameworks
      vue = { "prettier" },
      svelte = { "prettier" },
      astro = { "prettier" },

      -- Data formats
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "yamlfmt" },
      toml = { "taplo" },
      graphql = { "prettier" },

      -- Markdown (ALWAYS use prettier; markdownlint is a LINTER, not a formatter)
      markdown = { "prettier" },

      -- Lua
      lua = { "stylua" },

      -- Python (ruff_format = ruff fmt; same tool as the linter)
      python = { "ruff_format" },

      -- Rust
      rust = { "rustfmt" },

      -- Kotlin
      kotlin = { "ktlint" },

      -- PHP (Laravel Pint - modern standard, bundles PHP-CS-Fixer rules)
      php = { "pint" },

      -- Ruby
      ruby = { "rubocop" },

      -- Java
      java = { "google-java-format" },

      -- SQL
      sql = { "sqlfluff" },

      -- Solidity (Foundry forge fmt)
      solidity = { "forge_fmt" },

      -- Terraform / HCL
      terraform = { "terraform_fmt" },
      hcl = { "terraform_fmt" },

      -- OCaml / Gleam / Zig / Elixir / Erlang
      ocaml = { "ocamlformat" },
      gleam = { "gleam" },
      zig = { "zigfmt" },
      elixir = { "mix" },
      erlang = { "erlfmt" },

      -- INI / .cfg generic config (xem noah/filetypes.lua cho dosini vs conf)
      dosini = { "trim_whitespace" },
      conf = { "trim_whitespace" },

      -- Catch-all: trim trailing whitespace for every remaining filetype.
      ["_"] = { "trim_whitespace" },
    },

    format_on_save = function(bufnr)
      -- Allow disabling format-on-save globally (vim.g) or per-buffer (vim.b)
      -- via `:FormatOff` / `:FormatOff!` (see the init function).
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 2000, lsp_fallback = true }
    end,

    formatters = {
      -- Compact-first style for every formatter: arrays / structs / matrices stay
      -- on one line when they fit within 120 cols. Trailing commas removed so
      -- "magic trailing comma" doesn't force multiline.
      prettier = {
        command = "prettier",
        args = {
          "--stdin-filepath",
          "$FILENAME",
          "--print-width",
          "120",
          "--bracket-same-line",
          "--trailing-comma",
          "none",
          "--arrow-parens",
          "avoid",
        },
        stdin = true,
        timeout_ms = 3000,
      },

      ruff_format = {
        command = "ruff",
        args = {
          "format",
          "--line-length",
          "120",
          "--config",
          "format.skip-magic-trailing-comma=true",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
        stdin = true,
        timeout_ms = 3000,
      },

      rustfmt = {
        command = "rustfmt",
        -- max_width=120 is stable; the *_width / heuristics / trailing_comma
        -- options are nightly-only -> require `--unstable-features`. Since the
        -- default toolchain is nightly (rustup default nightly), this is fine.
        args = {
          "--edition",
          "2021",
          "--unstable-features",
          "--config",
          "max_width=120,"
            .. "fn_call_width=100,"
            .. "array_width=100,"
            .. "chain_width=100,"
            .. "struct_lit_width=80,"
            .. "struct_variant_width=80,"
            .. "attr_fn_like_width=100,"
            .. "single_line_if_else_max_width=60,"
            .. "use_small_heuristics=Max,"
            .. "trailing_comma=Never,"
            .. "match_block_trailing_comma=false,"
            .. "fn_params_layout=Compressed",
        },
        stdin = true,
        timeout_ms = 3000,
      },

      ["clang-format"] = {
        command = "clang-format",
        args = {
          "--assume-filename",
          "$FILENAME",
          "--style={"
            .. "BasedOnStyle: LLVM, "
            .. "ColumnLimit: 120, "
            .. "BinPackArguments: true, "
            .. "BinPackParameters: true, "
            .. "AllowAllArgumentsOnNextLine: false, "
            .. "AllowAllParametersOfDeclarationOnNextLine: false, "
            .. "AllowShortFunctionsOnASingleLine: All, "
            .. "AllowShortBlocksOnASingleLine: Always, "
            .. "AllowShortIfStatementsOnASingleLine: WithoutElse, "
            .. "AllowShortLoopsOnASingleLine: true, "
            .. "AllowShortCaseLabelsOnASingleLine: true, "
            .. "Cpp11BracedListStyle: false, "
            .. "AlignAfterOpenBracket: BlockIndent"
            .. "}",
        },
        stdin = true,
        timeout_ms = 3000,
      },

      stylua = {
        command = "stylua",
        args = {
          "--column-width",
          "120",
          "--collapse-simple-statement",
          "Always",
          "--quote-style",
          "AutoPreferDouble",
          "--call-parentheses",
          "Always",
          "-",
        },
        stdin = true,
        timeout_ms = 3000,
      },

      goimports = {
        command = "goimports",
        stdin = true,
        timeout_ms = 3000,
      },

      yamlfmt = {
        args = {
          "-formatter",
          "retain_line_breaks_single=true,scan_folded_as_literal=true,max_line_length=120",
        },
        timeout_ms = 3000,
      },

      sqlfluff = {
        command = "sqlfluff",
        args = { "fix", "--dialect", "postgres", "--disable-progress-bar", "-" },
        stdin = true,
        cwd = function(ctx)
          if ctx.filename == nil or ctx.filename == "" then
            return vim.loop.cwd()
          end
          return vim.fn.fnamemodify(ctx.filename, ":h")
        end,
        timeout_ms = 8000,
        -- Skip files with templating (dbt, jinja, ...) since sqlfluff fails to parse them.
        condition = function(ctx)
          local filename = ctx.filename or ""
          if filename == "" then
            return true
          end
          local path_lower = filename:lower()
          if path_lower:match "models/" or path_lower:match "dbt/" or path_lower:match "jinja" then
            return false
          end
          local ok, lines = pcall(vim.fn.readfile, filename, "", 100)
          if not ok or not lines then
            return true
          end
          for _, line in ipairs(lines) do
            if line:match "{{" or line:match "{%" or line:match "${" or line:match "jinja" or line:match "dbt" then
              return false
            end
          end
          return true
        end,
      },

      forge_fmt = {
        command = "forge",
        args = { "fmt", "$FILENAME" },
        stdin = false,
        cwd = function(ctx)
          local filename = ctx.filename or ""
          local dir = filename ~= "" and vim.fn.fnamemodify(filename, ":h") or vim.loop.cwd()
          local found = vim.fn.findfile("foundry.toml", dir .. ";")
          if found ~= "" then
            return vim.fn.fnamemodify(found, ":h")
          end
          return dir
        end,
        timeout_ms = 5000,
      },

      csharpier = {
        command = "dotnet",
        args = { "csharpier", "--write-stdout" },
        stdin = true,
        timeout_ms = 5000,
      },

      google_java_format = {
        timeout_ms = 5000,
      },

      pint = {
        command = "pint",
        args = { "$FILENAME" },
        stdin = false,
        timeout_ms = 5000,
      },

      terraform_fmt = {
        command = "terraform",
        args = { "fmt", "-" },
        stdin = true,
        timeout_ms = 3000,
      },
    },
  },
}
