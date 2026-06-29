---@type NvPluginSpec
return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    local lint = require "lint"
    local markdownlint_config = vim.fn.stdpath "config" .. "/.markdownlint.json"

    if lint.linters["markdownlint-cli2"] then
      lint.linters["markdownlint-cli2"].args = { "--config", markdownlint_config, "-" }
    end

    -- Rule: only add a linter for languages the LSP does NOT cover.
    -- Example: TS/JS skipped here because eslint-lsp lints via LSP;
    -- Rust skipped because rust-analyzer + clippy already handles it.
    lint.linters_by_ft = {
      -- Solidity: solhint catches security anti-patterns + style that
      -- solidity_ls_nomicfoundation misses.
      solidity = { "solhint" },

      -- Python: ruff (same tool as ruff_format in conform).
      python = { "ruff" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- Markdown
      markdown = { "markdownlint-cli2" },

      -- C / C++: clangd LSP runs with --clang-tidy (see noah/LSP/languages/cpp.lua),
      -- so clang-tidy diagnostics already flow through the LSP. Running it again
      -- via nvim-lint would just duplicate, and clang-tidy itself is not on PATH
      -- by default on macOS (requires `brew install llvm` or full Xcode).
      -- c = { "clangtidy" },
      -- cpp = { "clangtidy" },

      -- Go (golangci-lint is the community-standard meta-linter)
      go = { "golangcilint" },

      -- Dockerfile
      dockerfile = { "hadolint" },

      -- YAML
      yaml = { "yamllint" },

      -- Kotlin
      kotlin = { "ktlint" },

      -- SQL (sqlfluff is the same tool as the formatter)
      sql = { "sqlfluff" },

      -- Terraform / HCL
      terraform = { "tflint" },
      hcl = { "tflint" },
    }

    -- Lint-on-save (BufWritePost - after format has run).
    -- Use a single autocmd group to avoid registering multiple times.
    local group = vim.api.nvim_create_augroup("UserNvimLint", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
