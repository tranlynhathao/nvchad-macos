-- Blockchain Development Configuration
-- Advanced tooling for Rust, C/C++, Solidity with memory safety focus

local M = {}

--- Check if we're in a blockchain project
---@return boolean
function M.is_blockchain_project()
  local cwd = vim.fn.getcwd()
  local indicators = {
    "foundry.toml",
    "hardhat.config.js",
    "hardhat.config.ts",
    "truffle-config.js",
    "Cargo.toml", -- Rust blockchain projects
  }

  for _, file in ipairs(indicators) do
    if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
      return true
    end
  end

  return false
end

--- Run Rust with Miri (memory safety checker)
function M.run_rust_miri()
  local Terminal = require("toggleterm.terminal").Terminal
  local miri_term = Terminal:new {
    cmd = "cargo +nightly miri test",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  miri_term:toggle()
end

--- Run Rust with AddressSanitizer
function M.run_rust_asan()
  local Terminal = require("toggleterm.terminal").Terminal
  local asan_term = Terminal:new {
    cmd = "RUSTFLAGS='-Z sanitizer=address' cargo +nightly test",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  asan_term:toggle()
end

--- Run C/C++ with Valgrind
function M.run_valgrind()
  local file = vim.fn.expand "%:t:r"
  local Terminal = require("toggleterm.terminal").Terminal
  local valgrind_term = Terminal:new {
    cmd = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./" .. file,
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  valgrind_term:toggle()
end

--- Compile C/C++ with AddressSanitizer
function M.compile_with_asan()
  local file = vim.fn.expand "%"
  local output = vim.fn.expand "%:t:r"
  local Terminal = require("toggleterm.terminal").Terminal
  local asan_term = Terminal:new {
    cmd = string.format("gcc -fsanitize=address -g -O1 %s -o %s && ./%s", file, output, output),
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  asan_term:toggle()
end

--- Run Foundry gas report
function M.foundry_gas_report()
  local Terminal = require("toggleterm.terminal").Terminal
  local gas_term = Terminal:new {
    cmd = "forge test --gas-report",
    direction = "float",
    float_opts = { border = "rounded", width = 150, height = 40 },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  gas_term:toggle()
end

--- Run Foundry coverage
function M.foundry_coverage()
  local Terminal = require("toggleterm.terminal").Terminal
  local cov_term = Terminal:new {
    cmd = "forge coverage",
    direction = "float",
    float_opts = { border = "rounded", width = 150, height = 40 },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  cov_term:toggle()
end

--- Run Slither (Solidity static analyzer)
function M.run_slither()
  local Terminal = require("toggleterm.terminal").Terminal
  local slither_term = Terminal:new {
    cmd = "slither . --print human-summary",
    direction = "float",
    float_opts = { border = "rounded", width = 150, height = 40 },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  slither_term:toggle()
end

--- Highlight unsafe Rust code
function M.highlight_unsafe_rust()
  vim.cmd [[
    augroup RustUnsafeHighlight
      autocmd!
      autocmd FileType rust syntax match RustUnsafe /\<unsafe\>/ containedin=ALL
      autocmd FileType rust highlight RustUnsafe ctermbg=red guibg=#ff0000 guifg=#ffffff
    augroup END
  ]]
end

--- Setup memory profiling for Rust (heaptrack/valgrind)
function M.rust_memory_profile()
  local Terminal = require("toggleterm.terminal").Terminal
  local prof_term = Terminal:new {
    cmd = "cargo build --release && heaptrack ./target/release/$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')",
    direction = "float",
    float_opts = { border = "rounded" },
    on_open = function(term)
      vim.cmd "startinsert!"
    end,
  }
  prof_term:toggle()
end

--- Setup Solidity optimizer settings display
function M.show_solidity_optimizer()
  local file = vim.fn.expand "%:p"
  if file:match "%.sol$" then
    local foundry_toml = vim.fn.findfile("foundry.toml", ".;")
    if foundry_toml ~= "" then
      vim.cmd("edit " .. foundry_toml)
      vim.fn.search("optimizer", "w")
    else
      vim.notify("foundry.toml not found", vim.log.levels.WARN)
    end
  end
end

--- Setup autocommands for blockchain development
function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("BlockchainDev", { clear = true })

  -- Highlight unsafe blocks in Rust
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "rust",
    callback = function()
      M.highlight_unsafe_rust()
    end,
  })

  -- Auto-format Solidity on save with forge fmt
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "*.sol",
    callback = function()
      local project_type = require("noah.web3").detect_project_type()
      if project_type == "foundry" then
        vim.cmd "silent! !forge fmt %"
        vim.cmd "checktime"
      end
    end,
  })

  -- Show gas estimates for Solidity functions
  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    pattern = "*.sol",
    callback = function()
      -- This would integrate with LSP to show gas estimates
      -- Requires solidity LSP with gas analysis
    end,
  })
end

--- Setup user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("RustMiri", M.run_rust_miri, { desc = "Run Rust Miri memory checker" })
  vim.api.nvim_create_user_command("RustAsan", M.run_rust_asan, { desc = "Run Rust with AddressSanitizer" })
  vim.api.nvim_create_user_command("Valgrind", M.run_valgrind, { desc = "Run Valgrind on current C/C++ binary" })
  vim.api.nvim_create_user_command("CppAsan", M.compile_with_asan, { desc = "Compile C/C++ with AddressSanitizer" })
  vim.api.nvim_create_user_command("FoundryGas", M.foundry_gas_report, { desc = "Show Foundry gas report" })
  vim.api.nvim_create_user_command("FoundryCov", M.foundry_coverage, { desc = "Show Foundry coverage" })
  vim.api.nvim_create_user_command("Slither", M.run_slither, { desc = "Run Slither security analyzer" })
  vim.api.nvim_create_user_command("RustMemProfile", M.rust_memory_profile, { desc = "Profile Rust memory usage" })
  vim.api.nvim_create_user_command("SolOptimizer", M.show_solidity_optimizer, { desc = "Show Solidity optimizer settings" })
end

--- Setup keymaps
function M.setup_keymaps()
  local map = vim.keymap.set

  -- Rust memory safety
  map("n", "<leader>bm", M.run_rust_miri, { desc = "Rust Miri check" })
  map("n", "<leader>ba", M.run_rust_asan, { desc = "Rust AddressSanitizer" })
  map("n", "<leader>bp", M.rust_memory_profile, { desc = "Rust memory profile" })

  -- C/C++ memory tools
  map("n", "<leader>bv", M.run_valgrind, { desc = "Run Valgrind" })
  map("n", "<leader>bc", M.compile_with_asan, { desc = "Compile with ASan" })

  -- Solidity/Foundry tools
  map("n", "<leader>bg", M.foundry_gas_report, { desc = "Foundry gas report" })
  map("n", "<leader>bC", M.foundry_coverage, { desc = "Foundry coverage" })
  map("n", "<leader>bs", M.run_slither, { desc = "Run Slither" })
  map("n", "<leader>bo", M.show_solidity_optimizer, { desc = "Show optimizer settings" })
end

--- Initialize blockchain development tools
function M.setup()
  M.setup_autocmds()
  M.setup_commands()
  M.setup_keymaps()

  if M.is_blockchain_project() then
    vim.notify("Blockchain development mode enabled", vim.log.levels.INFO)
  end
end

return M
