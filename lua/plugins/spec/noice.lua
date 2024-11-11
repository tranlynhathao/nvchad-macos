---@type NvPluginSpec
return {
  "folke/noice.nvim",
  lazy = false,
  config = function()
    require("noice").setup {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        signature = { enabled = false },
        hover = { enabled = false },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = false,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "pattern to filter",
          },
          opts = { skip = true },
          view = "mini",
        },
      },
      -- routes = {
      --   {
      --     filter = {
      --       event = "msg_show",
      --       kind = "warning",
      --     },
      --     view = "popup", -- Display warning in popup window
      --   },
      --   {
      --     filter = {
      --       event = "msg_show",
      --       min_height = 2,
      --     },
      --     view = "split", -- Display long message in split window
      --   },
      --   {
      --     filter = {
      --       event = "msg_show",
      --       kind = "error",
      --     },
      --     view = "notify", -- Display error with notify
      --   },
      --   {
      --     filter = {
      --       event = "lsp",
      --       kind = "hover",
      --     },
      --     view = "hover", -- Hover view for LSP hover
      --   },
      --   {
      --     filter = {
      --       event = "msg_show",
      --       find = "pattern to filter",
      --     },
      --     opts = { skip = true },
      --     view = "mini",
      --   },
      -- },

      background_colour = "#1e1e1e",
      notify = {
        enabled = false, -- notify of noice: disable
      },
      cmdline_popup = {
        enabled = true,
        position = {
          row = 5, -- put display col at 5th position
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
        },
      },
      messages = {
        timeout = 50,
      },
    }

    -- vim.notify = require("noice").notify

    vim.notify = custom_notify
  end,
}

-- return {
--   "folke/noice.nvim",
--   event = "VeryLazy",
--   dependencies = { "MunifTanjim/nui.nvim" },
--   opts = {
--     cmdline = {
--       enabled = false,
--     },
--     messages = {
--       enabled = false,
--     },
--     popupmenu = {
--       enabled = false,
--     },
--     notify = {
--       enabled = false,
--     },
--     lsp = {
--       hover = {
--         enabled = true,
--         opts = {
--           border = "rounded",
--         },
--         override = {
--           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--           ["vim.lsp.util.stylize_markdown"] = true,
--         },
--       },
--       signature = {
--         enabled = true,
--         opts = {
--           border = "rounded",
--         },
--       },
--       progress = {
--         enabled = false,
--       },
--       message = {
--         enabled = false,
--       },
--     },
--   },
-- }
