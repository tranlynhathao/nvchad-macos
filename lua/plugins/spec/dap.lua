return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "theHamsta/nvim-dap-virtual-text",
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    -- Install codelldb
    require("mason").setup()
    require("mason.settings").set { ensure_installed = { "codelldb" } }

    -- Adapters
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    -- Configurations
    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    -- Keymaps
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step into" })
    vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "DAP: Step out" })

    -- DAP-UI
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
