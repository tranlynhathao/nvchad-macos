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

-- ---@type NvPluginSpec
-- return {
--   "nvim-pack/nvim-spectre",
--   event = "VeryLazy",
--   name = "spectre",
--
--   config = function()
--     require("spectre").setup {
--       highlight = {
--         ui = "String",
--         search = "Search",
--         replace = "DiffDelete",
--       },
--       mapping = {
--         ["toggle_line"] = {
--           map = "dd",
--           cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
--           desc = "Toggle current item",
--         },
--         ["enter_file"] = {
--           map = "<CR>",
--           cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
--           desc = "Open file on cursor",
--         },
--         ["send_to_qf"] = {
--           map = "<leader>sq",
--           cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
--           desc = "Send all to quickfix",
--         },
--       },
--       find_engine = {
--         ["rg"] = {
--           cmd = "rg",
--           args = {
--             "--color=never",
--             "--no-heading",
--             "--with-filename",
--             "--line-number",
--             "--column",
--           },
--           options = {
--             ["ignore-case"] = {
--               value = "--ignore-case",
--               icon = "[I]",
--               desc = "Ignore case",
--             },
--             ["hidden"] = {
--               value = "--hidden",
--               desc = "Search hidden files",
--             },
--           },
--         },
--       },
--       replace_engine = {
--         ["sed"] = {
--           cmd = "sed",
--           args = {},
--         },
--       },
--     }
--   end,
--
--   init = function()
--     local map = vim.keymap.set
--
--     -- Mở Spectre toàn repo
--     map("n", "<leader>sp", function()
--       require("spectre").open()
--     end, { desc = "Spectre: Search and Replace" })
--
--     -- Tìm từ hiện tại (normal/visual)
--     map("n", "<leader>sw", function()
--       require("spectre").open_visual { select_word = true }
--     end, { desc = "Spectre: Search current word" })
--
--     map("v", "<leader>sw", function()
--       require("spectre").open_visual()
--     end, { desc = "Spectre: Search selection" })
--
--     -- Tìm trong file hiện tại
--     map("n", "<leader>sf", function()
--       require("spectre").open_file_search { select_word = true }
--     end, { desc = "Spectre: Search in current file" })
--
--     -- Gửi kết quả Spectre sang quickfix
--     map("n", "<leader>sq", function()
--       require("spectre.actions").send_to_qf()
--     end, { desc = "Spectre: Send to quickfix" })
--
--     -- Tìm TODO toàn repo
--     map("n", "<leader>st", function()
--       require("spectre").open { search_text = "TODO" }
--     end, { desc = "Spectre: Search TODOs" })
--   end,
-- }
