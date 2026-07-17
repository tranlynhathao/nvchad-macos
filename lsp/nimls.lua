-- Nim language server (nimlsp). Requires `nim` on PATH.
return {
  cmd = { "nim", "nimlsp" },
  filetypes = { "nim" },
  root_markers = { "nim.cfg", ".git" },
}
