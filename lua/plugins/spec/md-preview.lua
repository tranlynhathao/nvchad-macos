---@type NvPluginSpec
return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    require("lazy").load { plugins = { "markdown-preview.nvim" } }
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

    -- Custom options
    -- vim.g.mkdp_auto_start = 0 -- Don't auto-start preview on file open
    -- vim.g.mkdp_auto_close = 1 -- Auto-close preview when buffer is closed
    -- vim.g.mkdp_refresh_slow = 0 -- Auto-refresh as you type
    -- vim.g.mkdp_command_for_global = 0 -- Only allow commands in markdown files
    --
    -- vim.g.mkdp_open_to_the_world = 0 -- Don't expose local server
    -- vim.g.mkdp_port = "" -- Random port (or specify like 8080)
    -- vim.g.mkdp_browser = "Arc" -- Set to your browser (e.g. Chrome, Arc, Firefox)
    --
    -- vim.g.mkdp_theme = "dark" -- 'dark' or 'light' mode
    -- vim.g.mkdp_page_title = "${name}"
    -- -- vim.g.mkdp_markdown_css = vim.fn.expand "~/.config/nvim/markdown/custom.css"
    -- vim.g.mkdp_highlight_css = "" -- Optional: highlight CSS
  end,
}
