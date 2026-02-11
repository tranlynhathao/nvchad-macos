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
--   event = "LspAttach", -- load when LSP is attached, saves resources
--   config = function()
--     local goto_preview = require("goto-preview")
--
--     goto_preview.setup({
--       width = 100,             -- Popup width
--       height = 25,             -- Popup height
--       border = "rounded",      -- single | double | rounded | none
--       default_mappings = false,-- We assign keymaps ourselves
--       resizing_mappings = false,
--       debug = false,
--       opacity = nil,           -- Try 85 for transparency if terminal supports it
--       post_open_hook = nil,    -- Optional hook to run after opening (e.g. highlight)
--     })
--
--   end,
-- }
