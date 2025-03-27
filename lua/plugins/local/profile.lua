---@type NvPluginSpec
return {
  "stevearc/profile.nvim",
  config = function()
    require("profile").instrument_autocmds()
  end,
}
