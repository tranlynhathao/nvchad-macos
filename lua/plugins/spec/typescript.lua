---@type NvPluginSpec
return {
  "jose-elias-alvarez/typescript.nvim",
  config = function()
    require("typescript").setup {
      server = {
        on_attach = function(client, bufnr)
          local ts_utils = require("typescript").utils
          -- local ts = require "typescript"
          -- vim.keymap.set("n", "gi", ts.go_to_source_definition, { buffer = bufnr, desc = "Go to import source" })
          ts_utils.setup {}
          ts_utils.setup_client(client)
        end,
      },
    }
  end,
}
