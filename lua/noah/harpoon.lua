local M = {}

function M.toggle_menu()
  require("lazy").load { plugins = { "harpoon" } }

  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list(), {
    title = " Harpoon btw ",
    title_pos = "center",
    border = "rounded",
    ui_width_ratio = 0.40,
  })
end

return M
