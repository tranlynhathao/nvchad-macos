---@type NvPluginSpec
return {
  "simrat39/rust-tools.nvim",
  config = function()
    local rust_tools = require "rust-tools"

    rust_tools.setup {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
          vim.keymap.set("n", "<leader>r", ":RustRun<CR>", { buffer = bufnr, desc = "Rust run" })
          vim.keymap.set("n", "<leader>t", ":RustTest<CR>", { buffer = bufnr, desc = "Rust test" })
          vim.keymap.set("n", "<leader>e", ":RustExpandMacro<CR>", { buffer = bufnr, desc = "Rust expand macro" })
        end,
      },
    }
  end,
}
