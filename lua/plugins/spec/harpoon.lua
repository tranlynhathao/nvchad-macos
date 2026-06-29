---@type NvPluginSpec
return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<A-q>", mode = "n", desc = "Harpoon Go to 1st buffer" },
    { "<A-w>", mode = "n", desc = "Harpoon Go to 2nd buffer" },
    { "<A-e>", mode = "n", desc = "Harpoon Go to 3rd buffer" },
    { "<A-r>", mode = "n", desc = "Harpoon Go to 4th buffer" },
    { "<A-t>", mode = "n", desc = "Harpoon Go to 5th buffer" },
    { "<A-y>", mode = "n", desc = "Harpoon Go to 6th buffer" },
    { "<A-a>", mode = "n", desc = "Harpoon Add buffer" },
    { "<A-d>", mode = "n", desc = "Harpoon Remove buffer" },
    { "<A-m>", mode = "n", desc = "Harpoon Open menu" },
    { "<A-,>", mode = "n", desc = "Harpoon Go to prev buffer" },
    { "<A-.>", mode = "n", desc = "Harpoon Go to next buffer" },
  },
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local map = vim.keymap.set
    local harpoon = require "harpoon"

    harpoon:setup {}

    map("n", "<A-q>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon Go to 1st buffer" })
    map("n", "<A-w>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon Go to 2nd buffer" })
    map("n", "<A-e>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon Go to 3rd buffer" })
    map("n", "<A-r>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon Go to 4th buffer" })
    map("n", "<A-t>", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon Go to 5th buffer" })
    map("n", "<A-y>", function()
      harpoon:list():select(6)
    end, { desc = "Harpoon Go to 6th buffer" })
    map("n", "<A-a>", function()
      harpoon:list():add()
    end, { desc = "Harpoon Add buffer" })
    map("n", "<A-d>", function()
      harpoon:list():remove()
    end, { desc = "Harpoon Remove buffer" })
    map("n", "<A-m>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        title = " Harpoon btw ",
        title_pos = "center",
        border = "rounded",
        ui_width_ratio = 0.40,
      })
    end, { desc = "Harpoon Open menu" })
    map("n", "<A-,>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon Go to prev buffer" })
    map("n", "<A-.>", function()
      harpoon:list():next()
    end, { desc = "Harpoon Go to next buffer" })
  end,
}
