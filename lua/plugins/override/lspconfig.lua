---@type NvPluginSpec
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "mason-org/mason.nvim", version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "jcha0713/cmp-tw2css",
    "hrsh7th/nvim-cmp",
    "hoffs/omnisharp-extended-lsp.nvim",
  },

  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    -- Apply diagnostic UI immediately so it is ready when opening files
    local x = vim.diagnostic.severity
    vim.diagnostic.config {
      virtual_text = false,
      signs = { text = { [x.ERROR] = "", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "󰌵" } },
      float = { border = "rounded" },
      underline = true,
    }
    vim.fn.sign_define("CodeActionSign", { text = "󰉁", texthl = "CodeActionSignHl" })

    -- Defer full LSP config for faster startup; enable LSP per filetype when opening a file
    vim.defer_fn(function()
      local on_attach = require("noah.lsp").on_attach
      local capabilities = require("noah.lsp").capabilities

      local lsp = require "noah.lsp"
      local util = require "lspconfig.util"

      local vue_language_server_path = vim.fn.stdpath "data" .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

      local function organize_imports()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
        vim.lsp.execute_command(params)
      end

      vim.lsp.config("gopls", {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          on_dir(util.root_pattern("go.work", "go.mod", ".git")(fname))
        end,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      })

      vim.lsp.config("ts_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          preferences = {
            disableSuggestions = true,
          },
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
            },
          },
        },
        commands = {
          OrganizeImports = {
            organize_imports,
            description = "Organize Imports",
          },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })

      vim.lsp.config("tailwindcss", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("eslint", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "python" },
      })

      local servers = {
        astro = {},
        bashls = {
          on_attach = function(client, bufnr)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            if filename:match "%.env$" then
              vim.lsp.stop_client(client.id)
            end
          end,
        },
        -- clangd = {
        --   cmd = {
        --     "clangd",
        --     "--background-index",
        --     "--clang-tidy",
        --     "--completion-style=detailed",
        --     -- "-std=c++14",
        --     "-std=c11",
        --   },
        --   init_options = {
        --     fallbackFlags = { "-std=c14" },
        --   },
        --   settings = {
        --     clangd = {
        --       completion = { enableSnippets = true },
        --     },
        --   },
        -- },
        clangd = {},
        css_variables = {},
        cssls = {},
        eslint = {},
        html = {},
        hls = {},
        gopls = {
          -- config for gopls (Go)
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
          initializationOptions = {
            editorInfo = {
              name = "Neovim",
              version = "0.10.4",
            },
            editorPluginInfo = {
              name = "nvim-lspconfig",
              version = "1.7.0",
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = true },
              telemetry = { enable = false },
              diagnostics = { globals = { "bit", "vim", "it", "describe", "before_each", "after_each" } },
            },
          },
          initializationOptions = {
            editorInfo = {
              name = "Neovim",
              version = "0.10.4",
            },
            editorPluginInfo = {
              name = "nvim-lspconfig",
              version = "1.7.0",
            },
          },
        },
        marksman = {},
        ocamllsp = {},
        pyright = {},
        ruff = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
        somesass_ls = {},
        taplo = {},
        vtsls = {
          settings = {
            javascript = {
              inlayHints = lsp.inlay_hints_settings,
            },
            typescript = {
              inlayHints = lsp.inlay_hints_settings,
            },
            vtsls = {
              tsserver = {
                globalPlugins = {
                  "@styled/typescript-styled-plugin",
                },
              },
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          },
        },
        yamlls = {},
        zls = {
          -- Reduce crashes: disable build-on-save when build.zig is missing or build fails
          init_options = {
            enable_build_on_save = false,
          },
        },
        dartls = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
          on_attach = lsp.create_on_attach(),
          capabilities = lsp.capabilities,
          settings = {
            dart = {
              analysisExcludedFolders = { "/path/to/your/excluded/folder" },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = false,
              },
              procMacro = { enable = true },
              -- Use "check" for faster diagnostics; run clippy manually when needed
              checkOnSave = { command = "check" },
            },
          },
        },
        -- Solidity LSP (solidity-ls)
        solidity_ls = {
          root_dir = util.root_pattern("foundry.toml", "hardhat.config.js", "hardhat.config.ts", "truffle-config.js", ".git"),
          settings = {
            solidity = {
              includePath = "",
              remapping = {},
            },
          },
        },
        solargraph = {
          settings = {
            solargraph = {
              diagnostics = true,
            },
          },
        },
      }

      for name, opts in pairs(servers) do
        opts.on_init = lsp.on_init
        opts.on_attach = lsp.create_on_attach(opts.on_attach)
        opts.capabilities = lsp.capabilities
        -- Convert root_dir from util.root_pattern() to function(bufnr, on_dir) for Neovim 0.11 API
        if opts.root_dir and type(opts.root_dir) == "function" then
          local root_pattern_fn = opts.root_dir
          opts.root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(root_pattern_fn(fname))
          end
        end
        vim.lsp.config(name, opts)
      end

      -- Enable LSP per filetype when opening a file (faster startup, diagnostics on open)
      local filetype_to_servers = {
        go = { "gopls" },
        gomod = { "gopls" },
        gowork = { "gopls" },
        gotmpl = { "gopls" },
        typescript = { "ts_ls", "eslint" },
        javascript = { "ts_ls", "eslint" },
        javascriptreact = { "ts_ls", "eslint" },
        typescriptreact = { "ts_ls", "eslint" },
        vue = { "ts_ls", "eslint" },
        python = { "pyright", "ruff" },
        lua = { "lua_ls" },
        rust = { "rust_analyzer" },
        json = { "jsonls" },
        yaml = { "yamlls" },
        sh = { "bashls" },
        bash = { "bashls" },
        html = { "html" },
        css = { "cssls", "tailwindcss" },
        scss = { "cssls", "somesass_ls", "tailwindcss" },
        markdown = { "marksman" },
        toml = { "taplo" },
        zig = { "zls" },
        dart = { "dartls" },
        solidity = { "solidity_ls" },
        ruby = { "solargraph" },
        astro = { "astro" },
        c = { "clangd" },
        cpp = { "clangd" },
        haskell = { "hls" },
        ocaml = { "ocamllsp" },
        sass = { "somesass_ls" },
      }

      local enabled_servers = {}
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("LspLazyEnable", { clear = true }),
        callback = function(ev)
          local ft = ev.match
          local servers_to_enable = filetype_to_servers[ft]
          if not servers_to_enable then
            return
          end
          for _, name in ipairs(servers_to_enable) do
            if not enabled_servers[name] then
              enabled_servers[name] = true
              pcall(vim.lsp.enable, name)
            end
          end
        end,
      })

      -- Enable LSP for already-open buffers when defer runs
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          local ft = vim.bo[bufnr].filetype
          if ft and filetype_to_servers[ft] then
            for _, name in ipairs(filetype_to_servers[ft]) do
              if not enabled_servers[name] then
                enabled_servers[name] = true
                pcall(vim.lsp.enable, name)
              end
            end
          end
        end
      end
    end, 0) -- defer 0ms = run after startup, does not block UI

    -- When zls exits (e.g. exit 1): try to restart; also re-enable when re-entering Zig buffer
    local zls_restart_cooldown = 0
    local function try_restart_zls()
      local now = vim.loop.now()
      if now - zls_restart_cooldown < 3000 then
        return
      end
      zls_restart_cooldown = now
      -- Prefer LspRestart (nvim-lspconfig), fallback to vim.lsp.enable
      local ok = pcall(vim.cmd, "LspRestart zls")
      if not ok then
        pcall(vim.lsp.enable, "zls")
      end
    end

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("ZlsAutoRestart", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].filetype ~= "zig" then
          return
        end
        local client_id = ev.data and ev.data.client_id
        if client_id then
          local c = vim.lsp.get_client_by_id(client_id)
          if c and c.name ~= "zls" then
            return
          end
        end
        vim.defer_fn(try_restart_zls, 800)
      end,
    })

    -- On BufEnter for Zig: if zls is not attached, try to enable it (e.g. after crash, switch buffer and back)
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("ZlsBufEnterRestart", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].filetype ~= "zig" then
          return
        end
        local has_zls = false
        for _, c in ipairs(vim.lsp.get_clients { bufnr = ev.buf }) do
          if c.name == "zls" then
            has_zls = true
            break
          end
        end
        if not has_zls then
          vim.defer_fn(try_restart_zls, 200)
        end
      end,
    })
  end,
}
