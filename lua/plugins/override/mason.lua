---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      "eslint-lsp",
      "typescript-language-server",
      "prettier",
      "tailwindcss-language-server",
    },
  },
}
