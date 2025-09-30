-- .luacheckrc
return {
  globals = {
    "vim",
    "describe",
    "it",
    "before_each",
    "after_each",
    "vim",
    "P",
    "InsertBackLink",
    "OpenMarkdownLink",
    "ToggleWrap",
    "Quarto_is_in_python_chunk",
  },

  unused_args = false,
  max_line_length = 160,

  -- files = {
  --   ["lua/options.lua"] = {
  --     max_line_length = 200,
  --   },
  -- },
}
