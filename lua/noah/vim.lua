if vim.fn.exists ":LspInfo" == 0 then
  vim.api.nvim_create_user_command("LspInfo", function()
    require("noah.lspinfo").show()
  end, { desc = "Show active LSP info for current buffer" })
end

vim.cmd [[
  function! LspHealthCheck(...)
    if exists(':LspInfo')
      LspInfo
    else
      execute 'checkhealth vim.lsp'
    endif
  endfunction
]]

vim.cmd [[
  function! RunNeogit(...)
    lua require("neogit").open()
  endfunction
]]

vim.cmd [[
  function! RunHarpoon(...)
    call v:lua.require('noah.harpoon').toggle_menu()
  endfunction
]]

vim.cmd [[
  function! OilDirCWD(...)
    Oil ./
  endfunction
]]
