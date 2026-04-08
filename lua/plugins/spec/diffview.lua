---@type NvPluginSpec
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory", "DiffviewRefresh" },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>gv", "<cmd>DiffviewOpen --imply-local<CR>", { desc = "Git diff view" })
    map("n", "<leader>gV", "<cmd>DiffviewClose<CR>", { desc = "Git close diff view" })
    map("n", "<leader>gl", "<cmd>DiffviewFileHistory<CR>", { desc = "Git repository history" })
    map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", { desc = "Git current file history" })
  end,
  config = function()
    local actions = require "diffview.actions"
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
          ["<tab>"] = actions.select_next_entry,
          ["<s-tab>"] = actions.select_prev_entry,
          ["gf"] = actions.goto_file,
          ["<leader>ge"] = actions.focus_files,
          ["<leader>gt"] = actions.toggle_files,
          ["<leader>gmo"] = actions.conflict_choose "ours",
          ["<leader>gmt"] = actions.conflict_choose "theirs",
          ["<leader>gm0"] = actions.conflict_choose "none",
          ["<leader>gma"] = actions.conflict_choose "all",
        },
        file_panel = {
          ["j"] = actions.next_entry,
          ["k"] = actions.prev_entry,
          ["<cr>"] = actions.select_entry,
          ["-"] = actions.toggle_stage_entry,
          ["<leader>gmo"] = actions.conflict_choose_all "ours",
          ["<leader>gmt"] = actions.conflict_choose_all "theirs",
          ["<leader>gm0"] = actions.conflict_choose_all "none",
          ["<leader>gma"] = actions.conflict_choose_all "all",
        },
      },
    }
  end,
}
