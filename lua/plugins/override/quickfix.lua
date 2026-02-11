---@type NvPluginSpec[]
return {

  -- QuickFix: preview, filter, smooth jump
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    name = "bqf",
    config = function()
      require("bqf").setup {
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border = "rounded",
          show_title = true,
          should_preview_cb = function(bufnr, qwinid)
            -- Don'r preview if file is larger than 100kb
            local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
            return size < 100 * 1024
          end,
        },
        func_map = {
          open = "<CR>",
          drop = "o",
          split = "s",
          vsplit = "v",
          tabdrop = "t",
          toggle_preview = "p",
          prev_file = "<C-p>",
          next_file = "<C-n>",
        },
        filter = {
          fzf = {
            action_for = {
              ["ctrl-s"] = "split",
              ["ctrl-v"] = "vsplit",
              ["ctrl-t"] = "tab drop",
            },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
          },
        },
      }
    end,
  },

  -- Toggle quickfix list
  {
    "wsdjeg/quickfix.nvim",
    event = "VeryLazy",
    name = "vim-quickfix",
    init = function()
      local map = vim.keymap.set
      map("n", "<leader>q", "<Plug>(qf_toggle)", { desc = "Toggle Quickfix List" })
      map("n", "]q", "<Plug>(qf_next)", { desc = "Next Quickfix Item" })
      map("n", "[q", "<Plug>(qf_previous)", { desc = "Previous Quickfix Item" })
    end,
  },
}
