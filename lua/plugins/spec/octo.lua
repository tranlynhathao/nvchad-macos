-- Octo.nvim: GitHub PR / Issue / Review / Notifications inside Neovim.
--
-- Backend: `gh` CLI (already authenticated as tranlynhathao on this machine).
-- Integrates with Telescope (pickers) + diffview (PR diff) which are both
-- already installed. Uses the GitHub API only — never mutates the local git
-- worktree unless you type an explicit `:Octo pr checkout` / `:Octo pr merge`.
--
-- Keymap policy: only READ actions are bound. Write actions (create PR,
-- merge, close issue, etc.) are typed explicitly as commands to avoid an
-- accidental muscle-memory merge/close.

---@type NvPluginSpec
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  keys = {
    { "<leader>gHp", "<cmd>Octo pr list<CR>", desc = "GitHub: PRs" },
    { "<leader>gHi", "<cmd>Octo issue list<CR>", desc = "GitHub: issues" },
    { "<leader>gHn", "<cmd>Octo notification list<CR>", desc = "GitHub: notifications" },
    { "<leader>gHs", "<cmd>Octo search<CR>", desc = "GitHub: universal search" },
    { "<leader>gHm", "<cmd>Octo mention list<CR>", desc = "GitHub: mentions" },
    { "<leader>gHR", "<cmd>Octo review start<CR>", desc = "GitHub: start PR review" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    enable_builtin = true,
    default_remote = { "upstream", "origin" },
    default_merge_method = "commit",
    ssh_aliases = {},
    reaction_viewer_hint_icon = "",
    user_icon = " ",
    timeline_marker = "",
    timeline_indent = "2",
    right_bubble_delimiter = "",
    left_bubble_delimiter = "",
    github_hostname = "",
    snippet_context_lines = 4,
    gh_env = {},
    timeout = 5000,
    ui = { use_signcolumn = true, use_signstatus = true },
    issues = { order_by = { field = "CREATED_AT", direction = "DESC" } },
    pull_requests = {
      order_by = { field = "CREATED_AT", direction = "DESC" },
      always_select_remote_on_create = false,
    },
    file_panel = { size = 10, use_icons = true },
    picker = "telescope",
  },
}
