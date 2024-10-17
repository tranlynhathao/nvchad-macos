---@type NvPluginSpec
return {
  "jpalardy/vim-slime",
  -- keys = {
  --   {
  --     "<leader>s",
  --     function()
  --       vim.fn["slime#send_op"](vim.fn.visualmode(), 1)
  --     end,
  --     mode = "v",
  --   },
  --   {
  --     "<leader>sb",
  --     "<cmd>lua require('slime').send_current_buffer()<CR>",
  --     mode = "n",
  --   },
  -- },
  config = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_default_config = {
      socket = "default",
      target_pane = "{last}",
    }
  end,
}
