---@type NvPluginSpec
return {
  "tzachar/highlight-undo.nvim",
  event = "BufReadPost",
  opts = {
    hlgroup = "HighlightUndo",
    duration = 300,
    pattern = { "*" },
    ignored_filetypes = {
      "neo-tree",
      "fugitive",
      "TelescopePrompt",
      "mason",
      "lazy",
    },
    -- ignore_cb = nil,
  },
  config = function(_, opts)
    require("highlight-undo").setup(opts)
  end,
}
