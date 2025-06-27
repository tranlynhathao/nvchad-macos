-- @type NvPluginSpec
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "java", "python", "rust", "markdown", "markdown_inline" } },
    },
  },
  opts = function(_, opts)
    dofile(vim.g.base46_cache .. "markview")
    local presets = require "markview.presets"

    ---@type markview.configuration
    ---@diagnostic disable-next-line
    local new_opts = {
      preview = {
        modes = { "i", "n", "v", "vs", "V", "Vs", "no", "c" },
        hybrid_modes = { "i" },

        ---@diagnostic disable-next-line
        callbacks = {
          on_enable = function(_, win)
            -- https://github.com/OXY2DEV/markview.nvim/issues/75

            vim.wo[win].wrap = false
            -- https://segmentfault.com/q/1010000000532491
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nivc"

            -- vim.wo[win].wrap = true
            -- vim.wo[win].linebreak = true
            -- vim.wo[win].breakindent = true
          end,
        },
      },
      markdown = {
        headings = presets.headings.arrowed,
        tables = {
          use_virt_lines = true,
          style = "rounded",
        },
      },
      checkboxes = presets.checkboxes.nerd,
      -- markdown_inline = {
      --   entities = {
      --     enable = true,
      --     hl = nil,
      --   },
      --   highlight = {
      --     enable = true,
      --   },
      -- },
      highlight_groups = "dynamic",
      ---@diagnostic disable-next-line
      markdown_inline = {
        enable = true,
        ---@diagnostic disable-next-line
        tags = {
          enable = true,
          default = {
            conceal = true,
            ---@type string?
            hl = nil,
          },
        },
        entities = {
          enable = true,
          hl = nil,
        },
      },
      -- markdown_inline = {
      --   entities = {
      --     enable = true,
      --     hl = "SpecialComment",
      --   },
      --   highlight = {
      --     enable = true,
      --     hl_groups = {
      --       bold = "Bold",
      --       italic = "Italic",
      --       code = "String", -- inline `code`
      --       link = "Identifier", -- [text](url)
      --       strikethrough = "Comment",
      --     },
      --   },
      -- },
      -- html = {
      --   enable = true,
      --   tags = {
      --     enable = true,
      --     default = {
      --       conceal = true,
      --       hl = nil,
      --     },
      --   },
      -- },
      html = {
        enable = true,
        tags = {
          enable = true,
          default = {
            conceal = true,
            hl = "Todo",
          },
          custom = {
            span = {
              conceal = false,
              hl = function(attrs)
                if attrs.style and attrs.style:match "color:red" then
                  return "ErrorMsg"
                end
              end,
            },
          },
        },
      },
      symbols = {
        enable = true,
        custom = {
          ["✅"] = { char = "✔", hl = "DiffAdd" },
          ["❌"] = { char = "✖", hl = "DiffDelete" },
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
