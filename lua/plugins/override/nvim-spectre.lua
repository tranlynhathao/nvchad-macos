---@type NvPluginSpec
return {
  "nvim-pack/nvim-spectre",
  event = "VeryLazy",
  name = "spectre",
  config = true,
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>sp", function()
      require("spectre").open()
    end, { desc = "Spectre: Search and Replace" })

    map("n", "<leader>sw", function()
      require("spectre").open_visual { select_word = true }
    end, { desc = "Spectre: Search current word" })

    map("v", "<leader>sw", function()
      require("spectre").open_visual()
    end, { desc = "Spectre: Search selection" })

    map("n", "<leader>sf", function()
      require("spectre").open_file_search { select_word = true }
    end, { desc = "Spectre: Search in current file" })
  end,
}
