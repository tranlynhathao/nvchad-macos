---@type NvPluginSpec
return {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      filetype = {
        javascript = {
          require("formatter.filetypes.javascript").prettier,
        },
        typescript = {
          require("formatter.filetypes.typescript").prettier,
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    }
  end,
  config = function(_, opts)
    require("formatter").setup(opts)

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      command = "FormatWriteLock",
    })
  end,
}
