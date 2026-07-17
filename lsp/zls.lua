-- Zig language server. Auto-restart on crash is handled in
-- lua/plugins/override/lspconfig.lua's LspDetach autocmd.
return {
  init_options = {
    -- Reduce crashes: disable build-on-save when build.zig is missing or fails.
    enable_build_on_save = false,
  },
}
