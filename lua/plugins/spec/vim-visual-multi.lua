---@type NvPluginSpec
return {
  "mg979/vim-visual-multi",
  cmd = {
    "VMap",
    "VNew",
    "VNewShell",
    "VS",
    "VSCode",
    "VSDebug",
    "VSDebugger",
    "VSTerminal",
    "VSTerminalOpen",
    "VSTerminalSend",
    "VSTerminalSendRaw",
    "VSTerminalToggle",
    "VSTerminalToggleSplit",
    "VSTerminalVSCode",
    "VSTerminalWindows",
    "VToggle",
    "VToggleLine",
    "VToggleRange",
    "VW",
    "VWSplit",
  },
  event = "BufRead",
  config = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-m>",
      ["Find Subword Under"] = "<C-i>",
      ["Select All"] = "<C-a>",
      ["Skip Region"] = "<C-x>",
      ["Remove Region"] = "<C-q>",
      ["Undo"] = "u",
      ["Redo"] = "<C-r>",
      ["Add Cursor Down"] = "<C-j>",
      ["Add Cursor Up"] = "<C-k>",
      ["Add Cursor At"] = "<C-n>",
      ["Remove Cursor"] = "<C-d>",
      ["Toggle Highlight"] = "<C-h>",
    }

    vim.cmd [[nmap <C-.> :<C-u>call VM#Start()<CR>]]
  end,
}
