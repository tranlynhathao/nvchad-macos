return {
  "gregorias/coerce.nvim",
  opts = {
    modes = {
      {
        vim_mode = "n", -- Normal mode
        keymap_prefix = ".", -- Keybinding prefix
        selector = function()
          return require("coerce.selector").select_current_word() -- Select the current word
        end,
        transformer = function(selected_region, apply)
          return require("coerce.transformer").transform_lsp_rename_with_failover(
            selected_region,
            apply,
            require("coerce.transformer").transform_local
          ) -- Transform using LSP rename fallback
        end,
      },
      {
        vim_mode = "n", -- Normal mode
        keymap_prefix = "..", -- Another keybinding prefix
        selector = function()
          return require("coerce.selector").select_with_motion() -- Select with motion
        end,
        transformer = function(selected_region, apply)
          return require("coerce.transformer").transform_local(selected_region, apply) -- Local transformation
        end,
      },
      {
        vim_mode = "v", -- Visual mode
        keymap_prefix = ".", -- Keybinding prefix
        selector = function()
          return require("coerce.selector").select_current_visual_selection() -- Select the visual selection
        end,
        transformer = function(selected_region, apply)
          return require("coerce.transformer").transform_local(selected_region, apply) -- Local transformation
        end,
      },
    },
  },
}
