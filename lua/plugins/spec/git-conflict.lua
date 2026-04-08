---@type NvPluginSpec
return {
  "akinsho/git-conflict.nvim",
  lazy = false,
  opts = {
    default_mappings = {
      ours = "co",
      theirs = "ct",
      both = "cb",
      none = "c0",
      next = "]x",
      prev = "[x",
    },
    default_commands = false,
    disable_diagnostics = true,
    list_opener = "copen",
    highlights = {
      current = "DiffText",
      incoming = "DiffAdd",
      ancestor = "DiffChange",
    },
  },
  config = function(_, opts)
    require("git-conflict").setup(opts)

    local map = vim.keymap.set
    local augroup = vim.api.nvim_create_augroup("NoahGitConflict", { clear = true })

    local function has_conflict_markers(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for _, line in ipairs(lines) do
        if vim.startswith(line, "<<<<<<<") then
          return true
        end
      end
      return false
    end

    local function parse_conflicts(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return {}
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local conflicts = {}
      local line_count = #lines
      local idx = 1

      while idx <= line_count do
        if vim.startswith(lines[idx], "<<<<<<<") then
          local conflict = {
            start_line = idx,
            ours_start = idx + 1,
          }

          local scan = idx + 1
          while scan <= line_count and not vim.startswith(lines[scan], "=======") do
            if vim.startswith(lines[scan], "|||||||") and not conflict.base_marker then
              conflict.base_marker = scan
            end
            scan = scan + 1
          end

          if scan > line_count then
            break
          end

          conflict.separator = scan
          conflict.ours_end = (conflict.base_marker or conflict.separator) - 1
          if conflict.base_marker then
            conflict.base_start = conflict.base_marker + 1
            conflict.base_end = conflict.separator - 1
          end

          scan = conflict.separator + 1
          conflict.theirs_start = scan

          while scan <= line_count and not vim.startswith(lines[scan], ">>>>>>>") do
            scan = scan + 1
          end

          if scan > line_count then
            break
          end

          conflict.end_line = scan
          conflict.theirs_end = scan - 1
          conflicts[#conflicts + 1] = conflict
          idx = scan
        end

        idx = idx + 1
      end

      return conflicts
    end

    local function current_conflict(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local conflicts = parse_conflicts(bufnr)
      for _, conflict in ipairs(conflicts) do
        if cursor_line >= conflict.start_line and cursor_line <= conflict.end_line then
          return conflict, conflicts
        end
      end
      return nil, conflicts
    end

    local function conflict_lines(bufnr, conflict, side)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local function slice(first, last)
        if not first or not last or last < first then
          return {}
        end

        local out = {}
        for line = first, last do
          out[#out + 1] = lines[line]
        end
        return out
      end

      if side == "ours" then
        return slice(conflict.ours_start, conflict.ours_end)
      elseif side == "theirs" then
        return slice(conflict.theirs_start, conflict.theirs_end)
      elseif side == "both" then
        return vim.list_extend(slice(conflict.ours_start, conflict.ours_end), slice(conflict.theirs_start, conflict.theirs_end))
      elseif side == "none" then
        return {}
      end

      return nil
    end

    local function clear_buffer_maps(bufnr)
      if not vim.b[bufnr].noah_conflict_maps then
        return
      end

      for _, lhs in ipairs { "co", "ct", "cb", "c0", "]x", "[x" } do
        pcall(vim.keymap.del, "n", lhs, { buffer = bufnr })
      end

      vim.b[bufnr].noah_conflict_maps = nil
    end

    local function refresh_conflict_buffer(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.api.nvim_buf_call(bufnr, function()
        pcall(vim.cmd, "redraw")
      end)
    end

    local function list_conflicts()
      local bufnr = vim.api.nvim_get_current_buf()
      local items = {}
      local filename = vim.api.nvim_buf_get_name(bufnr)

      for index, conflict in ipairs(parse_conflicts(bufnr)) do
        items[#items + 1] = {
          bufnr = bufnr,
          filename = filename,
          lnum = conflict.start_line,
          col = 1,
          text = string.format("merge conflict %d", index),
        }
      end

      if #items == 0 then
        vim.notify("No merge conflicts detected", vim.log.levels.INFO)
        return
      end

      vim.fn.setqflist(items, "r")
      vim.cmd(opts.list_opener)
    end

    local function choose(side)
      return function()
        local bufnr = vim.api.nvim_get_current_buf()
        local conflict, conflicts = current_conflict(bufnr)
        if not conflict then
          if #conflicts == 1 then
            conflict = conflicts[1]
            vim.api.nvim_win_set_cursor(0, { conflict.start_line, 0 })
          else
            vim.notify("Move the cursor onto a merge conflict first", vim.log.levels.INFO)
            return
          end
        end

        local replacement = conflict_lines(bufnr, conflict, side)
        if replacement == nil then
          return
        end

        vim.api.nvim_buf_set_lines(bufnr, conflict.start_line - 1, conflict.end_line, false, replacement)

        local remaining = parse_conflicts(bufnr)
        if #remaining == 0 then
          clear_buffer_maps(bufnr)
        end

        refresh_conflict_buffer(bufnr)
      end
    end

    local function jump(direction)
      return function()
        local conflicts = parse_conflicts(0)
        if #conflicts == 0 then
          vim.notify("No merge conflicts detected", vim.log.levels.INFO)
          return
        end

        local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        local target = nil

        if direction == "next" then
          for _, conflict in ipairs(conflicts) do
            if conflict.start_line > cursor_line then
              target = conflict
              break
            end
          end
          target = target or conflicts[1]
        else
          for index = #conflicts, 1, -1 do
            if conflicts[index].start_line < cursor_line then
              target = conflicts[index]
              break
            end
          end
          target = target or conflicts[#conflicts]
        end

        vim.api.nvim_win_set_cursor(0, { target.start_line, 0 })
      end
    end

    local function set_buffer_maps(bufnr)
      if vim.b[bufnr].noah_conflict_maps then
        return
      end

      local opts_buf = { buffer = bufnr, silent = true }
      map("n", "co", choose "ours", vim.tbl_extend("force", opts_buf, { desc = "Git conflict choose ours" }))
      map("n", "ct", choose "theirs", vim.tbl_extend("force", opts_buf, { desc = "Git conflict choose theirs" }))
      map("n", "cb", choose "both", vim.tbl_extend("force", opts_buf, { desc = "Git conflict choose both" }))
      map("n", "c0", choose "none", vim.tbl_extend("force", opts_buf, { desc = "Git conflict choose none" }))
      map("n", "]x", jump "next", vim.tbl_extend("force", opts_buf, { desc = "Git next conflict" }))
      map("n", "[x", jump "prev", vim.tbl_extend("force", opts_buf, { desc = "Git previous conflict" }))
      vim.b[bufnr].noah_conflict_maps = true
    end

    vim.api.nvim_create_user_command("GitConflictChooseOurs", choose "ours", { desc = "Choose ours for current conflict" })
    vim.api.nvim_create_user_command("GitConflictChooseTheirs", choose "theirs", { desc = "Choose theirs for current conflict" })
    vim.api.nvim_create_user_command("GitConflictChooseBoth", choose "both", { desc = "Choose both sides for current conflict" })
    vim.api.nvim_create_user_command("GitConflictChooseNone", choose "none", { desc = "Choose none for current conflict" })
    vim.api.nvim_create_user_command("GitConflictNextConflict", jump "next", { desc = "Jump to next conflict" })
    vim.api.nvim_create_user_command("GitConflictPrevConflict", jump "prev", { desc = "Jump to previous conflict" })
    vim.api.nvim_create_user_command("GitConflictListQf", list_conflicts, { desc = "List merge conflicts in quickfix" })
    vim.api.nvim_create_user_command("GitConflictRefresh", function()
      refresh_conflict_buffer(0)
      set_buffer_maps(vim.api.nvim_get_current_buf())
    end, { desc = "Refresh conflict visuals and keymaps" })

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
      group = augroup,
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) or not has_conflict_markers(args.buf) then
          if vim.api.nvim_buf_is_valid(args.buf) then
            clear_buffer_maps(args.buf)
          end
          return
        end

        set_buffer_maps(args.buf)
        vim.schedule(function()
          refresh_conflict_buffer(args.buf)
        end)
      end,
    })

    map("n", "<leader>gmo", choose "ours", { desc = "Git conflict choose ours" })
    map("n", "<leader>gmt", choose "theirs", { desc = "Git conflict choose theirs" })
    map("n", "<leader>gmb", choose "both", { desc = "Git conflict choose both" })
    map("n", "<leader>gm0", choose "none", { desc = "Git conflict choose none" })
    map("n", "<leader>gmn", jump "next", { desc = "Git next conflict" })
    map("n", "<leader>gmp", jump "prev", { desc = "Git previous conflict" })
    map("n", "<leader>gml", list_conflicts, { desc = "Git list conflicts" })
    map("n", "<leader>gmr", function()
      refresh_conflict_buffer(0)
      set_buffer_maps(vim.api.nvim_get_current_buf())
    end, { desc = "Git refresh conflicts" })
  end,
}
