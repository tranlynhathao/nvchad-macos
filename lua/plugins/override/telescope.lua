---@type NvPluginSpec
return {
  "nvim-telescope/telescope.nvim",
  requires = {
    { "nvim-lua/plenary.nvim" },
    -- { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    -- { "nvim-telescope/telescope-ui-select.nvim" },
    -- { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-frecency.nvim" },
    -- { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-github.nvim" },
    -- { "nvim-telescope/telescope-packer.nvim" },
    -- { "nvim-telescope/telescope-undo.nvim" },
    -- { "nvim-telescope/telescope-media-files.nvim" },
    -- { "nvim-telescope/telescope-project.nvim" },
    -- { "nvim-telescope/telescope-hop.nvim" },
    -- { "nvim-telescope/telescope-prompt.nvim" },
    -- { "nvim-telescope/telescope-vim-bookmarks.nvim" },
    -- { "nvim-telescope/telescope-emoji.nvim" },
  },
  opts = function(_, opts)
    local map = vim.keymap.set
    local pickers = require("gale.telescope").pickers
    local SIZES = {
      HEIGHT = 0.9,
      WIDTH = 0.9,
      PREVIEW_WIDTH = 0.5,
    }

    map("n", "<leader>fa", function()
      pickers.files("find", {
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
          },
        },
        previewer = true,
        follow = true,
        no_ignore = true,
        hidden = true,
        prompt_prefix = " 󱡴  ",
        prompt_title = "All Files",
      })
    end, { desc = "Telescope search all files" })

    map("n", "<leader>ff", function()
      pickers.files("find", {
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
          },
        },
        previewer = true,
        prompt_title = "Files",
      })
    end, { desc = "Telescope search files" })

    map("n", "<leader>fo", function()
      pickers.files("old", {
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
          },
        },
        previewer = true,
        prompt_title = "Old Files",
      })
    end, { desc = "Telescope search recent files" })

    -- Add keybinding for telescope file browser
    map("n", "<leader>gh", "<cmd>Telescope github issues<CR>", { desc = "Search GitHub Issues" })
    map("n", "<leader>gp", "<cmd>Telescope github pull_requests<CR>", { desc = "Search GitHub PRs" })
    map("n", "<leader>gr", "<cmd>Telescope github repos<CR>", { desc = "Search GitHub Repos" })

    -- Add keybinding for telescope frecency
    map("n", "<leader>fr", "<cmd>Telescope frecency<CR>", { desc = "Search recently opened files" })

    map("n", "<leader>fw", function() -- CTRL Q combinations [:cdo ]
      pickers.grep("live_grep", nil, nil, {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
          },
          -- vertical = {
          --   width = 0.8,
          --   height = 0.8,
          --   preview_width = 0.5,
          -- },
        },
        previewer = true,
        prompt_title = "Live Grep",
      })
    end, { desc = "Telescope live grep" })

    map("n", "<leader>fb", function()
      pickers.buffers(true, {
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
          },
        },
        previewer = true,
      })
    end, { desc = "Telescope buffers" })

    map("n", "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current file" })
    map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Telescope terms" })
    map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope NvChad themes" })
    map("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Telescope LSP references" })
    map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
    map("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Telescope find highlights" })
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope LSP diagnostics" })
    map("n", "<leader>ts", "<cmd>Telescope treesitter<CR>", { desc = "Telescope TreeSitter" })
    map("n", "<leader>fp", "<cmd>Telescope builtin<CR>", { desc = "Telescope pickers" })
    map("n", "<leader>gcm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
    map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
    map("n", "<leader>f?", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help tags" })

    opts = vim.tbl_deep_extend("force", opts, {
      defaults = {
        preview = {
          hide_on_startup = false, -- hide preview: true
        },
        results_title = false,
        selection_caret = " ",
        entry_prefix = " ",
        layout_strategy = "horizontal", -- "dropdown", "vertical", "center", "horizontal"
        layout_config = {
          horizontal = {
            width = SIZES.WIDTH,
            height = SIZES.HEIGHT,
            preview_width = SIZES.PREVIEW_WIDTH,
          },
        },
        file_ignore_patterns = { "node_modules" },
        -- sorting_strategy = "ascending", -- ascending, descending
        -- path_display can combine multiple options
        -- path_display = { "smart", "truncate" }, -- tail, relative, shorten, smart, truncate, hidden, filename_first, absolute
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-h>"] = require("telescope.actions.layout").toggle_preview,
            ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
            ["<F1>"] = require("telescope.actions.layout").toggle_preview,
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
            ["<C-h>"] = require("telescope.actions.layout").toggle_preview,
            ["<F1>"] = require("telescope.actions.layout").toggle_preview,
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
      -- pickers = {
      --   builtin = {
      --     prompt_title = "Builtin Pickers",
      --   },
      -- },
      pickers = {
        git_status = {
          theme = "dropdown",
          previewer = true,
          prompt_title = "Git Changes",
        },
      },
    })

    return opts
  end,
}
