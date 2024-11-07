---@type NvPluginSpec
return {
  "mskelton/termicons.nvim",
  requires = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- termicons.nvim configuration
    require("termicons").setup()
  end,
  build = false,
}
