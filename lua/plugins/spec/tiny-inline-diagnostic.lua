---@type NvPluginSpec
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000, -- Load early to override default diagnostic display
  config = function()
    -- Disable vim default virtual_text so tiny-inline-diagnostic can show inline
    vim.diagnostic.config { virtual_text = false }

    require("tiny-inline-diagnostic").setup {
      -- Preset: "modern" | "classic" | "minimal" | "ghost"
      preset = "modern",

      options = {
        -- Show diagnostic source only when there are multiple sources on the
        -- same line (matches vim.diagnostic native "if_many" idea).
        show_source = { enabled = true, if_many = true },

        -- Only render on the cursor line — other lines get sign + underline
        -- only. Prevents long diagnostic boxes covering multiple lines of
        -- code (was the top complaint for pwntools files).
        multiple_diag_under_cursor = true,
        multilines = {
          enabled = true,
          always_show = false, -- only expand when cursor is on the line
        },

        -- Truncate long messages instead of wrapping — keeps line height
        -- constant.
        overflow = {
          mode = "wrap",
          padding = 4,
        },

        -- Debounce cursor movement redraws.
        throttle = 20,

        -- Break the message and virtual text below the line if it would
        -- push past the window edge.
        softwrap = 30,

        -- Priority ordering: ERROR first, then WARN, INFO, HINT.
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },
      },

      -- Signs for different severity levels
      signs = {
        left = "",
        right = "",
        diag = "●",
        arrow = "    ",
        up_arrow = "    ",
        vertical = " │",
        vertical_end = " └",
      },

      -- Highlight groups for diagnostic types
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
        arrow = "NonText",
        background = "CursorLine", -- Message background
        mixing_color = "None", -- Color to mix background and foreground
      },
    }
  end,
}
