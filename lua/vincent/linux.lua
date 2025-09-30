if vim.fn.has "unix" ~= 1 or vim.fn.has "macunix" == 1 or vim.fn.has "wsl" == 1 then
  return
end

local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function detect_clipboard_tool()
  if command_exists "xclip" then
    return "xclip -selection clipboard"
  elseif command_exists "xsel" then
    return "xsel --clipboard --input"
  elseif command_exists "wl-copy" then
    return "wl-copy"
  elseif command_exists "apt-get" then
    print "Clipboard tool not found. Attempting to install xclip..."
    os.execute "sudo apt-get update && sudo apt-get install -y xclip"
    if command_exists "xclip" then
      print "xclip installed successfully."
      return "xclip -selection clipboard"
    end
    print "Failed to install xclip. Please install manually."
  end
  return nil
end

local tool = detect_clipboard_tool()
if not tool then
  return
end

vim.g.clipboard = {
  name = "linux-clipboard",
  copy = {
    ["+"] = tool,
    ["*"] = tool,
  },
  paste = {
    ["+"] = tool == "wl-copy" and "wl-paste" or (tool .. " -o"),
    ["*"] = tool == "wl-copy" and "wl-paste" or (tool .. " -o"),
  },
  cache_enabled = 0,
}
