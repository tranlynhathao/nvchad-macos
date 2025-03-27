-- @type NvPluginSpec
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "java", "markdown", "markdown_inline" } } },
  },
  opts = function(_, opts)
    local presets = require "markview.presets"

    ---@type markview.configuration
    ---@diagnostic disable-next-line
    local new_opts = {
      preview = {
        modes = { "i", "n", "v", "vs", "V", "Vs", "no", "c" },
        hybrid_modes = { "i" },
        callbacks = {
          on_enable = function(_, win)
            -- https://github.com/OXY2DEV/markview.nvim/issues/75

            vim.wo[win].wrap = false
            -- https://segmentfault.com/q/1010000000532491
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nivc"
          end,
        },
      },
      markdown = {
        headings = presets.headings.arrowed,
        tables = {
          use_virt_lines = true,
        },
      },
      checkboxes = presets.checkboxes.nerd,
      markdown_inline = {
        entities = {
          enable = true,
          hl = nil,
        },
        highlight = {
          enable = true,
        },
      },
      html = {
        enable = true,
        tags = {
          enable = true,
          default = {
            conceal = true,
            hl = nil,
          },
        },
      },
    }

    -- Treesitter setup
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "java", "markdown", "markdown_inline" },
      highlight = { enable = true },
    }

    opts = vim.tbl_deep_extend("force", new_opts, opts or {})
    return opts
  end,
}
