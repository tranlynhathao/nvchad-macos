---@type NvPluginSpec
return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "LspAttach",
  opts = {
    highlight = "Comment",
    prefix = "← ",
    enabled = true,
    max_line_len = 80,
    debounce = 150,
    show_if_no_lsp = false,
  },
  -- config = function(_, opts)
  --   require("nvim-lsp-endhints").setup(opts)
  -- end,
}
