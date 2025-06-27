---@type NvPluginSpec
return {
  "ChuufMaster/markdown-toc",
  ft = { "markdown" },
  config = function()
    require("markdown-toc").setup {
      heading_level_to_match = -1, -- -1 means match all heading levels
      ask_for_heading_level = true, -- Shows prompt to select heading level
      toc_format = "%s- [%s](<%s#%s>)", -- Format: indent, title, file, anchor
      commands = {
        -- GenerateTOC
        generate = "MarkdownTocGenerate",
        update = "MarkdownTocUpdate",
        delete = "MarkdownTocDelete",
      },
    }

    -- Define keymaps on Markdown files
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "markdown",
    --   callback = function()
    --     vim.keymap.set("n", "<leader>gt", "<cmd>MarkdownTocGenerate<CR>", { buffer = true, desc = "Generate TOC" })
    --     vim.keymap.set("n", "<leader>ut", "<cmd>MarkdownTocUpdate<CR>", { buffer = true, desc = "Update TOC" })
    --     vim.keymap.set("n", "<leader>dt", "<cmd>MarkdownTocDelete<CR>", { buffer = true, desc = "Delete TOC" })
    --   end,
    -- })
  end,
}
