---@type NvPluginSpec
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DB",
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
    "DBUIRenameBuffer",
    "DBOpenFile",
    "GenSchemaDocs",
    "ERD",
  },
  keys = {
    { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Database: toggle UI" },
    { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Database: add connection" },
    { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Database: find current buffer" },
    { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Database: rename saved query" },
    { "<leader>Do", "<cmd>DBOpenFile<cr>", desc = "Database: open file under cursor" },
    { "<leader>Dc", function() require("noah.pickers").dadbod_conn() end, desc = "Database: pick connection (Telescope)" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_winwidth = 36
    vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/db_ui"
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_use_nvim_notify = 0

    vim.g.db_ui_dotenv_variable_prefix = "DB_"

    vim.g.db_ui_hidden_schemas = {
      "pg_catalog",
      "information_schema",
      "pg_toast",
      "mysql",
      "performance_schema",
      "sys",
    }

    vim.g.db_ui_table_helpers = {
      sqlite = {
        Info = "PRAGMA table_info({table});",
        Indexes = "PRAGMA index_list({table});",
        ForeignKeys = "PRAGMA foreign_key_list({table});",
        Count = "SELECT COUNT(*) AS n FROM {table};",
      },
      postgresql = {
        Info = "SELECT column_name, data_type, is_nullable, column_default FROM information_schema.columns WHERE table_name = '{table}';",
        Size = "SELECT pg_size_pretty(pg_total_relation_size('{table}'));",
        Explain = "EXPLAIN ANALYZE SELECT * FROM {table} LIMIT 100;",
        Count = "SELECT COUNT(*) AS n FROM {table};",
      },
      mysql = {
        Info = "DESCRIBE {table};",
        Status = "SHOW TABLE STATUS WHERE Name = '{table}';",
        Explain = "EXPLAIN SELECT * FROM {table} LIMIT 100;",
        Count = "SELECT COUNT(*) AS n FROM {table};",
      },
    }

    local sqlite_exts = { db = true, sqlite = true, sqlite3 = true }

    local function is_sqlite_file(path)
      local ext = path:match "%.([^.]+)$"
      return ext and sqlite_exts[ext:lower()] or false
    end

    local function sqlite_uri(path) return "sqlite:" .. vim.fn.fnamemodify(path, ":p") end

    vim.api.nvim_create_user_command("DBOpenFile", function(opts)
      local path = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
      if path == "" then
        vim.notify("DBOpenFile: no path provided and current buffer has no file", vim.log.levels.ERROR)
        return
      end
      path = vim.fn.expand(path)
      if vim.fn.filereadable(path) == 0 then
        vim.notify("DBOpenFile: file not readable: " .. path, vim.log.levels.ERROR)
        return
      end
      if not is_sqlite_file(path) then
        vim.notify("DBOpenFile: not a SQLite database (.db/.sqlite/.sqlite3): " .. path, vim.log.levels.ERROR)
        return
      end
      vim.cmd("DB " .. vim.fn.fnameescape(sqlite_uri(path)))
    end, {
      nargs = "?",
      complete = "file",
      desc = "Open a SQLite file (.db/.sqlite/.sqlite3) via Dadbod",
    })

    vim.api.nvim_create_autocmd("BufReadCmd", {
      group = vim.api.nvim_create_augroup("NoahDadbodSqliteGuard", { clear = true }),
      pattern = { "*.db", "*.sqlite", "*.sqlite3" },
      callback = function(ev)
        local bo = vim.bo[ev.buf]
        bo.buftype = "nofile"
        bo.modifiable = true
        bo.readonly = false
        local path = ev.match
        local lines = {
          "-- SQLite database file (opened via NoahDadbodSqliteGuard)",
          "-- path: " .. path,
          "",
          "-- Open in DBUI:",
          "--   :DBOpenFile",
          "-- Or connect directly:",
          "--   :DB " .. sqlite_uri(path),
        }
        pcall(vim.api.nvim_buf_set_lines, ev.buf, 0, -1, false, lines)
        bo.filetype = "sql"
        bo.modifiable = false
        bo.readonly = true
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NoahDadbodCompletion", { clear = true }),
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        local ok, cmp = pcall(require, "cmp")
        if not ok then return end
        cmp.setup.buffer {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          },
        }
      end,
    })

    local function have(bin) return vim.fn.executable(bin) == 1 end

    local function first_arg_or_current_db(args)
      if args and args ~= "" then return args end
      local path = vim.api.nvim_buf_get_name(0)
      if path ~= "" and is_sqlite_file(path) then return sqlite_uri(path) end
      return nil
    end

    vim.api.nvim_create_user_command("GenSchemaDocs", function(opts)
      if not have "tbls" then
        vim.notify("GenSchemaDocs: `tbls` not found. Install: brew install k1low/tap/tbls", vim.log.levels.ERROR)
        return
      end
      local dsn = first_arg_or_current_db(opts.args)
      if not dsn then
        vim.notify("GenSchemaDocs: pass a DSN, e.g. :GenSchemaDocs sqlite:///tmp/app.db", vim.log.levels.ERROR)
        return
      end
      local out_dir = opts.fargs[2] or (vim.uv.cwd() .. "/docs/schema")
      vim.fn.mkdir(out_dir, "p")
      vim.notify("tbls doc " .. dsn .. " -> " .. out_dir)
      vim.system(
        { "tbls", "doc", "-f", "--er-format", "mermaid", dsn, out_dir },
        { text = true },
        vim.schedule_wrap(function(res)
          if res.code ~= 0 then
            vim.notify("tbls failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
            return
          end
          vim.notify("Schema docs written to " .. out_dir)
          vim.cmd.edit(out_dir .. "/README.md")
        end)
      )
    end, {
      nargs = "*",
      complete = "file",
      desc = "Generate schema docs + Mermaid ERD via tbls",
    })

    vim.api.nvim_create_user_command("ERD", function(opts)
      if not have "tbls" then
        vim.notify("ERD: `tbls` not found. Install: brew install k1low/tap/tbls", vim.log.levels.ERROR)
        return
      end
      local dsn = first_arg_or_current_db(opts.args)
      if not dsn then
        vim.notify("ERD: pass a DSN, e.g. :ERD postgresql://user@localhost:5432/db", vim.log.levels.ERROR)
        return
      end
      vim.system(
        { "tbls", "out", "-t", "mermaid", dsn },
        { text = true },
        vim.schedule_wrap(function(res)
          if res.code ~= 0 then
            vim.notify("tbls out failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
            return
          end
          vim.cmd "new"
          local buf = vim.api.nvim_get_current_buf()
          local lines = { "```mermaid" }
          for line in (res.stdout or ""):gmatch "[^\n]+" do
            table.insert(lines, line)
          end
          table.insert(lines, "```")
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].filetype = "markdown"
          vim.bo[buf].buftype = "nofile"
          vim.bo[buf].bufhidden = "wipe"
          vim.api.nvim_buf_set_name(buf, "ERD://" .. dsn)
        end)
      )
    end, {
      nargs = "?",
      desc = "Generate Mermaid ERD (tbls out -t mermaid) as markdown buffer",
    })
  end,
}
