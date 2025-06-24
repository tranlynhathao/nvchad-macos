---@type NvPluginSpec
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Automatically display suggestions
        keymap = {
          accept = "<leader><leader>a", -- To accept suggestions
          accept_word = "<localleader>l", -- Use .l to accept a word
          accept_line = "<localleader>j", -- Use .j to accept a line
          next = "<M-]>", -- Use Alt + ] to go to the next suggestion
          prev = "<M-[>", -- Use Alt + [ to go to the previous suggestion
          dismiss = "<C-]>", -- Use Ctrl + ] to dismiss the suggestion
        },
      },
      panel = { enabled = false },
    }
  end,
}
