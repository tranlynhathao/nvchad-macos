---@type NvPluginSpec
return {
  "williamboman/mason.nvim",
  opts = {
    ui = { border = "rounded" },
    ensure_installed = {
      "eslint-ls",
      "typescript-language-server",
      "prettier",
    },
  },
}
