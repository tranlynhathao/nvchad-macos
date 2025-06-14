---@type NvPluginSpec
return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require "dap"

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
      port = 8123,
      executable = {
        command = "js-debug-adapter",
      },
    }

    for _, language in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
        },
      }
    end
  end,
}
