---@type NvPluginSpec
return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.dotnet_format.with {
          extra_args = { "--include", "." },
        },
      },
    }
  end,
}
