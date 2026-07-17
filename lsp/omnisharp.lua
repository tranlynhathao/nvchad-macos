-- OmniSharp C# / .NET language server.
-- cmd points at a locally-managed OmniSharp DLL under $HOME/.LSP/omnisharp/;
-- adjust the path if you install OmniSharp elsewhere (Mason, brew, etc.).
return {
  cmd = { "dotnet", (os.getenv "HOME" or "") .. "/.LSP/omnisharp/OmniSharp.dll" },
  settings = {
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = false,
    organize_imports_on_format = false,
    enable_import_completion = false,
    sdk_include_prereleases = true,
    analyze_open_documents_only = false,
  },
}
