---@type NvPluginSpec
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "microsoft/vscode-js-debug",
    build = "npm install --legacy-peer-deps && npm run compile",
  },
  config = function()
    local dap = require "dap"
    local mason_registry = require "mason-registry"

    -- Get js-debug-adapter path from Mason
    local js_debug_path
    if mason_registry.is_installed "js-debug-adapter" then
      local js_debug = mason_registry.get_package "js-debug-adapter"
      js_debug_path = js_debug:get_install_path() .. "/out/src/vsDebugServer.js"
    else
      -- Fallback to system installation or vscode-js-debug
      js_debug_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js"
    end

    dap.adapters["pwa-node"] = function(callback, _)
      callback {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            js_debug_path,
            "${port}",
          },
        },
      }
    end

    -- Enhanced TypeScript/JavaScript configurations
    for _, language in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch with Args",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          runtimeArgs = function()
            local args = vim.fn.input "Runtime args (space separated): "
            return vim.split(args, " ")
          end,
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Hardhat Test",
          program = "${workspaceFolder}/node_modules/.bin/hardhat",
          args = { "test" },
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Test",
          program = "${workspaceFolder}/node_modules/.bin/jest",
          args = { "--runInBand", "${file}" },
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          skipFiles = { "<node_internals>/**" },
          console = "integratedTerminal",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach to Chrome",
          port = 9222,
          webRoot = "${workspaceFolder}",
        },
      }
    end
  end,
}
