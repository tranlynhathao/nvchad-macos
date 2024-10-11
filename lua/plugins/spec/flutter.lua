---@type NvPluginSpec
return {
  "akinsho/flutter-tools.nvim",
  event = "VeryLazy",
  config = function()
    require("flutter-tools").setup {
      -- Dart SDK path
      sdk = "/Users/tranlynhathao/Developer/flutter/bin/cache/dart-sdk", -- Adjust according to your Dart SDK path if needed

      -- Flutter tools configuration
      flutter_path = "/Users/tranlynhathao/Developer/flutter", -- Adjust according to your Flutter SDK path if needed

      -- Widget outline
      widget_guides = {
        enabled = true, -- Enable or disable widget guides
      },

      -- Run in debug mode
      run_via_dart = true,

      -- Show outlines of widgets
      outline = {
        auto_open = true, -- Automatically open outline when starting the project
      },

      -- LSP configurations
      lsp = {
        color = {
          -- Highlight the colors of the widget
          enabled = true, -- Enable colors
          virtual_text = true, -- Display colors in virtual text
          background = true, -- Display colors in the background
        },
      },

      -- Dev tools
      dev_log = {
        open_on_start = false, -- Automatically open dev log when starting Flutter
      },
    }
  end,
}
