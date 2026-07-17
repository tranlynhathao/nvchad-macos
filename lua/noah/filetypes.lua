vim.filetype.add {
  extension = {
    jsonl = "json",
    sage = "python",
    cafe = "cafeobj",
    -- `.cfg` defaults to filetype "cfg" (no syntax file -> no highlighting).
    -- Sniff the content: INI-style files with a `[section]` header become
    -- "dosini" (handles `[section]` + `key=value`); everything else falls
    -- back to the generic "conf" filetype.
    cfg = function(_, bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
      for _, line in ipairs(lines) do
        if line:match "^%s*%[[^%]]+%]%s*$" then return "dosini" end
      end
      return "conf"
    end,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  desc = "Unattach jsonls from jsonl buffers.",
  pattern = "json",
  callback = function(args)
    vim.schedule(function()
      if not args.data then return end

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      local bufname = vim.api.nvim_buf_get_name(args.buf)
      if client.name == "jsonls" and bufname:match "%.jsonl$" then vim.schedule(function() vim.lsp.stop_client(client.id) end) end
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Custom settings for SageMath files",
  pattern = "sage",
  callback = function() vim.bo.commentstring = "# %s" end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "CafeOBJ buffer options",
  pattern = "cafeobj",
  callback = function()
    vim.opt_local.commentstring = "-- %s"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Syntax + indentation for .cfg config files (dosini/conf)",
  pattern = { "dosini", "conf" },
  callback = function()
    -- Built-in $VIMRUNTIME/syntax/{dosini,conf}.vim provide highlighting;
    -- re-asserting it keeps highlighting on for sniffed buffers.
    vim.bo.syntax = vim.bo.filetype
    -- Neither filetype ships an indent script, so set sane local defaults.
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.commentstring = "# %s"
  end,
})
