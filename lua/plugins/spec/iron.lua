---@type NvPluginSpec
return {
  "hkupty/iron.nvim",
  config = function()
    require("iron.core").setup {
      config = {
        repl_definition = {
          python = {
            command = { "ipython", "jupyter", "console", "--simple-prompt" },
          },
          quarto = {
            command = { "quarto", "repl", "R", "-e", "IRkernel::main()", "--slave" },
          },
          -- other languages here
        },
        repl_open_cmd = "rightbelow vnew", -- or "split", "vsplit", "botright split"
        scratch_repl = true,
        always_show_repl = true,
        always_open = true,
      },
      keymaps = {
        send_motion = "<leader>sc", -- send current line
        visual_send = "<leader>sv", -- send visual selection
        send_file = "<leader>sf", -- send entire file
        send_line = "<leader>sl", -- send current line
        send_until_cursor = "<leader>su", -- send until cursor
        send_mark = "<leader>sm", -- send marked text
        mark_motion = "<leader>mc", -- mark current line
        mark_visual = "<leader>mv", -- mark visual selection
        remove_mark = "<leader>md", -- remove mark
        cr = "<leader>s<CR>", -- send and go to next line
        interrupt = "<leader>si", -- interrupt running code
        exit = "<leader>sq", -- exit REPL
        clear = "<leader>sclear", -- clear REPL
      },
    }
  end,
}
