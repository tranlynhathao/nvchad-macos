local M = {}

---@alias OnAttach fun(client: vim.lsp.Client, bufnr: integer)
---@alias OnInit fun(client: vim.lsp.Client, initialize_result: lsp.InitializeResult)

---@type OnAttach
local on_attach = function(client, bufnr)
  -- Small helper: single-line buffer keymap with optional overrides.
  local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = bufnr }, opts or {})) end

  -- Capability-gated keymaps. `client:supports_method(...)` (Neovim 0.11+)
  -- is the canonical way to probe LSP support - it walks
  -- server_capabilities + resolved_capabilities + dynamic registration,
  -- so it stays correct even when a server registers a capability
  -- lazily via `client/registerCapability`.
  local ms = vim.lsp.protocol.Methods

  if client:supports_method(ms.textDocument_hover) then map("n", "K", vim.lsp.buf.hover) end
  if client:supports_method(ms.textDocument_definition) then map("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition" }) end
  if client:supports_method(ms.textDocument_implementation) then map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP go to implementation" }) end
  if client:supports_method(ms.textDocument_declaration) then map("n", "<leader>gd", vim.lsp.buf.declaration, { desc = "LSP go to declaration" }) end
  if client:supports_method(ms.textDocument_signatureHelp) then
    map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP show signature help" })
  end

  -- Unconditional keymaps (function exists on any attached client).
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP add workspace folder" })
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP remove workspace folder" })
  map("n", "<leader>gr", vim.lsp.buf.references, { desc = "LSP show references" })
  map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "LSP go to type definition" })

  -- Workspace list: use vim.notify instead of raw print so it lands in noice
  -- history and respects diagnostic UI. `vim.iter()` flattens the paths and
  -- joins with a newline in one chain.
  map(
    "n",
    "<leader>wl",
    function()
      vim.notify(vim.iter(vim.lsp.buf.list_workspace_folders()):join "\n", vim.log.levels.INFO, {
        title = "LSP workspace folders",
      })
    end,
    { desc = "LSP list workspace folders" }
  )

  map("n", "<leader>ra", function() require "nvchad.lsp.renamer"() end, { desc = "LSP rename" })

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
end

---@param custom_on_attach? OnAttach
---@return OnAttach
M.create_on_attach = function(custom_on_attach)
  return function(client, bufnr)
    on_attach(client, bufnr)
    if custom_on_attach then custom_on_attach(client, bufnr) end
  end
end

---@type OnInit
M.on_init = function(client, _)
  if client:supports_method "textDocument/semanticTokens" then client.server_capabilities.semanticTokensProvider = nil end
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

return M
