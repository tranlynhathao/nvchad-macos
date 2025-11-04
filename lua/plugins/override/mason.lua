---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      "eslint-lsp",
      "typescript-language-server",
      "prettier",
      "tailwindcss-language-server",
      "goimports",
      "gopls",
      "lua-language-server",
      "stylua",
      "json-lsp",
      "yaml-language-server",
      "bash-language-server",
      "pyright",
      "mypy",
      "ruff",
    },
  },
}
