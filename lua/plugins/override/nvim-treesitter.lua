---@type NvPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/playground" },
  config = function(_, opts)
    local function parse_version(version)
      local major, minor, patch = version:match "(%d+)%.(%d+)%.?(%d*)"
      return tonumber(major) or 0, tonumber(minor) or 0, tonumber(patch) or 0
    end

    local function version_at_least(version, minimum)
      local major, minor, patch = parse_version(version)
      local req_major, req_minor, req_patch = parse_version(minimum)

      if major ~= req_major then
        return major > req_major
      end
      if minor ~= req_minor then
        return minor > req_minor
      end
      return patch >= req_patch
    end

    local ts_install = require "nvim-treesitter.install"
    local ts_utils = require "nvim-treesitter.utils"
    local ts_cli_version = ts_utils.ts_cli_version()

    -- tree-sitter CLI 0.25+ removed `--no-bindings`; nvim-treesitter still sets it on this pinned version.
    if ts_cli_version and version_at_least(ts_cli_version, "0.25.0") then
      ts_install.ts_generate_args = { "generate", "--abi", tostring(vim.treesitter.language_version) }
    end

    require("nvim-treesitter.configs").setup(opts)

    -- Neovim 0.12 changed iter_matches() so each capture returns TSNode[] instead of TSNode.
    -- nvim-treesitter/master's directive handlers expect a single node and crash calling :range().
    -- Re-register the two affected directives with unwrapping for both formats.
    if vim.fn.has "nvim-0.12" == 1 then
      local non_filetype_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        uxn = "uxntal",
        ts = "typescript",
      }
      local function resolve_lang(alias)
        return vim.filetype.match { filename = "a." .. alias } or non_filetype_aliases[alias] or alias
      end
      local function unwrap(v)
        return type(v) == "table" and v[1] or v
      end

      vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = unwrap(match[pred[2]])
        if not node then
          return
        end
        metadata["injection.language"] = resolve_lang(vim.treesitter.get_node_text(node, bufnr):lower())
      end, { force = true })

      vim.treesitter.query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = unwrap(match[id])
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
        if not metadata[id] then
          metadata[id] = {}
        end
        metadata[id].text = string.lower(text)
      end, { force = true })
    end
  end,
  opts = {
    ensure_installed = {
      "astro",
      "bash",
      "c",
      "css",
      "gleam",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "haskell",
      "html",
      "http",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "latex", -- for render-markdown.nvim LaTeX blocks ($$ ... $$)
      "ocaml",
      "rust",
      "pug",
      "scheme",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "zig",
      "ruby",
      "python",
      "sql",
      "solidity", -- Smart contracts (EVM / Foundry / Hardhat)
      "yaml", -- Anchor.yml, GitHub Actions, deployment configs
      "dockerfile", -- Dockerfile syntax
      "java",
      "kotlin",
      "swift",
      "c_sharp",
      "cpp",
      "cmake",
      "make",
      "php",
      "xml",
      "elixir",
      "perl",
      "julia",
      -- vim meta / query
      "query",
      -- git / misc
      "diff",
      "gitcommit",
      "regex",
      "comment",
    },
    auto_install = true,
    indent = { enable = true },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader>is",
        node_incremental = "<Tab>",
        scope_incremental = "<S-s>",
        node_decremental = "<S-Tab>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select around function" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of function" },
          ["ac"] = { query = "@class.outer", desc = "Select around class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of class" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "<c-v>",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>wn"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>wp"] = "@parameter.inner",
        },
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  },
}
