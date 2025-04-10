vim.g.clipboard = {
  name = "macOS-clipboard",
  copy = {
    ["+"] = "/usr/bin/pbcopy",
    ["*"] = "/usr/bin/pbcopy",
  },
  paste = {
    ["+"] = "/usr/bin/pbpaste",
    ["*"] = "/usr/bin/pbpaste",
  },
}
