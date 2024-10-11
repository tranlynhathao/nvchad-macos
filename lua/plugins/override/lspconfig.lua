---@type NvPluginSpec

return {
  "neovim/nvim-lspconfig",
  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    local lspconfig = require "lspconfig"
    local lsp = require "gale.lsp"

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
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            hint = { enable = true },
            telemetry = { enable = false },
            diagnostics = { globals = { "bit", "vim", "it", "describe", "before_each", "after_each" } },
          },
        },
      },
      marksman = {},
      ocamllsp = {},
      pyright = {},
      ruff_lsp = {
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
