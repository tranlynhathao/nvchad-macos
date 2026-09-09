---@type NvPluginSpec
return {
  {
    "echasnovski/mini.nvim",
    cmd = { "SessionSave", "SessionLoad", "SessionPick", "SessionStop" },
    keys = {
      { "<leader>Qs", "<cmd>SessionSave<CR>", desc = "Save project session" },
      { "<leader>Ql", "<cmd>SessionLoad<CR>", desc = "Restore project session" },
      { "<leader>Qp", "<cmd>SessionPick<CR>", desc = "Pick project session" },
      { "<leader>Qd", "<cmd>SessionStop<CR>", desc = "Stop session autosave" },
    },
    config = function()
      for command, method in pairs { SessionSave = "save", SessionLoad = "load", SessionPick = "pick", SessionStop = "stop" } do
        vim.api.nvim_create_user_command(command, function()
          local sessions = require "noah.sessions"
          sessions.setup()
          sessions[method]()
        end, {})
      end
    end,
  },
  {
    "gnikdroy/projections.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fV",
        function()
          require("telescope").extensions.projections.projections {
            action = function(selected)
              if not selected then return end
              vim.cmd.cd(vim.fn.fnameescape(selected.value))
              vim.schedule(function() require("noah.fff").find_files { cwd = selected.value } end)
            end,
          }
        end,
        desc = "Find registered workspaces (Projections)",
      },
    },
    config = function()
      require("projections").setup {}
      require("telescope").load_extension "projections"
    end,
  },
}
