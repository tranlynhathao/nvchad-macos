---@type NvPluginSpec
return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit kind=split<CR>", desc = "Git status (Neogit)" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit popup" },
    { "<leader>gM", "<cmd>Neogit merge<CR>", desc = "Git merge popup" },
    { "<leader>gR", "<cmd>Neogit rebase<CR>", desc = "Git rebase popup" },
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull popup" },
    { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push popup" },
  },
  opts = {
    kind = "split",
    integrations = {
      telescope = true,
      diffview = true,
    },
    diff_viewer = "diffview",
    status = {
      show_head_commit_hash = true,
      recent_commit_count = 12,
      HEAD_folded = false,
      mode_padding = 2,
    },
    commit_editor = {
      kind = "auto",
      show_staged_diff = true,
      staged_diff_split_kind = "vsplit",
      spell_check = true,
    },
    rebase_editor = {
      kind = "auto",
    },
    merge_editor = {
      kind = "auto",
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "neogit")
    require("neogit").setup(opts)
  end,
}
