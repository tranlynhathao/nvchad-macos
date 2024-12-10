---@type NvPluginSpec
return {
  "akinsho/git-conflict.nvim", -- Install the git-conflict plugin
  config = function()
    -- Configure the default settings for the git-conflict plugin
    require("git-conflict").setup {
      -- Merge mode options
      default_mappings = true, -- Enable the default key mappings of the plugin
      disable_diagnostics = false, -- If enabled, disables git conflict error messages

      -- Configure the UI for git-conflict (by default, there are 3 sections)
      -- You can decide whether you want to display these sections
      highlights = {
        -- You can change the colors for the conflict sections
        conflict = "DiffText", -- Use the DiffText color for conflicts
        ours = "DiffAdd", -- Color for our side
        theirs = "DiffDelete", -- Color for the other person's side
      },

      -- Default key mappings for handling git conflicts
      keymaps = {
        -- Keymap to select "ours" (your side)
        accept_current = "<leader>co", -- select your part
        -- Keymap to select "theirs" (the other person's side)
        accept_theirs = "<leader>ct", -- select the other person's part
        -- Keymap to skip the conflict
        skip = "<leader>csk", -- skip the conflict and move on
        -- Keymap to reset all conflicts
        reset = "<leader>cr", -- remove all conflicts
      },

      -- Enable auto-commit when you resolve a conflict
      auto_commit = true, -- automatically commit when resolving the conflict

      -- Automatically merge when no conflicts remain
      auto_merge = true, -- automatically finish the merge when no conflicts are left
    }
  end,
}
