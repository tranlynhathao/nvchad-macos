---@type NvPluginSpec
-- C / C++ debug adapter via codelldb (installed by Mason)
return {
  "mfussenegger/nvim-dap",
  ft = { "c", "cpp" },
  config = function()
    local dap = require "dap"

    -- codelldb adapter — Mason installs it to its package path
    local mason_registry = require "mason-registry"
    local ok, codelldb_pkg = pcall(mason_registry.get_package, "codelldb")
    if not ok then
      vim.notify("codelldb not found in Mason registry", vim.log.levels.WARN)
      return
    end

    local codelldb_path = codelldb_pkg:get_install_path() .. "/extension/adapter/codelldb"
    local liblldb_path = codelldb_pkg:get_install_path() .. "/extension/lldb/lib/liblldb.dylib"

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_path,
        args = { "--liblldb", liblldb_path, "--port", "${port}" },
      },
    }

    -- C config
    dap.configurations.c = {
      {
        name = "Launch (codelldb)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    -- C++ reuses C config
    dap.configurations.cpp = dap.configurations.c
  end,
}
