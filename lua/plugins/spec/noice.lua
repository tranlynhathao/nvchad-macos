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
        },
      },
      background_colour = "#1e1e1e",
      notify = {
        enabled = false, -- notify of noice: disable
      },
    }

    -- vim.notify = require("noice").notify

    vim.notify = custom_notify
  end,
}
