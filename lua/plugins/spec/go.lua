---@type NvPluginSpec
return {
  -- Plugin vim-go
  {
    "fatih/vim-go",
    run = ":GoInstallBinaries",
    config = function()
      vim.g.go_fmt_command = "goimports" -- Change the gofmt command
      vim.g.go_highlight_functions = 1 -- highlight function calls and definitions
      vim.g.go_highlight_methods = 1 -- highlight method calls and definitions
      vim.g.go_highlight_structs = 1 -- highlight structs and their fields
      vim.g.go_highlight_operators = 1 -- highlight operators
      vim.g.go_highlight_extra_types = 1 -- highlight extra types
      vim.g.go_highlight_fields = 1 -- highlight fields
      vim.g.go_auto_type_info = 1 -- automatically gogettypeinfo for the current word
      vim.g.go_auto_sameids = 1 -- automatically gogetlocalsameid for the current word
      vim.g.go_gopls_enabled = 1 -- Enable gopls
      vim.g.go_golangci_lint_command = "golangci-lint run --fix"
      vim.g.go_golangci_autofix = 1
      vim.g.go_gocode_autodetect = 1
      vim.g.go_gocode_command = "gocode"
      vim.g.go_def_mode = "gopls"
      vim.g.go_info_mode = "gopls"
      vim.g.go_list_mode = "gopls"
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_template_autocreate = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_fillcolumns = 1
      vim.g.go_highlight_spacetaberror = 1
      vim.g.go_highlight_array_whitespace_error = 1
      vim.g.go_highlight_trailing_whitespace_error = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_structs = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_function_arguments = 1
    end,
  },
}
