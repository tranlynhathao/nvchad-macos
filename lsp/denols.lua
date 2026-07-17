-- Deno language server. Scoped to Deno projects to avoid conflict with ts_ls.
return {
  root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
  single_file_support = false,
  init_options = {
    enable = true,
    lint = true,
    unstable = false,
  },
}
