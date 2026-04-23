---@type NvPluginSpec
return {
  "nvim-telescope/telescope.nvim",
  -- fzf-native was installed as a dropbar dependency but had no build step.
  -- Declaring it here ensures lazy.nvim compiles it after install/update.
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = function(_, opts)
    local map = vim.keymap.set
    local fff = require "noah.fff"
    local pickers = require("noah.telescope").pickers
    local actions = require "telescope.actions"
    local actions_layout = require "telescope.actions.layout"

    local SIZES = {
      HEIGHT = 0.9,
      WIDTH = 0.9,
      PREVIEW_WIDTH = 0.5,
    }

    -- ── File finding ──────────────────────────────────────────────────────
    map("n", "<leader>fa", function()
      pickers.files("find", {
        layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
        previewer = true,
        follow = true,
        no_ignore = true,
        hidden = true,
        prompt_prefix = " 󱡴  ",
        prompt_title = "All Files",
      })
    end, { desc = "Telescope all files (hidden + ignored)" })

    -- map("n", "<leader>ff", function()
    --   pickers.files("find", {
    --     layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
    --     previewer = true,
    --     prompt_title = "Files",
    --   })
    -- end, { desc = "Telescope find files" })
    map("n", "<leader>ff", fff.find_files, { desc = "Find files" })

    map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Telescope git files (tracked only)" })

    map("n", "<leader>fo", function()
      pickers.files("old", {
        layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
        previewer = true,
        prompt_title = "Recent Files",
      })
    end, { desc = "Telescope recent files" })

    -- ── Grep / text search ────────────────────────────────────────────────
    -- map("n", "<leader>fw", function()
    --   pickers.grep("live_grep", nil, nil, {
    --     layout_strategy = "horizontal",
    --     layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
    --     previewer = true,
    --     prompt_title = "Live Grep",
    --   })
    -- end, { desc = "Telescope live grep" })
    map("n", "<leader>fw", fff.live_grep, { desc = "Live grep" })
    map("n", "<leader>fz", fff.fuzzy_grep, { desc = "FFF fuzzy grep" })

    -- Grep exact word under cursor (normal mode)
    -- map("n", "<leader>fs", function()
    --   local word = vim.fn.expand "<cword>"
    --   pickers.grep("grep_string", word, nil, {
    --     layout_strategy = "horizontal",
    --     layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
    --     previewer = true,
    --     prompt_title = "Grep: " .. word,
    --   })
    -- end, { desc = "Telescope grep word under cursor" })
    map("n", "<leader>fs", fff.grep_cword, { desc = "Grep word under cursor" })

    -- Grep visual selection
    -- map("v", "<leader>fs", function()
    --   local saved = vim.fn.getreg "s"
    --   vim.cmd [[noau normal! "sy]]
    --   local selection = vim.fn.getreg "s"
    --   vim.fn.setreg("s", saved)
    --   if selection == "" then
    --     return
    --   end
    --   pickers.grep("grep_string", selection, nil, {
    --     layout_strategy = "horizontal",
    --     layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
    --     previewer = true,
    --     prompt_title = "Grep: " .. selection,
    --   })
    -- end, { desc = "Telescope grep visual selection" })
    map("v", "<leader>fs", fff.grep_visual_selection, { desc = "Grep visual selection" })

    map("n", "<leader>fF", fff.scan_files, { desc = "Rescan project files" })
    map("n", "<leader>fG", fff.refresh_git_status, { desc = "Refresh finder git status" })

    -- ── Buffers / navigation ──────────────────────────────────────────────
    map("n", "<leader>fb", function()
      pickers.buffers(true, {
        layout_config = { horizontal = { width = SIZES.WIDTH, height = SIZES.HEIGHT } },
        previewer = true,
      })
    end, { desc = "Telescope open buffers" })

    map("n", "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope fuzzy find in current buffer" })

    -- Resume last Telescope picker — re-open with results intact
    map("n", "<leader>f.", "<cmd>Telescope resume<CR>", { desc = "Telescope resume last search" })

    -- Jumplist, quickfix, loclist
    map("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { desc = "Telescope jumplist" })
    map("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", { desc = "Telescope quickfix list" })
    map("n", "<leader>fl", "<cmd>Telescope loclist<CR>", { desc = "Telescope location list" })

    -- Registers — fuzzy-pick which register to paste
    map("n", "<leader>fR", "<cmd>Telescope registers<CR>", { desc = "Telescope registers" })

    -- Command history — fuzzy-search commands you've run before
    map("n", "<leader>f:", "<cmd>Telescope command_history<CR>", { desc = "Telescope command history" })

    -- Search history — browse past / patterns
    map("n", "<leader>f/", "<cmd>Telescope search_history<CR>", { desc = "Telescope search history" })

    -- ── Help / meta ───────────────────────────────────────────────────────
    map("n", "<leader>f?", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help tags" })

    -- Keymaps — discover any binding without :verbose map
    map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope keymaps" })

    -- Commands — fuzzy-pick any Ex command
    map("n", "<leader>f;", "<cmd>Telescope commands<CR>", { desc = "Telescope commands" })

    map("n", "<leader>fp", "<cmd>Telescope builtin<CR>", { desc = "Telescope all pickers" })
    map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope terms" })
    map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope NvChad themes" })
    map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Telescope highlights" })
    map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope marks" })
    map("n", "<leader>ts", "<cmd>Telescope treesitter<CR>", { desc = "Telescope TreeSitter" })

    -- Spell suggest — replace z= popup with Telescope picker
    map("n", "z=", "<cmd>Telescope spell_suggest<CR>", { desc = "Telescope spell suggest" })

    -- ── LSP ───────────────────────────────────────────────────────────────
    -- References — browse all usages instead of jumping to first hit
    map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Telescope LSP references" })

    -- Diagnostics — workspace-wide list with inline filtering
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics" })

    -- Workspace symbols — fuzzy search across all LSP symbols in project
    map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Telescope LSP workspace symbols" })

    -- ── Git ───────────────────────────────────────────────────────────────
    map("n", "<leader>ge", "<cmd>Telescope git_status<CR>", { desc = "Telescope git status" })
    map("n", "<leader>gC", "<cmd>Telescope git_commits<CR>", { desc = "Telescope git commits" })

    -- Branches — checkout/create without leaving Neovim
    map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Telescope git branches" })

    -- Buffer commits — file history for current buffer
    map("n", "<leader>gB", "<cmd>Telescope git_bcommits<CR>", { desc = "Telescope git buffer commits" })

    -- -- ── GitHub (telescope-github.nvim, install separately if needed) ───────
    -- map("n", "<leader>gh", "<cmd>Telescope github issues<CR>", { desc = "Telescope GitHub issues" })
    -- map("n", "<leader>gp", "<cmd>Telescope github pull_requests<CR>", { desc = "Telescope GitHub PRs" })

    -- Stash list — browse and apply git stashes
    map("n", "<leader>gS", "<cmd>Telescope git_stash<CR>", { desc = "Telescope git stash" })

    -- ── Load extensions ───────────────────────────────────────────────────
    -- Scheduled so it runs after telescope.setup() (lazy calls setup after opts returns).
    vim.schedule(function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        pcall(telescope.load_extension, "fzf") -- faster sorting for every picker
      end
    end)

    -- ── Merged defaults ───────────────────────────────────────────────────
    opts = vim.tbl_deep_extend("force", opts, {
      defaults = {
        -- Show matched file/symbol name in the preview window title bar
        dynamic_preview_title = true,

        preview = { hide_on_startup = false },
        results_title = false,
        selection_caret = " ",
        entry_prefix = " ",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
            preview_width = SIZES.PREVIEW_WIDTH,
          },
        },

        -- Filename-first layout: "init.lua  lua/plugins/" instead of full path.
        -- The noah/telescope.lua custom entry_makers already apply this style for
        -- files/grep/buffers; this covers all other pickers (LSP, git, diagnostics).
        path_display = { "filename_first" },

        file_ignore_patterns = {
          "node_modules/",
          "%.git/",
          "__pycache__/",
          "%.pyc$",
          "%.class$",
          "dist/",
          "build/",
          "%.DS_Store",
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-h>"] = actions_layout.toggle_preview,
            ["<C-l>"] = actions_layout.toggle_preview,
            ["<F1>"] = actions_layout.toggle_preview,
            -- Scroll the preview pane without leaving the prompt
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            -- Show full path in a notification (useful when path is truncated)
            ["<C-g>"] = function()
              local entry = require("telescope.actions.state").get_selected_entry()
              if entry and entry.path then
                vim.notify(entry.path, vim.log.levels.INFO)
              else
                vim.notify("No file selected", vim.log.levels.WARN)
              end
            end,
          },
          n = {
            ["<C-h>"] = actions_layout.toggle_preview,
            ["<F1>"] = actions_layout.toggle_preview,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-g>"] = function()
              local entry = require("telescope.actions.state").get_selected_entry()
              if entry and entry.path then
                vim.notify(entry.path, vim.log.levels.INFO)
              else
                vim.notify("No file selected", vim.log.levels.WARN)
              end
            end,
          },
        },
      },

      pickers = {
        -- Compact dropdown: you want to act on the diff, not scroll a list
        git_status = {
          theme = "dropdown",
          previewer = true,
          prompt_title = "Git Changes",
        },
        -- Branch names are short; dropdown is cleaner than full-screen
        git_branches = {
          theme = "dropdown",
          previewer = false,
          prompt_title = "Git Branches",
        },
        -- Ivy bottom-pane: keeps code visible while browsing errors
        diagnostics = {
          theme = "ivy",
          previewer = true,
          layout_config = { bottom_pane = { height = 0.40 } },
          prompt_title = "Diagnostics",
        },
        -- No preview needed for registers or recent commands
        registers = {
          theme = "dropdown",
          previewer = false,
        },
        command_history = {
          theme = "dropdown",
          previewer = false,
        },
        -- Ivy for keymaps: lets you read code while searching
        keymaps = {
          theme = "ivy",
          layout_config = { bottom_pane = { height = 0.40 } },
        },
        -- Ivy for jumplist: code stays visible, preview shows destination
        jumplist = {
          theme = "ivy",
          previewer = true,
          layout_config = { bottom_pane = { height = 0.40 } },
        },
        -- Dropdown for stash: names are short, no preview needed
        git_stash = {
          theme = "dropdown",
          previewer = false,
        },
        -- Dropdown for commands: just pick and run
        commands = {
          theme = "dropdown",
        },
        -- Dropdown for search history: compact list
        search_history = {
          theme = "dropdown",
          previewer = false,
        },
        -- Dropdown for spell suggest: compact list of suggestions
        spell_suggest = {
          theme = "dropdown",
          previewer = false,
        },
      },
    })

    return opts
  end,
}
