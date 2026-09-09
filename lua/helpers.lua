-- all vim helper functions here
vim.keymap.set("n", "<leader>ce", function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line "." - 1 })
  if #diagnostics > 0 then
    local message = diagnostics[1].message
    vim.fn.setreg("+", message)
    print("Copied diagnostics: " .. message)
  else
    print "No diagnostics at cursor"
  end
end, { noremap = true, silent = true })

-- go to errors in a file
vim.keymap.set("n", "<leader>ne", function() vim.diagnostic.jump { count = 1 } end) -- next err
vim.keymap.set("n", "<leader>pe", function() vim.diagnostic.jump { count = -1 } end) -- previous err

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- -- copy current file path (absolute) into clipboard
-- vim.keymap.set("n", "<leader>cp", function()
--   local filepath = vim.fn.expand "%:p"
--   vim.fn.setreg("+", filepath) -- Copy to Neovim clipboard
--   vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
--   print("Copied: " .. filepath)
-- end, { desc = "Copy absolute path to clipboard" })
--
-- -- open the current file in browser
-- vim.keymap.set("n", "<leader>ob", function()
--   local file_path = vim.fn.expand "%:p" -- get the current file path
--   if file_path ~= "" then
--     local cmd
--     if vim.fn.has "mac" == 1 then
--       local firefox_installed = vim.fn.system "which /Applications/Firefox.app/Contents/MacOS/firefox"
--       if firefox_installed == "" then
--         cmd = "open -a 'Google Chrome' " .. file_path
--       else
--         cmd = "open -a 'Firefox' " .. file_path
--       end
--     else
--       local firefox_path = vim.fn.system("which firefox"):gsub("\n", "")
--       local has_firefox = firefox_path ~= ""
--       if has_firefox then
--         cmd = "google-chrome " .. file_path
--       end
--       cmd = "firefox " .. file_path
--     end
--     os.execute(cmd .. " &")
--   else
--     print "No file to open"
--   end
-- end, { desc = "Open current file in browser" })

-- set language based on vim mode
-- requires macism https://github.com/laishulu/macism
-- recommend installing it by brew
local sysname = vim.uv.os_uname().sysname
local is_mac = sysname == "Darwin"
local is_linux = sysname == "Linux"

if is_mac then
  local english_layout = "com.apple.keylayout.ABC"
  local last_insert_layout = english_layout
  local mode_generation = 0
  local pending_set

  local function has_ui() return #vim.api.nvim_list_uis() > 0 end

  local function set_layout(layout)
    if not has_ui() or not layout or layout == "" then return end

    if pending_set then pcall(pending_set.kill, pending_set, 15) end

    local process
    process = vim.system({ "macism", layout }, { text = true }, function()
      vim.schedule(function()
        if pending_set == process then pending_set = nil end
      end)
    end)
    pending_set = process
  end

  local function remember_layout_then_use_english()
    if not has_ui() then return end
    mode_generation = mode_generation + 1
    local generation = mode_generation

    -- macism can take hundreds of milliseconds on newer macOS releases.
    -- Keep it off the editor's main loop so mode changes remain immediate.
    vim.system({ "macism" }, { text = true }, function(result)
      local layout = result.code == 0 and vim.trim(result.stdout or "") or ""
      vim.schedule(function()
        if generation ~= mode_generation then return end
        if layout ~= "" then last_insert_layout = layout end
        if vim.fn.mode() ~= "i" then set_layout(english_layout) end
      end)
    end)
  end

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = remember_layout_then_use_english,
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    callback = function() set_layout(english_layout) end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      mode_generation = mode_generation + 1
      set_layout(last_insert_layout)
    end,
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      if vim.fn.mode() == "i" then
        set_layout(last_insert_layout)
      else
        set_layout(english_layout)
      end
    end,
  })
elseif is_linux then
  local last_layout = "keyboard-us" -- English is default

  local function get_fcitx_layout()
    local f = io.popen "fcitx5-remote -n"
    if f ~= nil then
      local result = f:read "*all"
      f:close()
      if result then return result:gsub("%s+", "") end
    end
    return "keyboard-us" -- fallback English
  end

  local function set_fcitx_layout(layout) os.execute("fcitx5-remote -s " .. layout) end

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      last_layout = get_fcitx_layout()
      set_fcitx_layout "keyboard-us" -- change to English
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function() set_fcitx_layout(last_layout) end,
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      if vim.fn.mode() == "i" then
        set_fcitx_layout(last_layout)
      else
        set_fcitx_layout "keyboard-us"
      end
    end,
  })
end

-- Show folder/dir structure
vim.api.nvim_create_user_command("ShowTree", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  local width = math.floor(editor_width * 0.6)
  local height = math.floor(editor_height * 0.9)

  local row = math.floor((editor_height - height) / 2)
  local col = math.floor((editor_width - width) / 2)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    style = "minimal",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  local job_id = vim.fn.jobstart("tree -L 4", {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          vim.api.nvim_buf_set_lines(buf, -1, -1, true, { line })
        end
      end
    end,
    on_exit = function() vim.api.nvim_win_close(win, true) end,
  })
  print("Job ID: " .. job_id)
end, {})

vim.keymap.set("n", "<leader>vt", ":ShowTree<CR>", { desc = "Show directory tree in floating window" })
