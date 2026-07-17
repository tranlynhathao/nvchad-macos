---@type NvPluginSpec
return {
  "akinsho/flutter-tools.nvim",
  event = "VeryLazy",
  config = function()
    require("flutter-tools").setup {
      sdk = "/Users/tranlynhathao/Developer/flutter/bin/cache/dart-sdk",
      flutter_path = "/Users/tranlynhathao/Developer/flutter",
      widget_guides = { enabled = true },
      run_via_dart = true,
      outline = { auto_open = true },
      dev_log = { open_on_start = false },
    }

    -- Document colors are now native (vim.lsp.document_color); flutter-tools' lsp.color is deprecated.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "dartls" then vim.lsp.document_color.enable(true, { bufnr = args.buf }, { style = "background" }) end
      end,
    })
  end,
}
