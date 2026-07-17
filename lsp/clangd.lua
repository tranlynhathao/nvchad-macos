-- clangd for C / C++ / Objective-C.
-- clang-tidy checks run inside clangd via --clang-tidy; nvim-lint's clangtidy
-- entry is disabled to avoid duplicate diagnostics.
return {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--enable-config",
    "--offset-encoding=utf-16",
  },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
}
