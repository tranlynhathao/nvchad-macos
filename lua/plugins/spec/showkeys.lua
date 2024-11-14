---@type NvPluginSpec
return {
  "nvchad/showkeys",
  cmd = { "ShowkeysToggle" },
  opts = {
    show_count = true, -- Display the number of times each key combination is pressed
    max_keys = 5, -- Display up to 5 recently pressed key combinations
    delay = 500, -- Delay (ms) after pressing a key before it is removed from the list
    mode = { "n", "i", "v", "x" }, -- Show keys pressed in Normal, Insert, Visual, and Visual Block modes
    position = "bottom_right", -- Display position, can choose "bottom_left", "top_right", etc.
    separator = " -> ", -- Use a separator character between key combinations for better readability
    ignore_keys = { "<ESC>", "<CR>" }, -- Do not display certain key presses
  },
  -- config = function(_, opts)
  --   require("showkeys").setup(opts)
  -- end,
}
