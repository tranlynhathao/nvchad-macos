-- TODO:
-- After moving to a conflict (using ]c or [c), you can use Visual mode to select the conflict area you need to handle.
-- Use <leader>cs to select the conflict region, then you can delete it manually or handle it as you wish.
-- If you want to delete the entire conflict in a region, you can use <leader>cx.

---@type NvPluginSpec
return {
  {
    "rhysd/conflict-marker.vim",
    event = "VeryLazy",
    config = function()
      vim.g.conflict_marker_begin = "<<<<<<< HEAD"
      vim.g.conflict_marker_end = ">>>>>>> "
      vim.g.conflict_marker_separator = "======="
      vim.g.conflict_marker_highlight = 1 -- Highlight conflict markers

      -- navigation
      vim.api.nvim_set_keymap("n", "]c", ":ConflictMarkerNext<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "[c", ":ConflictMarkerPrev<CR>", { noremap = true, silent = true })

      -- choose conflict area
      vim.api.nvim_set_keymap("v", "<leader>cs", ":ConflictMarkerSelect<CR>", { noremap = true, silent = true })

      -- clear conflict area
      vim.api.nvim_set_keymap("n", "<leader>cx", ":ConflictMarkerClear<CR>", { noremap = true, silent = true })
    end,
  },
}
