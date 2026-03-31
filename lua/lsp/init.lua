return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },
  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
      end

      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
      nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")
    end

    -- Language servers.
    -- Entries may be either:
    --   flat table  → passed directly as `settings` (legacy style, e.g. lua_ls)
    --   structured  → table with { settings, filetypes, root_dir } keys
    local servers = {
      -- C/C++
      clangd = {},

      -- Assembly
      asm_lsp = {},

      -- Solidity — NomicFoundation server (better diagnostics, Foundry-aware root detection)
      -- rust_analyzer is intentionally absent: rustaceanvim manages it exclusively.
      solidity_ls_nomicfoundation = {
        settings = {
          solidity = {
            formatter = "forge",
            telemetry = false,
            validation = { onChange = true, onOpen = true, onSave = true },
          },
        },
        filetypes = { "solidity" },
        root_dir = function(fname)
          local util = require "lspconfig.util"
          return util.root_pattern("foundry.toml", "hardhat.config.js", "hardhat.config.ts", ".git")(fname) or util.path.dirname(fname)
        end,
      },

      -- Lua
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },

      -- TOML — essential for foundry.toml, Cargo.toml, Anchor.toml
      taplo = {},

      -- Docker
      dockerls = {},
      docker_compose_language_service = {},

      -- Web / TypeScript / Node (from mason-lspconfig override — merged here)
      ts_ls = {},
      eslint = {},
      tailwindcss = {},

      -- Data formats
      jsonls = {},
      yamlls = {},

      -- Shell
      bashls = {},

      -- Go / Python
      gopls = {},
      pyright = {},

      -- Zig
      zls = {},

      -- Kotlin
      kotlin_language_server = {},

      -- C# (.NET)
      omnisharp = {},

      -- Ruby
      solargraph = {},

      -- Terraform / HCL
      terraformls = {},

      -- Deno — scoped to deno.json/deno.jsonc roots to avoid conflict with ts_ls
      denols = {
        root_dir = function(fname)
          local util = require "lspconfig.util"
          return util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname)
        end,
        single_file_support = false,
      },
    }

    require("neodev").setup()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local mason_lspconfig = require "mason-lspconfig"

    -- Single authoritative setup call — supersedes the mason-lspconfig.lua override.
    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        -- rustaceanvim configures rust-analyzer exclusively; skip it here.
        if server_name == "rust_analyzer" then
          return
        end

        local cfg = servers[server_name] or {}
        -- A "structured" entry has explicit meta-keys (settings, filetypes, root_dir, …).
        -- A "flat" entry IS the settings table directly (legacy lua_ls style).
        local has_meta = cfg.settings ~= nil
          or cfg.filetypes ~= nil
          or cfg.root_dir ~= nil
          or cfg.single_file_support ~= nil
          or cfg.init_options ~= nil
        local settings = has_meta and (cfg.settings or {}) or cfg
        require("lspconfig")[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = settings,
          filetypes = cfg.filetypes,
          root_dir = cfg.root_dir,
          single_file_support = cfg.single_file_support,
          init_options = cfg.init_options,
        }
      end,
    }

    -- System-installed LSPs (not Mason-managed).
    -- dartls ships inside the Dart SDK binary, not as a standalone Mason package.
    local system_servers = {
      dartls = {},
    }
    for server_name, cfg in pairs(system_servers) do
      local has_meta = cfg.settings ~= nil or cfg.filetypes ~= nil or cfg.root_dir ~= nil
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = has_meta and (cfg.settings or {}) or cfg,
      }
    end
  end,
}
