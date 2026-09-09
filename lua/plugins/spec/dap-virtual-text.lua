---@type NvPluginSpec
return {
  "theHamsta/nvim-dap-virtual-text",
  -- No trigger: pulled in as nvim-dap's dependency (lazy via dap's cmd/keys).
  config = function() require("nvim-dap-virtual-text").setup() end,
}
