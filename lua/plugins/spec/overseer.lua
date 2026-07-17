---@type NvPluginSpec
-- overseer.nvim: async task runner. Replace the "toggle terminal, cargo run,
-- wait, alt-tab back" cycle with `:OverseerRun` -> pick a template -> task
-- runs in a floating panel, results streamed live.
--
-- Auto-discovers common tasks: cargo, npm, make, zig build, cmake, etc.
-- No config needed for most; write custom templates for project-specific
-- pipelines in ~/.config/nvim/lua/overseer/templates/.
return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerOpen",
    "OverseerClose",
    "OverseerRunCmd",
    "OverseerLoadBundle",
    "OverseerQuickAction",
    "OverseerTaskAction",
  },
  keys = {
    { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: toggle panel" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: run task" },
    { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Overseer: run shell command" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer: quick action on last task" },
  },
  opts = {
    strategy = "toggleterm",
    templates = { "builtin" },
    task_list = {
      direction = "bottom",
      min_height = 12,
      max_height = 20,
      default_detail = 1,
    },
  },
}
