---@type NvPluginSpec
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  event = {
    "BufReadPre " .. vim.fn.expand "~" .. "/vault/**.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/vault/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    local workspaces = {
      { name = "learning", path = "~/vault/learning" },
      { name = "personal", path = "~/vault/personal" },
      { name = "work", path = "~/vault/work" },
    }
    for _, ws in ipairs(workspaces) do
      local path = vim.fn.fnamemodify(ws.path, ":p")
      if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
      end
    end
    return {
      workspaces = workspaces,
      ui = { enable = false },
    }
  end,
}
