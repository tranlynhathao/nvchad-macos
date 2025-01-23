local M = {}

---@alias OnAttach fun(client: vim.lsp.Client, bufnr: integer)
---@alias OnInit fun(client: vim.lsp.Client, initialize_result: lsp.InitializeResult)

---@type OnAttach
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, opts)
    local options = { buffer = bufnr }
    if opts then
      options = vim.tbl_deep_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  map("n", "K", vim.lsp.buf.hover, {})
  map("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition" })
  map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP go to implementation" })
  map("n", "<leader>gd", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
  map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP show signature help" })
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP add workspace folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP remove workspace folder" })
  map("n", "<leader>gr", vim.lsp.buf.references, { desc = "LSP show references" })
  map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "LSP go to type definition" })
  -- map("n", "<leader>rn", vim.lsp.buf.rename, {})
  -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

  vim.keymap.set("n", "<leader>me", function()
    local filetype = vim.bo.filetype
    local symbols_map = {
      python = "function",
      javascript = "function",
      typescript = "function",
      java = "class",
      lua = "function",
      go = { "method", "struct", "interface" },
    }
    local symbols = symbols_map[filetype] or "function"
    require("telescope.builtin").lsp_document_symbols { symbols = symbols }
  end, {})

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "LSP list workspace folders" })

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, { desc = "LSP rename" })

  -- UI tweaks
  local border = "rounded"
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }) -- vim.lsp.buf.hover()
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  }) -- vim.lsp.buf.signature_help()
end

---@param custom_on_attach? OnAttach
---@return OnAttach # A new function that combines default and custom on_attach behaviour
M.create_on_attach = function(custom_on_attach)
  return function(client, bufnr)
    on_attach(client, bufnr)

    if custom_on_attach then
      custom_on_attach(client, bufnr)
    end
  end
end

---@type OnInit
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lspconfig = require "lspconfig"

lspconfig.configs.prolog_lsp = {
  default_config = {
    cmd = { "swipl", "--lsp" },
    filetypes = { "prolog" },
    root_dir = function(startpath)
      return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
    end,
    settings = {},
  },
}

-- lspconfig.cssls.setup {
--   cmd = { "css-languageserver", "--stdio" },
--   filetypes = { "css", "scss", "less" },
--   root_dir = require("lspconfig.util").root_pattern("package.json", ".git"),
--   settings = {
--     css = {
--       validate = true,
--     },
--     less = {
--       validate = true,
--     },
--     scss = {
--       validate = true,
--     },
--   },
-- }

lspconfig.rust_analyzer.setup {
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, opts)
      local options = { buffer = bufnr }
      if opts then
        options = vim.tbl_deep_extend("force", options, opts)
      end
      vim.keymap.set(mode, lhs, rhs, options)
    end

    map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format { async = true }
      end,
    })
  end,

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      rustfmt = {
        enable = true,
        extraArgs = { "--edition=2021" },
      },
    },
  },
}

M.capabilities = capabilities

M.inlay_hints_settings = {
  parameterNames = {
    enabled = "all",
  },
  parameterTypes = {
    enabled = true,
  },
  variableTypes = {
    enabled = true,
  },
  propertyDeclarationTypes = {
    enabled = true,
  },
  functionLikeReturnTypes = {
    enabled = true,
  },
}

return M
