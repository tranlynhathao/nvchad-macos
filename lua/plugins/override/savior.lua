---@type NvPluginSpec
return {
  "willothy/savior.nvim",
  config = function()
    local savior = require "savior"

    savior.setup {
      -- Define the events that trigger the saving and quitting behavior
      events = {
        immediate = {
          "FocusLost", -- Trigger when focus is lost from the buffer
          "BufLeave", -- Trigger when leaving the buffer
        },
        deferred = {
          "InsertLeave", -- Trigger after leaving insert mode
          "TextChanged", -- Trigger after text change
        },
        cancel = {
          "InsertEnter", -- Cancel actions when entering insert mode
          "BufWritePost", -- Cancel actions after writing to buffer
          "TextChanged", -- Cancel actions when text changes
        },
      },
      -- Optional callback functions that could be used for custom behavior
      callbacks = {},

      -- Define conditions for when saving/auto-save actions should occur
      conditions = {
        savior.conditions.is_file_buf, -- Only for file buffers
        savior.conditions.not_of_filetype {
          "gitcommit",
          "gitrebase", -- Exclude gitcommit and gitrebase files
        },
        savior.conditions.is_named, -- Ensure the buffer has a name
        savior.conditions.file_exists, -- Ensure the file exists
        savior.conditions.has_no_errors, -- Ensure there are no errors
      },

      -- Customizable delay times
      throttle_ms = 3000, -- Time to wait before auto-saving, in milliseconds
      interval_ms = 30000, -- Interval between auto-save checks, in milliseconds
      defer_ms = 1000, -- Time to defer actions after certain triggers

      -- Whether to show notifications from fidget.nvim
      notify = true,

      -- Default configuration options
      default_config = {
        confirm = true, -- Confirm actions before proceeding
        auto_save = false, -- Disable auto-save by default
        save_on_quit = true, -- Automatically save files on quit
      },

      -- Keymaps for saving and quitting
      -- keymaps = {
      --   save = { "<leader>w", desc = "Save file" },
      --   save_and_quit = { "<leader>q", desc = "Save and quit" },
      --   quit_without_save = { "<leader>Q", desc = "Quit without saving" },
      -- },
    }
  end,
}
