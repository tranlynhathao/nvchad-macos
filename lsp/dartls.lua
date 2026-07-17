-- Dart language server. Ships inside the Dart SDK, invoked via `dart language-server`.
return {
  cmd = { "dart", "language-server", "--protocol=lsp" },
  settings = {
    dart = {
      analysisExcludedFolders = { "/path/to/your/excluded/folder" },
    },
  },
}
