---@type NvPluginSpec
return {
  "neoclide/coc.nvim",
  enabled = false,
  branch = "release",
  config = function()
    vim.g.coc_global_extensions = {
      "coc-ruby",
      "coc-go",
      "coc-rust-analyzer",
      "coc-kotlin",
      "coc-dart",
      "coc-phpls",
      "coc-java",
    }
  end,
}
