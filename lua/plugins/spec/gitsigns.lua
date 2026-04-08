---@type NvPluginSpec
return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  dependencies = "sindrets/diffview.nvim",
  ---@class Gitsigns.Config
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    preview_config = {
      border = "rounded",
    },
    update_debounce = 100, -- optimization for big repositories
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
      virt_text_pos = "eol",
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

    on_attach = function(bufnr)
      local gs = require "gitsigns"
      local map = require("noah.utils").buf_map
      local function visual_range()
        local start_line = vim.fn.line "."
        local end_line = vim.fn.line "v"
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        return { start_line, end_line }
      end

      map(bufnr, "n", "<leader>ghs", gs.stage_hunk, { desc = "Git stage hunk" })
      map(bufnr, "x", "<leader>ghs", function()
        gs.stage_hunk(visual_range())
      end, { desc = "Git stage selected hunk" })
      map(bufnr, "n", "<leader>ghr", gs.reset_hunk, { desc = "Git reset hunk" })
      map(bufnr, "x", "<leader>ghr", function()
        gs.reset_hunk(visual_range())
      end, { desc = "Git reset selected hunk" })
      map(bufnr, "n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Git undo stage hunk" })
      map(bufnr, "n", "<leader>ghS", gs.stage_buffer, { desc = "Git stage buffer" })
      map(bufnr, "n", "<leader>ghU", gs.reset_buffer_index, { desc = "Git unstage buffer" })
      map(bufnr, "n", "<leader>ghR", gs.reset_buffer, { desc = "Git reset buffer" })
      map(bufnr, "n", "<leader>ghp", gs.preview_hunk, { desc = "Git preview hunk" })
      map(bufnr, "n", "<leader>ghd", gs.diffthis, { desc = "Git diff this buffer" })
      map(bufnr, "n", "<leader>ghD", function()
        gs.diffthis "~"
      end, { desc = "Git diff against previous revision" })
      map(bufnr, "n", "<leader>ghb", function()
        gs.blame_line { full = true }
      end, { desc = "Git blame line" })
      map(bufnr, "n", "<leader>ght", gs.toggle_current_line_blame, { desc = "Git toggle line blame" })
      map(bufnr, "n", "<leader>ghx", gs.toggle_deleted, { desc = "Git toggle deleted lines" })
      map(bufnr, { "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })

      map(bufnr, "n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal { "]c", bang = true }
        else
          gs.nav_hunk "next"
        end
      end, { desc = "Git next hunk" })

      map(bufnr, "n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal { "[c", bang = true }
        else
          gs.nav_hunk "prev"
        end
      end, { desc = "Git previous hunk" })
    end,
  },
}
