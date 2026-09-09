---@type NvPluginSpec
--
-- Tier-3 LSP orchestrator.
--
-- Per-server configs live in `~/.config/nvim/lsp/<name>.lua` and are auto-
-- discovered by Neovim (0.11+) whenever `vim.lsp.enable("<name>")` runs.
-- nvim-lspconfig ships defaults (cmd / filetypes / root_markers) for every
-- server through the same runtime dir mechanism; user files merge on top.
--
-- This file only does orchestration:
--   * global capabilities via `vim.lsp.config("*", ...)`
--   * LspAttach autocmd: buffer keymaps + per-server capability tweaks
--   * filetype -> servers enable-on-first-open (lazy startup)
--   * zls auto-restart on crash
--   * diagnostic UI (vim.diagnostic.config)
--
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "mason-org/mason.nvim", version = "^1.0.0" },
    -- cmp-tw2css removed: was declared as dep but never registered as a cmp
    -- source. Every unused source still costs disk load + lazy resolution.
    "hoffs/omnisharp-extended-lsp.nvim",
    "b0o/schemastore.nvim",
  },

  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    local nlsp = require "noah.lsp"

    -- 1) Wildcard: default capabilities applied to every enabled server.
    --    Per-server `lsp/<name>.lua` files can still override.
    vim.lsp.config("*", {
      capabilities = nlsp.capabilities,
    })

    -- 2) LspAttach: buffer keymaps + per-server capability tweaks.
    --    Runs once per (client, buffer) pair. Replaces the old
    --    per-server on_attach spread across noah/LSP/languages/*.lua.
    local no_format = {
      -- Servers whose formatting we bypass in favour of conform.nvim.
      astro = true,
      clangd = true,
      cssls = true,
      denols = true,
      gopls = true,
      html = true,
      intelephense = true,
      lua_ls = true,
      omnisharp = true,
      pyright = true,
      ruff = true,
      svelte = true,
      ts_ls = true,
      volar = true,
      vtsls = true,
    }

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        -- ruff hover is empty; let pyright provide hover.
        if client.name == "ruff" then client.server_capabilities.hoverProvider = false end

        -- bashls: stop the client when the buffer is a dotenv file.
        if client.name == "bashls" then
          local filename = vim.api.nvim_buf_get_name(args.buf)
          if filename:match "%.env$" then
            vim.schedule(function() vim.lsp.stop_client(client.id) end)
            return
          end
        end

        -- Turn off formatting for servers that shouldn't own it (conform does).
        if no_format[client.name] then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        if client:supports_method "textDocument/semanticTokens" then client.server_capabilities.semanticTokensProvider = nil end

        -- Shared keymaps (K, gd, gi, <leader>rn, <leader>ca, etc.).
        -- noah.lsp exposes create_on_attach() -> returns the real handler.
        nlsp.create_on_attach()(client, args.buf)
      end,
    })

    -- 3) Diagnostic UI. Owned here so it applies before any client attaches.
    --    tiny-inline-diagnostic renders the inline message (see its spec),
    --    so we disable Neovim's built-in virtual_text to avoid overlap.
    vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    }

    vim.fn.sign_define("CodeActionSign", { text = "󰉁", texthl = "CodeActionSignHl" })

    -- 4) Enable-on-first-open: keeps startup fast while still auto-attaching
    --    the right server the moment the user opens a matching filetype.
    local filetype_to_servers = {
      go = { "gopls" },
      gomod = { "gopls" },
      gowork = { "gopls" },
      gotmpl = { "gopls" },
      typescript = { "ts_ls", "eslint" },
      javascript = { "ts_ls", "eslint" },
      javascriptreact = { "ts_ls", "eslint" },
      typescriptreact = { "ts_ls", "eslint" },
      python = { "pyright", "ruff" },
      lua = { "lua_ls" },
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
      objc = { "clangd" },
      haskell = { "hls" },
      ocaml = { "ocamllsp" },
      sass = { "somesass_ls" },
      cs = { "omnisharp" },
      kotlin = { "kotlin_language_server" },
      terraform = { "terraformls" },
      hcl = { "terraformls" },
      php = { "intelephense" },
      svelte = { "svelte", "ts_ls" },
      vue = { "ts_ls", "eslint", "volar" },
      elixir = { "elixirls" },
      erlang = { "erlangls" },
      nim = { "nimls" },
      sql = { "sqlls" },
      mysql = { "sqlls" },
      plsql = { "sqlls" },
      -- rust intentionally omitted: rustaceanvim manages the rust LSP client.
    }

    local enabled = {}
    local function enable_for_ft(ft)
      local list = filetype_to_servers[ft]
      if not list then return end
      for _, name in ipairs(list) do
        if not enabled[name] then
          enabled[name] = true
          pcall(vim.lsp.enable, name)
        end
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("LspLazyEnable", { clear = true }),
      callback = function(ev) enable_for_ft(ev.match) end,
    })

    -- Handle buffers that were already open before this config ran.
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) then enable_for_ft(vim.bo[bufnr].filetype) end
    end

    -- 5) zls auto-restart. zls occasionally exits with error 1 mid-session;
    --    re-enable on next Zig buffer entry with a small cooldown.
    local zls_cd = 0
    local function try_restart_zls()
      local now = vim.uv.now()
      if now - zls_cd < 3000 then return end
      zls_cd = now
      local ok = pcall(vim.cmd, "LspRestart zls")
      if not ok then pcall(vim.lsp.enable, "zls") end
    end

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("ZlsAutoRestart", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "zig" then vim.defer_fn(try_restart_zls, 1000) end
      end,
    })
  end,
}
