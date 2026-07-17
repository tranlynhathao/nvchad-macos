-- TypeScript / JavaScript language server (ts_ls).
-- Also drives Vue via the @vue/typescript-plugin.

local function resolve_tsdk(root_dir)
  local ok, util = pcall(require, "lspconfig.util")
  if ok and util.get_typescript_server_path then
    local p = util.get_typescript_server_path(root_dir or vim.uv.cwd())
    if p and p ~= "" and vim.fn.isdirectory(p) == 1 then return p end
  end
  local mason_tsdk = vim.fn.stdpath "data" .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
  if vim.fn.isdirectory(mason_tsdk) == 1 then return mason_tsdk end
  return nil
end

local vue_language_server_path = vim.fn.stdpath "data" .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local function organize_imports()
  vim.lsp.execute_command {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
end

return {
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  init_options = {
    typescript = { tsdk = resolve_tsdk() },
    preferences = { disableSuggestions = true },
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },
  commands = {
    OrganizeImports = { organize_imports, description = "Organize Imports" },
  },
  before_init = function(_, config)
    config.init_options = config.init_options or {}
    config.init_options.typescript = config.init_options.typescript or {}
    config.init_options.typescript.tsdk = resolve_tsdk(config.root_dir)
  end,
}
