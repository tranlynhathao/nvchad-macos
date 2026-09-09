---@type NvPluginSpec
return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local map = vim.keymap.set
    local ls = require "luasnip"
    local data = vim.fn.stdpath "data"
    local config = vim.fn.stdpath "config"

    -- Avoid NvChad's empty-path runtime scan. Both roots below contain a
    -- package.json manifest, so LuaSnip does no warning-producing probing.
    require("luasnip.loaders.from_vscode").lazy_load {
      paths = {
        data .. "/lazy/friendly-snippets",
        config .. "/snippets",
      },
    }

    ls.filetype_extend("javascriptreact", { "html" })
    ls.filetype_extend("typescriptreact", { "html" })
    ls.filetype_extend("javascriptreact", { "javascript" })
    ls.filetype_extend("typescriptreact", { "javascript" })

    map({ "s", "i" }, "<C-y>", function() ls.expand() end, { desc = "Luasnip confirm snippet" })

    map({ "s", "i" }, "<C-j>", function() ls.jump(-1) end, { desc = "Luasnip jump backward" })

    map({ "s", "i" }, "<C-k>", function() ls.jump(1) end, { desc = "Luasnip jump forward" })

    vim.keymap.set({ "i", "s" }, "<C-e>", function()
      if ls.choice_active() then ls.change_choice(1) end
    end, { desc = "Luasnip change active choice" })
  end,
}
