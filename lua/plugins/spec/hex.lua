---@type NvPluginSpec
-- hex.nvim: turn any binary buffer into an xxd-style hex view. When you
-- open a `.o`, `.bin`, `.elf`, `.wasm` file, the plugin auto-converts to
-- hex on read and converts back on save. Toggle any time with :HexToggle.
--
-- Also useful for inspecting compiled shellcode, ELF headers during CTFs,
-- or debugging binary I/O in Rust / Zig / C code.
return {
  "RaafatTurki/hex.nvim",
  cmd = { "HexDump", "HexAssemble", "HexToggle" },
  keys = {
    { "<leader>hx", "<cmd>HexToggle<cr>", desc = "Hex: toggle view" },
    { "<leader>hd", "<cmd>HexDump<cr>", desc = "Hex: dump buffer" },
    { "<leader>ha", "<cmd>HexAssemble<cr>", desc = "Hex: re-assemble to binary" },
  },
  opts = {
    -- Files matching these patterns get auto-hex on read.
    dump_cmd = "xxd -g 1 -u",
    assemble_cmd = "xxd -r",
    is_file_binary_pre_read = function()
      local ft = vim.bo.filetype
      -- Only auto-dump specific binary filetypes; skip normal text files.
      return vim.tbl_contains({ "hex", "bin", "obj", "elf", "wasm", "class" }, ft)
    end,
  },
}
