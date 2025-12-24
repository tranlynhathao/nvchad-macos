-- Web3/Blockchain Development Helper
-- Detects Foundry/Hardhat projects and provides utilities

local M = {}

--- Detect project type (foundry, hardhat, or none)
---@return string|nil
function M.detect_project_type()
  local cwd = vim.fn.getcwd()

  -- Check for Foundry
  if vim.fn.filereadable(cwd .. "/foundry.toml") == 1 then
    return "foundry"
  end

  -- Check for Hardhat
  if
    vim.fn.filereadable(cwd .. "/hardhat.config.js") == 1
    or vim.fn.filereadable(cwd .. "/hardhat.config.ts") == 1
    or vim.fn.filereadable(cwd .. "/hardhat.config.cjs") == 1
    or vim.fn.filereadable(cwd .. "/hardhat.config.mjs") == 1
  then
    return "hardhat"
  end

  -- Check for Truffle
  if vim.fn.filereadable(cwd .. "/truffle-config.js") == 1 then
    return "truffle"
  end

  return nil
end

--- Get project root directory
---@return string
function M.get_project_root()
  local project_type = M.detect_project_type()
  local cwd = vim.fn.getcwd()

  if project_type == "foundry" then
    -- Look for foundry.toml
    local found = vim.fn.findfile("foundry.toml", ".;")
    if found ~= "" then
      return vim.fn.fnamemodify(found, ":p:h")
    end
  elseif project_type == "hardhat" then
    -- Look for hardhat.config.*
    local patterns = { "hardhat.config.js", "hardhat.config.ts", "hardhat.config.cjs", "hardhat.config.mjs" }
    for _, pattern in ipairs(patterns) do
      local found = vim.fn.findfile(pattern, ".;")
      if found ~= "" then
        return vim.fn.fnamemodify(found, ":p:h")
      end
    end
  end

  return cwd
end

--- Run Foundry test command
---@param test_name string|nil Optional test name to run
function M.run_foundry_test(test_name)
  local root = M.get_project_root()
  local cmd = "forge test"

  if test_name then
    cmd = cmd .. " --match-test " .. test_name
  end

  -- Use toggleterm or terminal
  local Terminal = require("toggleterm.terminal").Terminal
  local test_term = Terminal:new {
    cmd = cmd,
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }

  test_term:toggle()
end

--- Run Foundry test with verbosity
---@param verbosity number Verbosity level (1-5)
function M.run_foundry_test_verbose(verbosity)
  verbosity = verbosity or 2
  local root = M.get_project_root()
  local cmd = "forge test -vv" .. verbosity

  local Terminal = require("toggleterm.terminal").Terminal
  local test_term = Terminal:new {
    cmd = cmd,
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }

  test_term:toggle()
end

--- Run Hardhat test command
---@param test_file string|nil Optional test file to run
function M.run_hardhat_test(test_file)
  local root = M.get_project_root()
  local cmd = "npx hardhat test"

  if test_file then
    cmd = cmd .. " " .. test_file
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local test_term = Terminal:new {
    cmd = cmd,
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }

  test_term:toggle()
end

--- Format Solidity files with forge fmt
function M.format_solidity_forge()
  local root = M.get_project_root()
  local project_type = M.detect_project_type()

  if project_type ~= "foundry" then
    vim.notify("Not a Foundry project. Use forge fmt only in Foundry projects.", vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local fmt_term = Terminal:new {
    cmd = "forge fmt",
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_exit = function()
      vim.notify("Formatting complete. Reloading buffers...", vim.log.levels.INFO)
      vim.cmd "checktime"
    end,
  }

  fmt_term:toggle()
end

--- Compile Foundry project
function M.compile_foundry()
  local root = M.get_project_root()
  local project_type = M.detect_project_type()

  if project_type ~= "foundry" then
    vim.notify("Not a Foundry project.", vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local compile_term = Terminal:new {
    cmd = "forge build",
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }

  compile_term:toggle()
end

--- Compile Hardhat project
function M.compile_hardhat()
  local root = M.get_project_root()
  local project_type = M.detect_project_type()

  if project_type ~= "hardhat" then
    vim.notify("Not a Hardhat project.", vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local compile_term = Terminal:new {
    cmd = "npx hardhat compile",
    dir = root,
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }

  compile_term:toggle()
end

--- Show project info
function M.show_project_info()
  local project_type = M.detect_project_type()
  local root = M.get_project_root()

  if not project_type then
    vim.notify("No Web3 project detected (Foundry/Hardhat)", vim.log.levels.INFO)
    return
  end

  local info = {
    "Web3 Project Info:",
    "Type: " .. project_type,
    "Root: " .. root,
  }

  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
end

return M
