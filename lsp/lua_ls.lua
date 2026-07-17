-- Lua language server (sumneko/lua-language-server).
return {
  settings = {
    Lua = {
      hint = { enable = true },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
