---@type NvPluginSpec
return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "VeryLazy" }, -- hoặc "WinNew"
  config = function()
    require("colorful-winsep").setup {
      -- choose between "signle", "rounded", "bold" and "double".
      -- Or pass a tbale like this: { "─", "│", "┌", "┐", "└", "┘" },
      border = "bold",
      excluded_ft = { "packer", "TelescopePrompt", "mason" },
      highlight = {
        fg = "#957CC6",
        bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
      },
      animate = {
        enabled = "shift", -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
        shift = { delta_time = 0.1, smooth_speed = 1, delay = 3 },
        progressive = { vertical_delay = 20, horizontal_delay = 2 },
      },
      indicator_for_2wins = {
        position = "center",
        symbols = {
          start_left = "󱞬",
          end_left = "󱞪",
          start_down = "󱞾",
          end_down = "󱟀",
          start_up = "󱞢",
          end_up = "󱞤",
          start_right = "󱞨",
          end_right = "󱞦",
        },
      },
    }
  end,
}
