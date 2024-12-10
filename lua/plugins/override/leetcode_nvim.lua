---@type NvPluginSpec
return {
  "thenicealex/leetcode-nvim",
  cmd = { "LCode" },
  opts = {
    language = "python",
    browser = "firefox",
  },
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function(_, opts)
    require("leetcode").setup(opts)
  end,
}
