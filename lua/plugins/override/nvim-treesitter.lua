---@type NvPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/playground" },
  config = function(_, opts)
    local function patch_playground_query_linter()
      local ok, linter = pcall(require, "nvim-treesitter-playground.query_linter")
      if not ok or linter._noah_symbols_patch then
        return
      end

      local api = vim.api
      local ts = require "nvim-treesitter.compat"
      local queries = require "nvim-treesitter.query"
      -- local parsers = require "nvim-treesitter.parsers"
      local utils = require "nvim-treesitter.utils"
      local ts_compat = require "nvim-treesitter.compat"

      local namespace = api.nvim_create_namespace "nvim-playground-lints"
      local MAGIC_NODE_NAMES = { "_", "ERROR" }

      local function show_lints(buf, lints)
        if linter.use_diagnostics then
          local diagnostics = vim.tbl_map(function(lint)
            return {
              lnum = lint.range[1],
              end_lnum = lint.range[3],
              col = lint.range[2],
              end_col = lint.range[4],
              severity = vim.diagnostic.ERROR,
              message = lint.message,
            }
          end, lints)
          vim.diagnostic.set(namespace, buf, diagnostics)
        end
      end

      local function add_lint_for_node(node, buf, error_type, complete_message)
        local node_text = ts_compat.get_node_text(node, buf):gsub("\n", " ")
        local error_text = complete_message or error_type .. ": " .. node_text
        local error_range = { node:range() }
        table.insert(linter.lints[buf], {
          type = error_type,
          range = error_range,
          message = error_text,
          node_text = node_text,
        })
      end

      local function symbols_contain(symbols, node_type, is_named)
        if type(symbols) ~= "table" then
          return false
        end

        if vim.islist(symbols) then
          for _, entry in ipairs(symbols) do
            if type(entry) == "table" and node_type == entry[1] and is_named == entry[2] then
              return true
            end
          end
          return false
        end

        return symbols[node_type] == is_named
      end

      function linter.lint(query_buf)
        query_buf = query_buf or api.nvim_get_current_buf()
        linter.clear_virtual_text(query_buf)
        linter.lints[query_buf] = {}

        local query_lang = linter.guess_query_lang(query_buf)
        local ok_inspect, parser_info = pcall(vim.treesitter.language.inspect, query_lang)
        if not ok_inspect then
          return
        end

        local matches = queries.get_matches(query_buf, "query-linter-queries")

        for _, m in pairs(matches) do
          local error_node = utils.get_at_path(m, "error.node")
          if error_node then
            add_lint_for_node(error_node, query_buf, "Syntax Error")
          end

          local toplevel_node = utils.get_at_path(m, "toplevel-query.node")
          if toplevel_node and query_lang then
            local query_text = ts_compat.get_node_text(toplevel_node, query_buf)
            local ok_query, err = pcall(ts.parse_query, query_lang, query_text)
            if not ok_query then
              add_lint_for_node(toplevel_node, query_buf, "Invalid Query", err)
            end
          end

          if parser_info and parser_info.symbols then
            local named_node = utils.get_at_path(m, "named_node.node")
            local anonymous_node = utils.get_at_path(m, "anonymous_node.node")
            local node = named_node or anonymous_node
            if node then
              local node_type = ts_compat.get_node_text(node, query_buf)

              if anonymous_node then
                node_type = node_type:gsub('"(.*)".*$', "%1"):gsub("\\(.)", "%1")
              end

              local is_named = named_node ~= nil
              local found = vim.tbl_contains(MAGIC_NODE_NAMES, node_type) or symbols_contain(parser_info.symbols, node_type, is_named)

              if not found then
                add_lint_for_node(node, query_buf, "Invalid Node Type")
              end
            end

            local field_node = utils.get_at_path(m, "field.node")
            if field_node then
              local field_name = ts_compat.get_node_text(field_node, query_buf)
              if not vim.tbl_contains(parser_info.fields, field_name) then
                add_lint_for_node(field_node, query_buf, "Invalid Field")
              end
            end
          end
        end

        show_lints(query_buf, linter.lints[query_buf])
        return linter.lints[query_buf]
      end

      linter._noah_symbols_patch = true
    end

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
    patch_playground_query_linter()

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
