local keymap = vim.keymap

local function get_term(cmd)
  return string.format("<cmd>ToggleTerm direction=float cmd='%s'<cr>", cmd)
end

-- C/C++
keymap.set("n", "<leader>cb", get_term "make", { noremap = true, silent = true, desc = "Build C/C++ project" })
keymap.set("n", "<leader>ct", get_term "make test", { noremap = true, silent = true, desc = "Test C/C++ project" })

-- Rust
keymap.set("n", "<leader>rb", get_term "cargo build", { noremap = true, silent = true, desc = "Build Rust project" })

-- Blockchain
keymap.set("n", "<leader>bc", get_term "solc", { noremap = true, silent = true, desc = "Compile Solidity" })
keymap.set("n", "<leader>bt", get_term "forge test", { noremap = true, silent = true, desc = "Test with Forge" })
