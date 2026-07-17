-- Astro LSP. Uses TypeScript SDK for type analysis inside .astro files.
local function resolve_tsdk(root_dir)
  local ok, util = pcall(require, "lspconfig.util")
  if ok and util.get_typescript_server_path then
    local p = util.get_typescript_server_path(root_dir or vim.uv.cwd())
    if p and p ~= "" and vim.fn.isdirectory(p) == 1 then return p end
  end
  local mason_tsdk = vim.fn.stdpath "data" .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
  if vim.fn.isdirectory(mason_tsdk) == 1 then return mason_tsdk end
end

return {
  init_options = {
    typescript = { tsdk = resolve_tsdk() },
  },
  before_init = function(_, config)
    config.init_options = config.init_options or {}
    config.init_options.typescript = config.init_options.typescript or {}
    config.init_options.typescript.tsdk = config.init_options.typescript.tsdk or resolve_tsdk(config.root_dir)
  end,
}
