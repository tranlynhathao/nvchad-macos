---@type NvPluginSpec
-- godbolt.nvim: view Compiler Explorer (godbolt.org) assembly output for a
-- C / C++ / Rust snippet inside a split window. Essential for low-level work:
-- see exactly what instructions the compiler emits for a function without
-- leaving the editor.
--
-- Usage:
--   :Godbolt        - compile the entire buffer with the default compiler
--   :Godbolt<range> - visual-select a function then :'<,'>Godbolt to inspect
--   :GodboltCompiler - pick a specific compiler / version interactively
--
-- Requires: internet access to godbolt.org (or point to a self-hosted CE).
return {
  "p00f/godbolt.nvim",
  cmd = { "Godbolt", "GodboltCompiler" },
  opts = {
    languages = {
      c = { compiler = "cclang1810", options = {} },
      cpp = { compiler = "clang_trunk", options = {} },
      rust = { compiler = "nightly", options = {} },
    },
    quickfix = { enable = false, auto_open = false },
    url = "https://godbolt.org",
  },
}
