---@type NvPluginSpec
return {
  "jose-elias-alvarez/typescript.nvim",
  config = function()
    require("typescript").setup {
      server = {
        on_attach = function(client, bufnr)
          local ts_utils = require("typescript").utils
          ts_utils.setup {}
          ts_utils.setup_client(client)
        end,
      },
    }
  end,
}
