---@type NvPluginSpec
return {
  "dmtrKovalenko/fff.nvim",
  lazy = false,
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = function()
    local threads = 4
    if vim.uv.available_parallelism then
      threads = vim.uv.available_parallelism()
    end

    return {
      -- prompt = " ",
      prompt = "   ",
      -- title = "Files",
      title = " 󰱼 Project Files ",
      -- max_results = 200,
      max_results = 250,
      max_threads = math.max(2, math.min(8, threads)),
      lazy_sync = true,
      prompt_vim_mode = false,
      layout = {
        -- height = 0.9,
        height = function(_, lines)
          if lines >= 56 then
            return 0.82
          end

          if lines >= 44 then
            return 0.88
          end

          return 0.94
        end,
        -- width = 0.9,
        width = function(columns)
          if columns >= 220 then
            return 0.78
          end

          if columns >= 180 then
            return 0.84
          end

          if columns >= 140 then
            return 0.9
          end

          return 0.96
        end,
        -- prompt_position = "bottom",
        prompt_position = "top",
        preview_position = "right",
        -- preview_size = 0.55,
        preview_size = function(columns)
          if columns >= 220 then
            return 0.56
          end

          if columns >= 160 then
            return 0.52
          end

          return 0.48
        end,
        flex = {
          -- size = 140,
          size = 150,
          -- wrap = "top",
          wrap = "bottom",
        },
        show_scrollbar = true,
        path_shorten_strategy = "middle_number",
        anchor = "center",
      },
      preview = {
        enabled = true,
        -- max_size = 8 * 1024 * 1024,
        max_size = 12 * 1024 * 1024,
        chunk_size = 8192,
        binary_file_threshold = 1024,
        imagemagick_info_format_str = "%m  %wx%h  %[colorspace]  %q-bit",
        line_numbers = true,
        cursorlineopt = "both",
        wrap_lines = false,
        filetypes = {
          markdown = { wrap_lines = true },
          svg = { wrap_lines = true },
          text = { wrap_lines = true },
          gitcommit = { wrap_lines = true },
          help = { wrap_lines = true },
        },
      },
      keymaps = {
        close = { "<Esc>", "<C-c>" },
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-p>", "<C-k>" },
        move_down = { "<Down>", "<C-n>", "<C-j>" },
        preview_scroll_up = { "<C-u>", "<PageUp>" },
        preview_scroll_down = { "<C-d>", "<PageDown>" },
        toggle_debug = "<F2>",
        cycle_grep_modes = { "<S-Tab>", "<C-g>" },
        cycle_previous_query = "<C-Up>",
        toggle_select = "<Tab>",
        send_to_quickfix = "<C-q>",
        focus_list = "<leader>l",
        focus_preview = "<leader>p",
      },
      hl = {
        -- border = "FloatBorder",
        border = "FFFBorder",
        -- normal = "NormalFloat",
        normal = "FFFNormal",
        -- cursor = "CursorLine",
        cursor = "FFFSelectedActive",
        -- matched = "IncSearch",
        matched = "FFFMatched",
        -- title = "Title",
        title = "FFFTitle",
        -- prompt = "Question",
        prompt = "FFFPrompt",
        frecency = "Number",
        debug = "Comment",
        combo_header = "FFFComboHeader",
        -- directory_path = "Comment",
        directory_path = "FFFDirectory",
        -- scrollbar = "Comment",
        scrollbar = "FFFScrollbar",
        selected = "FFFSelected",
        selected_active = "FFFSelectedActive",
        git_staged = "FFFGitStaged",
        git_modified = "FFFGitModified",
        git_deleted = "FFFGitDeleted",
        git_renamed = "FFFGitRenamed",
        git_untracked = "FFFGitUntracked",
        git_ignored = "FFFGitIgnored",
        git_sign_staged = "FFFGitSignStaged",
        git_sign_modified = "FFFGitSignModified",
        git_sign_deleted = "FFFGitSignDeleted",
        git_sign_renamed = "FFFGitSignRenamed",
        git_sign_untracked = "FFFGitSignUntracked",
        git_sign_ignored = "FFFGitSignIgnored",
        git_sign_staged_selected = "FFFGitSignStagedSelected",
        git_sign_modified_selected = "FFFGitSignModifiedSelected",
        git_sign_deleted_selected = "FFFGitSignDeletedSelected",
        git_sign_renamed_selected = "FFFGitSignRenamedSelected",
        git_sign_untracked_selected = "FFFGitSignUntrackedSelected",
        git_sign_ignored_selected = "FFFGitSignIgnoredSelected",
        -- grep_match = "IncSearch",
        grep_match = "FFFMatched",
        grep_line_number = "LineNr",
        grep_regex_active = "DiagnosticInfo",
        grep_plain_active = "Comment",
        grep_fuzzy_active = "DiagnosticHint",
        suggestion_header = "FFFSuggestionHeader",
      },
      frecency = {
        enabled = true,
        db_path = vim.fn.stdpath "cache" .. "/fff_nvim",
      },
      history = {
        enabled = true,
        db_path = vim.fn.stdpath "data" .. "/fff_queries",
        min_combo_count = 2,
        combo_boost_score_multiplier = 120,
      },
      grep = {
        -- max_file_size = 10 * 1024 * 1024,
        max_file_size = 12 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        time_budget_ms = 200,
        modes = { "plain", "regex", "fuzzy" },
        trim_whitespace = true,
      },
      git = {
        -- status_text_color = false,
        status_text_color = true,
      },
      file_picker = {
        current_file_label = "󰁕 current",
      },
      debug = {
        enabled = false,
        show_scores = false,
      },
      logging = {
        enabled = false,
      },
    }
  end,
  config = function(_, opts)
    require("fff").setup(opts)
    require("noah.fff").setup_highlights()
  end,
}
