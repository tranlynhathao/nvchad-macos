---@type NvPluginSpec
return {
  "dmtrKovalenko/fff.nvim",
  -- Load on the :FFF* user commands. The <leader>f* keymaps live in
  -- plugins/override/telescope.lua (they call noah.fff.* wrappers with root
  -- sync + custom title); those wrappers `require "fff"` which triggers
  -- lazy.nvim to load this plugin on-demand.
  cmd = { "FFFFind", "FFFResume", "FFFScan", "FFFRefreshGit", "FFFClearCache" },
  build = function() require("fff.download").download_or_build_binary() end,
  init = function()
    -- If nvim launches with cwd=$HOME, FFF's ensure_initialized() fires
    -- "Refusing to index home directory" during setup because its default
    -- base_path = cwd. Pre-seed base_path with the nvim config dir (never
    -- $HOME) so setup is silent; noah/fff.lua's sync_root() then swaps to
    -- the real project root on first <leader>ff call.
    vim.g.fff = { lazy_sync = true, base_path = vim.fn.stdpath "config" }
  end,
  opts = function()
    local threads = 4
    if vim.uv.available_parallelism then threads = vim.uv.available_parallelism() end

    return {
      prompt = "   ",
      title = "FFF",
      max_results = 250,
      max_threads = math.max(2, math.min(8, threads)),
      lazy_sync = true,
      prompt_vim_mode = false,
      -- Explicitly enabled: user wants FFF from $HOME. First scan may take
      -- 10-60s (scans ~/Library, ~/Downloads etc. — no .gitignore in $HOME
      -- to prune). Subsequent calls reuse the in-memory index. If startup
      -- latency becomes a problem, add per-repo .gitignore under HOME or
      -- switch back to false.
      enable_home_dir_scanning = true,
      enable_fs_root_scanning = false,

      layout = {
        -- Balanced modal: leaves visible context of the buffer beneath.
        -- Scale down gracefully on smaller terminals so the picker never
        -- overshoots or hides the list.
        height = function(_, lines)
          if lines >= 60 then return 0.74 end
          if lines >= 44 then return 0.80 end
          return 0.90
        end,
        width = function(columns)
          if columns >= 200 then return 0.82 end
          if columns >= 160 then return 0.86 end
          if columns >= 120 then return 0.92 end
          return 0.96
        end,
        prompt_position = "top",
        preview_position = "right",
        -- Preview slightly wider than the list: code readability > long
        -- filenames. Long paths are shortened by path_shorten_strategy below.
        preview_size = 0.58,
        flex = {
          size = 120,
          wrap = "top",
        },
        min_list_height = 12,
        show_scrollbar = true,
        path_shorten_strategy = "middle_number",
        anchor = "center",
      },

      preview = {
        enabled = true,
        max_size = 12 * 1024 * 1024,
        chunk_size = 8192,
        binary_file_threshold = 1024,
        imagemagick_info_format_str = "%m  %wx%h  %[colorspace]  %q-bit",
        -- Line numbers in the preview column — muted via LineNr / FFFPreviewLineNr
        -- so they never outweigh source text.
        line_numbers = true,
        cursorlineopt = "both",
        wrap_lines = false,
        filetypes = {
          markdown = { wrap_lines = true },
          text = { wrap_lines = true },
          help = { wrap_lines = true },
          svg = { wrap_lines = true },
          gitcommit = { wrap_lines = true },
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
        -- <leader>* doesn't fire inside the picker prompt because leader=Space
        -- is a valid input character consumed by the query field. Function
        -- keys have no collision with typed input.
        focus_list = "<F3>",
        focus_preview = "<F4>",
      },

      hl = {
        border = "FFFBorder",
        normal = "FFFNormal",
        cursor = "FFFSelectedActive",
        matched = "FFFMatched",
        title = "FFFTitle",
        prompt = "FFFPrompt",
        frecency = "Number",
        debug = "Comment",
        combo_header = "FFFComboHeader",
        directory_path = "FFFDirectory",
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

        grep_match = "FFFGrepMatch",
        grep_line_number = "FFFGrepLineNumber",
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
        max_file_size = 12 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        -- Drop the column part of the location so rows read as `path:line`
        -- rather than `path:line:col` — column noise was hurting scan speed.
        location_format = ":%d",
        -- Keep leading indentation of source lines: it carries structural
        -- meaning when reading code.
        trim_whitespace = false,
        time_budget_ms = 150,
        modes = { "plain", "regex", "fuzzy" },
      },

      git = {
        -- Do NOT tint filenames by git status — that competes with the fuzzy
        -- match highlight. Sign column still uses git colors.
        status_text_color = false,
      },

      file_picker = {
        current_file_label = "󰁕 current",
        -- Highlight the fuzzy-match characters in the filename column.
        fuzzy_query_highlighting = true,
      },

      debug = {
        -- Progressive disclosure: default UI stays clean. <F2> toggles the
        -- full file-info panel (path / size / git / frecency / score / times).
        enabled = false,
        show_scores = false,
        show_file_info = {
          file_info = true,
          score_breakdown = true,
          timings = true,
          full_path = true,
        },
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
