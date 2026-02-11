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
        -- Show diagnostic source (e.g. "eslint", "typescript")
        show_source = true,

        -- Prefer showing multiple diagnostics on the same line
        multilines = true,

        -- Overflow: how to handle messages that are too long
        overflow = {
          mode = "wrap", -- "wrap" | "none"
        },

        -- Only show diagnostic on the line under the cursor
        -- false = show all, true = current line only
        throttle = 20, -- milliseconds
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
