---@type NvPluginSpec
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
    map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
    map("n", "<leader>dt", "<cmd>DiffviewToggleFiles<CR>", { desc = "Diffview toggle files" })
    map("n", "<leader>df", "<cmd>DiffviewFocusFiles<CR>", { desc = "Diffview focus files" })
  end,
  config = function()
    require("diffview").setup {
      view = {
        merge_tool = {
          layout = "diff3_mixed", -- Option: "diff2_horizontal", "diff3_horizontal", "diff3_mixed", "diff4_mixed"
          disable_diagnostics = true, -- close diagnostic in merge window
        },
        default = {
          layout = "diff2_horizontal", -- default layout for viewing diff
        },
      },
      enhanced_diff_hl = true,
      keymaps = {
        view = {
          ["<tab>"] = require("diffview.actions").select_next_entry,
          ["<s-tab>"] = require("diffview.actions").select_prev_entry,
          ["gf"] = require("diffview.actions").goto_file,
          ["<leader>e"] = require("diffview.actions").focus_files,
          ["<leader>b"] = require("diffview.actions").toggle_files,
        },
        file_panel = {
          ["j"] = require("diffview.actions").next_entry,
          ["k"] = require("diffview.actions").prev_entry,
          ["<cr>"] = require("diffview.actions").select_entry,
          ["-"] = require("diffview.actions").toggle_stage_entry,
        },
      },
    }
  end,
}
