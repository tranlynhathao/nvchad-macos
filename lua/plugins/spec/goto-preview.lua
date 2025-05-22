-- ---@type NvPluginSpec
-- return {
--   "rmagatti/goto-preview",
--   event = "LspAttach",
--   init = function()
--     local gtp = require "goto-preview"
--
--     vim.keymap.set("n", "<leader>q", function()
--       gtp.dismiss_preview(0)
--     end, { desc = "Close current definition preview" })
--   end,
--   config = function()
--     require("goto-preview").setup {
--       default_mappings = true,
--     }
--   end,
-- }

---@type NvPluginSpec
return {
  "rmagatti/goto-preview",
  event = "LspAttach",
  config = function()
    local gtp = require "goto-preview"

    gtp.setup {
      width = 100,
      height = 25,
      border = "rounded",
      default_mappings = false,
    }

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    local function d(desc)
      return vim.tbl_extend("force", opts, { desc = desc })
    end

    map("n", "gp", gtp.goto_preview_definition, d "Preview Definition")
    map("n", "gI", gtp.goto_preview_implementation, d "Preview Implementation")
    map("n", "gT", gtp.goto_preview_type_definition, d "Preview Type Definition")
    map("n", "gR", gtp.goto_preview_references, d "Preview References")
    map("n", "gP", gtp.close_all_win, d "Close all previews")

    map("n", "<leader>q", function()
      gtp.dismiss_preview(0)
    end, { desc = "Close current preview" })
  end,
}

-- ---@type NvPluginSpec
-- return {
--   "rmagatti/goto-preview",
--   event = "LspAttach", -- load khi có LSP, tiết kiệm tài nguyên
--   config = function()
--     local goto_preview = require("goto-preview")
--
--     goto_preview.setup({
--       width = 100,             -- Chiều rộng của popup
--       height = 25,             -- Chiều cao của popup
--       border = "rounded",      -- Bo viền: single | double | rounded | none
--       default_mappings = false,-- Chúng ta tự gán keymap
--       resizing_mappings = false,
--       debug = false,
--       opacity = nil,           -- Bạn có thể thử 85 nếu muốn transparency (nếu terminal hỗ trợ)
--       post_open_hook = nil,    -- Có thể dùng để highlight gì đó sau khi mở
--     })
--
--   end,
-- }
