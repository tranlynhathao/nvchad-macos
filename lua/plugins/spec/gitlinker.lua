-- gitlinker.nvim: copy / open GitHub permalink for current line or range.
--
-- Zero-op against local git or GitHub — pure URL construction from remote +
-- HEAD SHA + file path + line number. Safe to fire repeatedly.

---@type NvPluginSpec
return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- Yank permalink for current line / visual range (goes to `+` clipboard).
    {
      "<leader>gy",
      mode = { "n", "v" },
      function()
        require("gitlinker").get_buf_range_url("n", {
          action_callback = require("gitlinker.actions").copy_to_clipboard,
        })
      end,
      desc = "GitHub: yank permalink",
    },
    -- Open the same permalink in the system browser.
    {
      "<leader>gO",
      mode = { "n", "v" },
      function()
        require("gitlinker").get_buf_range_url("n", {
          action_callback = require("gitlinker.actions").open_in_browser,
        })
      end,
      desc = "GitHub: open line in browser",
    },
  },
  -- Deferred: `require("gitlinker.hosts")` for non-default hosts must run
  -- AFTER install (spec-load time is too early). Defaults cover github.com,
  -- which is all this config needs. Add other hosts inside a config()
  -- function if you ever need gitlab/gitea/etc.
  opts = {
    opts = {
      remote = nil,
      add_current_line_on_normal_mode = true,
      print_url = true,
    },
    mappings = nil,
  },
}
