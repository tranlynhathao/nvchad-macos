---@type NvPluginSpec
return {
  "simrat39/rust-tools.nvim",
  config = function()
    local lspconfig = require "lspconfig"
    local rust_tools = require "rust-tools"

    rust_tools.setup {
      server = {
        on_attach = function(_, bufnr)
          local opts = opts
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>r", ":RustRun<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>t", ":RustTest<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", ":RustExpandMacro<CR>", opts)
        end,
      },
    }
  end,
}
