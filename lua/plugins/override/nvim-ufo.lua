---@type NvPluginSpec
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  -- Load on first file open — ufo needs to attach fold providers before any
  -- buffer renders folds. Without a trigger the plugin stays unloaded under
  -- lazy.nvim's `defaults = { lazy = true }`.
  event = "BufReadPost",
  config = function()
    -- Turn on code folding
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- `zc`: Close a code block (fold the block).
    -- `zo`: Open a code block (unfold the block).
    -- `zM`: Close all code blocks (fold all).
    -- `zR`: Open all code blocks (unfold all).

    -- Get Ufo into folding of Neovim
    require("ufo").setup {
      provider_selector = function(bufnr, filetype, buftype) return { "lsp", "indent" } end,
    }
  end,
}
