---@type NvPluginSpec
return {
  "echasnovski/mini.files",
  version = false,
  keys = {
    {
      "<leader>E",
      function()
        local project = require "noah.project"
        local root, anchor = project.root(), project.anchor()
        if vim.fn.filereadable(anchor) == 0 and vim.fn.isdirectory(anchor) == 0 then anchor = root end
        local width = vim.o.columns
        local files = require "mini.files"
        files.open(anchor, false, {
          windows = {
            max_number = width >= 120 and 3 or (width >= 80 and 2 or 1),
            width_focus = math.min(40, math.max(20, width - 8)),
            width_preview = width >= 120 and 50 or 30,
          },
        })
        local is_file = vim.fn.filereadable(anchor) == 1
        local folder = is_file and vim.fs.dirname(anchor) or anchor
        local branch = folder == root and { folder } or { vim.fs.dirname(folder), folder }
        local focus = #branch
        if is_file then branch[#branch + 1] = anchor end
        files.set_branch(branch, { depth_focus = focus })
        files.set_bookmark("p", root, { desc = "Project root" })
        files.set_bookmark("w", vim.fn.getcwd(), { desc = "Working directory" })
      end,
      desc = "Browse columns at current file (MiniFiles)",
    },
  },
  config = function(_, opts)
    local files = require "mini.files"
    files.setup(opts)
    local group = vim.api.nvim_create_augroup("NoahMiniFiles", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf = args.data.buf_id
        local function split(vertical)
          local entry, state = files.get_fs_entry(), files.get_explorer_state()
          if not entry or not state then return end
          if entry.fs_type ~= "file" then return files.go_in() end
          local target = vim.api.nvim_win_call(state.target_window, function()
            vim.cmd(vertical and "vsplit" or "split")
            return vim.api.nvim_get_current_win()
          end)
          files.set_target_window(target)
          files.go_in { close_on_file = true }
        end
        vim.keymap.set("n", "<C-v>", function() split(true) end, { buffer = buf, desc = "Open file in vertical split" })
        vim.keymap.set("n", "<C-x>", function() split(false) end, { buffer = buf, desc = "Open file in horizontal split" })
        vim.keymap.set("n", "<C-k>", function()
          local entry = files.get_fs_entry()
          if entry then require("noah.fileinfo").show(entry.path) end
        end, { buffer = buf, desc = "Show file info (popup)" })
        vim.keymap.set("n", "<Esc>", files.close, { buffer = buf, desc = "Close MiniFiles" })
      end,
    })
  end,
  opts = {
    options = { use_as_default_explorer = false, permanent_delete = false },
    windows = { preview = true, max_number = 3, width_focus = 40, width_nofocus = 20, width_preview = 50 },
    mappings = {
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
    },
  },
}
