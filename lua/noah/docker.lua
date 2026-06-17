return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dockerfile" })
      end
    end,
  },
  -- null-ls removed; hadolint now runs via nvim-lint (see nvim-lint.lua).
  -- Mason installs hadolint through ensure_installed in mason.lua.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  {
    "telescope.nvim",
    dependencies = {
      {
        "lpoto/telescope-docker.nvim",
        opts = {},
        config = function(_, opts)
          require("telescope").load_extension "docker"
        end,
        keys = {
          { "<leader>fd", "<Cmd>Telescope docker<CR>", desc = "Docker" },
        },
      },
    },
  },
}
