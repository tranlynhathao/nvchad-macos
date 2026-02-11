local M = {}

---@alias OnAttach fun(client: vim.lsp.Client, bufnr: integer)
---@alias OnInit fun(client: vim.lsp.Client, initialize_result: lsp.InitializeResult)

---@type OnAttach
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, opts)
    local options = { buffer = bufnr }
    if opts then
      options = vim.tbl_deep_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
  end

  -- Keymaps
  if client.server_capabilities.hoverProvider then
    map("n", "K", vim.lsp.buf.hover, {})
  end
  if client.server_capabilities.definitionProvider then
    map("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition" })
  end
  if client.server_capabilities.implementationProvider then
    map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP go to implementation" })
  end
  if client.server_capabilities.declarationProvider then
    map("n", "<leader>gd", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
  end
  if client.server_capabilities.signatureHelpProvider then
    map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP show signature help" })
  end
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP add workspace folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP remove workspace folder" })
  map("n", "<leader>gr", vim.lsp.buf.references, { desc = "LSP show references" })
  map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "LSP go to type definition" })

  -- Custom keymaps
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "LSP list workspace folders" })

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, { desc = "LSP rename" })

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

  -- UI tweaks
  local border = "rounded"
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  })
end

---@param custom_on_attach? OnAttach
---@return OnAttach
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

-- Capabilities
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
M.capabilities = capabilities

-- Rust Analyzer configuration
-- COMMENTED OUT: rustaceanvim plugin handles this
-- vim.lsp.config("rust_analyzer", {
--   on_attach = function(client, bufnr)
--     on_attach(client, bufnr) -- Use shared on_attach
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       pattern = "*.rs",
--       callback = function()
--         if client.server_capabilities.documentFormattingProvider then
--           vim.lsp.buf.format { async = true }
--         end
--       end,
--     })
--   end,
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = {
--         allFeatures = true,
--         loadOutDirsFromCheck = true,
--         runBuildScripts = true,
--       },
--       checkOnSave = {
--         command = "clippy",
--       },
--       rustfmt = {
--         enable = true,
--         extraArgs = { "--edition=2021" },
--       },
--     },
--   },
-- })

return M
