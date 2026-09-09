---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = { border = "rounded" },
    -- Rule: every language gets (LSP + formatter + linter) coverage.
    -- Kept in sync with conform.lua, nvim-lint.lua, lspconfig.lua, lsp/init.lua.
    ensure_installed = {
      -- ── Debug adapters ─────────────────────────────────────────────────
      "codelldb", -- Rust / C / C++
      "js-debug-adapter", -- JS / TS / Node
      "kotlin-debug-adapter",
      "java-debug-adapter",
      "java-test",
      "delve", -- Go debugger

      -- ── C / C++ / Objective-C ─────────────────────────────────────────
      "clangd", -- LSP
      "clang-format", -- formatter

      -- ── C# / .NET ──────────────────────────────────────────────────────
      "omnisharp", -- LSP
      "csharpier", -- formatter (modern)

      -- ── Dart / Flutter ─────────────────────────────────────────────────
      -- dartls ships with the Dart SDK, no Mason install needed.

      -- ── Solidity ───────────────────────────────────────────────────────
      "nomicfoundation-solidity-language-server", -- primary LSP (Foundry-aware)
      "solidity-ls", -- LSP fallback
      "solhint", -- linter (nvim-lint)
      -- forge_fmt ships with the Foundry CLI; install via foundryup.

      -- ── Web (HTML / CSS / Tailwind) ────────────────────────────────────
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",

      -- ── JS / TS / Node ─────────────────────────────────────────────────
      "typescript-language-server",
      "eslint-lsp", -- linter qua LSP

      -- ── Frontend frameworks ────────────────────────────────────────────
      "svelte-language-server",
      "vue-language-server", -- volar
      "astro-language-server",

      -- ── Go ─────────────────────────────────────────────────────────────
      "gopls", -- LSP
      "goimports", -- formatter
      "golangci-lint", -- linter

      -- ── Rust ───────────────────────────────────────────────────────────
      -- rust-analyzer + rustfmt + clippy all come from rustup; no Mason needed.

      -- ── Java ───────────────────────────────────────────────────────────
      "jdtls", -- LSP
      "google-java-format", -- formatter

      -- ── Lua ────────────────────────────────────────────────────────────
      "lua-language-server",
      "stylua", -- formatter

      -- ── Data formats ───────────────────────────────────────────────────
      "json-lsp",
      "yaml-language-server",
      "taplo", -- TOML LSP + formatter
      "yamlfmt", -- formatter YAML
      "yamllint", -- linter YAML

      -- ── Docker ─────────────────────────────────────────────────────────
      "dockerfile-language-server",
      "docker-compose-language-service",
      "hadolint", -- linter Dockerfile

      -- ── Shell ──────────────────────────────────────────────────────────
      "bash-language-server",
      "shfmt", -- formatter
      "shellcheck", -- linter

      -- ── Python ─────────────────────────────────────────────────────────
      "pyright", -- LSP (type checker)
      "ruff", -- formatter + linter (single modern tool)

      -- ── Zig ────────────────────────────────────────────────────────────
      "zls", -- LSP + zigfmt formatter built-in

      -- ── Kotlin ─────────────────────────────────────────────────────────
      "kotlin-language-server",
      "ktlint", -- formatter + linter

      -- ── Ruby ───────────────────────────────────────────────────────────
      "solargraph", -- LSP
      -- rubocop installs via `gem install rubocop`.

      -- ── PHP ────────────────────────────────────────────────────────────
      "intelephense", -- LSP
      -- pint installs per-project: `composer require laravel/pint --dev`.
      -- For a global install: `brew install composer && composer global require laravel/pint`.
      -- Conform finds pint on PATH (vendor/bin -> composer global -> brew).

      -- ── Haskell ────────────────────────────────────────────────────────
      "haskell-language-server",

      -- ── OCaml ──────────────────────────────────────────────────────────
      -- ocamllsp + ocamlformat install via opam.

      -- ── Elixir / Erlang ────────────────────────────────────────────────
      "elixir-ls",
      "erlang-ls",

      -- ── SQL ────────────────────────────────────────────────────────────
      "sqlls", -- LSP (schema-aware completion, hover, goto def)
      "sqlfluff", -- formatter + linter

      -- ── Terraform / HCL ────────────────────────────────────────────────
      "terraform-ls", -- LSP
      "tflint", -- linter
      -- terraform fmt ships with the terraform CLI.

      -- ── Markdown ───────────────────────────────────────────────────────
      "marksman", -- LSP
      "markdownlint-cli2", -- linter
      "markdown-toc", -- TOC generator
      "prettier", -- formatter (shared across many web languages)
    },
  },
}
