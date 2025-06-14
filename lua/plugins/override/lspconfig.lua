---@type NvPluginSpec

return {
  "neovim/nvim-lspconfig",
  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    local on_attach = require("gale.lsp").on_attach
    local capabilities = require("gale.lsp").capabilities

    local lspconfig = require "lspconfig"
    local lsp = require "gale.lsp"
    local util = require "lspconfig/util"

    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }
      vim.lsp.execute_command(params)
    end

    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "gopls", "serve" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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
    }

    -- lspconfig.tsserver.setup {
    lspconfig.ts_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      init_options = {
        preferences = {
          disableSuggestions = true,
        },
      },
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports",
        },
      },
    }

    lspconfig.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    lspconfig.eslint.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

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
      zls = {},
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
            },
            procMacro = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
      -- TODO: add rust_analyzer
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
      lspconfig[name].setup(opts)
    end

    -- LSP UI
    local border = "rounded"

    local x = vim.diagnostic.severity
    vim.diagnostic.config {
      virtual_text = false,
      signs = { text = { [x.ERROR] = "", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "󰌵" } },
      float = { border = border },
      underline = true,
    }

    -- Gutter
    vim.fn.sign_define("CodeActionSign", { text = "󰉁", texthl = "CodeActionSignHl" })
  end,
}
