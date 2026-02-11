---@type NvPluginSpec
return {
  "echasnovski/mini.files",
  version = false,
  keys = {
    --   {
    --     "<leader>E",
    --     function()
    --       local mini_files = require "mini.files"
    --       mini_files.open(vim.api.nvim_buf_get_name(0), true)
    --     end,
    --     desc = "Open file manager popup",
    --   },
    {
      "<leader>E",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or vim.fn.filereadable(path) == 0 then
          path = vim.fn.getcwd()
        end
        require("mini.files").open(path, true)
      end,
      desc = "Open file manager popup",
    },
  },

  --[[
  mini.files - Default keybindings inside the popup:

  - `a`            : Create a new file or folder
  - `r`            : Rename file or folder
  - `d`            : Delete file or folder
  - `l` or `Enter` : Open file or enter folder
  - `h`            : Go back to the parent directory
  - `q`            : Close the popup
  - `g?`           : Show help with all keybindings

  Notes:
  - To create a folder, add a trailing slash (e.g., `myfolder/`)
  - If `use_as_default_explorer = true`, it replaces netrw as default
  ]]

  opts = {
    use_as_default_explorer = true,
    windows = {
      preview = true,
      width_focus = 40,
      width_preview = 60,
    },
    mappings = {
      custom = {
        a = function()
          local MiniFiles = require "mini.files"
          local cwd = MiniFiles.get_fs_entry().path

          vim.ui.input({ prompt = "New file: ", default = cwd .. "/" }, function(input)
            if input and input ~= "" then
              vim.fn.mkdir(vim.fn.fnamemodify(input, ":h"), "p")
              vim.fn.writefile({}, input)
              MiniFiles.refresh()
              MiniFiles.close()
              vim.cmd("edit " .. input)
            end
          end)
        end,

        d = function()
          local mf = require "mini.files"
          local entry = mf.get_fs_entry()
          local path = entry.path
          local confirm = vim.fn.confirm("Delete " .. path .. "?", "&Yes\n&No", 2)
          if confirm == 1 then
            if vim.fn.isdirectory(path) == 1 then
              vim.fn.delete(path, "rf")
            else
              vim.fn.delete(path)
            end
            mf.refresh()
          end
        end,

        l = function()
          local mf = require "mini.files"
          local entry = mf.get_fs_entry()
          if entry.fs_type == "file" then
            vim.cmd("split " .. entry.path)
            mf.close()
          else
            mf.go_in()
          end
        end,
      },
      close = "q",
      go_in = "l",
      go_in_plus = "<CR>",
      go_out = "h",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
      -- create = "a",
      -- delete = "d",
      -- rename = "r",
    },
  },
}
