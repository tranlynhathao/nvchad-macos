---@type NvPluginSpec
return {
  "mistricky/codesnap.nvim",
  -- Screenshot tool — only load when the user actually invokes it.
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapASCII" },
  keys = {
    { "<leader>cc", "<cmd>CodeSnap<CR>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    { "<leader>cs", "<cmd>CodeSnapSave<CR>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
  },
  opts = {
    save_path = "~/Pictures",
    code_font_family = "JetBrainsMono Nerd Font",
    has_breadcrumbs = true,
    bg_theme = "grape",
    watermark = "",
  },
  build = "make",
}
