---@type NvPluginSpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    enabled = true,
    file_types = { "markdown" },
    latex = {
      enabled = true,
      converter = { "/opt/homebrew/bin/utftex", "utftex", "latex2text" },
      position = "center",
      highlight = "RenderMarkdownMath",
      top_pad = 0,
      bottom_pad = 0,
    },
    heading = {
      enabled = true,
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      sign = true,
    },
    bullet = { enabled = true, icons = { "•", "◦", "▪", "▸" } },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰄵 " },
      custom = {},
    },
    quote = { enabled = true, icon = "┃" },
    code = {
      enabled = true,
      style = "full",
      position = "left",
      language = true,
      inline = true,
    },
    link = { enabled = true },
    pipe_table = { enabled = true },
  },
  keys = {
    { "<leader>mr", "<cmd>lua require('render-markdown').toggle()<cr>", desc = "Markdown: toggle render" },
    { "<leader>mR", "<cmd>lua require('render-markdown').refresh()<cr>", desc = "Markdown: refresh" },
  },
  config = function(_, opts)
    local homebrew_bin = "/opt/homebrew/bin"
    local path = vim.env.PATH or ""
    if vim.fn.isdirectory(homebrew_bin) == 1 and not path:find(vim.pesc(homebrew_bin)) then
      vim.env.PATH = homebrew_bin .. ":" .. path
    end
    require("render-markdown").setup(opts)
    vim.api.nvim_set_hl(0, "RenderMarkdownMath", { italic = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
      end,
    })
  end,
}
