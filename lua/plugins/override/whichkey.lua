---@type NvPluginSpec
return {
  "folke/which-key.nvim",
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "WhichKey show all keymaps" })
    map("n", "<leader>wk", function() vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ") end, { desc = "WhichKey query lookup" })
    map("n", "<leader>?", function() require("which-key").show { keys = "<leader>", loop = true } end, { desc = "Full leader keymap help (loop)" })
  end,
  opts = {
    preset = "modern",

    delay = function(ctx) return ctx.plugin and 0 or 500 end,

    icons = {
      rules = false,
      separator = "  ",
      colors = true,
    },

    notify = false,

    win = {
      no_overlap = true,
      row = math.huge,
      border = "rounded",
      padding = { 0, 1 },
      title = false,
      title_pos = "center",
      height = { min = 4, max = 9 },
      wo = {
        winblend = 0,
        winhighlight = "Normal:WhichKeyFloat,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle",
      },
    },

    layout = {
      width = { min = 18, max = 30 },
      spacing = 2,
      align = "left",
    },

    sort = { "group", "alphanum", "mod" },

    expand = 0,

    show_help = false,
    show_keys = true,

    spec = {
      -- top-level namespaces
      -- { "<leader>f", group = "Find / Telescope" },
      { "<leader>f", group = "Find / Search" },
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Git hunks" },
      { "<leader>gm", group = "Git merge / conflicts" },
      { "<leader>gH", group = "GitHub / Octo" },
      { "<leader>d", group = "Debug / DAP" },
      { "<leader>D", group = "Database" },
      { "<leader>b", group = "Blockchain / Build" },
      { "<leader>r", group = "Run / Rust" },
      { "<leader>m", group = "Marks" },
      { "<leader>p", group = "Popup / Preview" },
      { "<leader>n", group = "Navigate / Next" },
      { "<leader>w", group = "Workspace / Window" },
      { "<leader>Q", group = "Project sessions" },
      { "<leader>t", group = "Toggle / Theme" },
      { "<leader>c", group = "Code" },
      { "<leader>s", group = "Surround / Snippet" },
      { "<leader>o", group = "Open / Oil" },
      { "<leader>z", group = "Zen / Fold" },
    },
  },
}
