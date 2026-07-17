-- Solidity language server (legacy). For newer Foundry-aware diagnostics use
-- solidity_ls_nomicfoundation (no user file needed, nvim-lspconfig defaults apply).
return {
  root_markers = {
    "foundry.toml",
    "hardhat.config.js",
    "hardhat.config.ts",
    "truffle-config.js",
    ".git",
  },
  settings = {
    solidity = {
      includePath = "",
      remapping = {},
    },
  },
}
