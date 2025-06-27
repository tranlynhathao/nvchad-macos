---@type NvPluginSpec
return {
  "Kicamon/markdown-table-mode.nvim",
  ft = { "markdown" },
  config = function()
    require("markdown-table-mode").setup {
      filetype = { "*.md", "*.markdown" },
      options = {
        insert = true, -- Auto-format when typing `|`
        insert_leave = true, -- Auto-format when leaving insert mode
        pad_separator_line = false, -- Whether to add spacing in header divider
        align_style = "default", -- Options: 'default', 'left', 'center', 'right'
      },
      -- mappings = {
      --   toggle = "<leader>mtm", -- Toggle table mode
      --   reformat = "<leader>mtm_format", -- Force reformatting of the table
      -- },
    }
  end,
}
