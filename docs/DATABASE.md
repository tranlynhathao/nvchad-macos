# Database workflow (Dadbod / DBUI)

Neovim database explorer via [vim-dadbod-ui] backed by [tpope/vim-dadbod].

## Plugins

| Plugin                                 | Role                                                |
| -------------------------------------- | --------------------------------------------------- |
| `tpope/vim-dadbod`                     | Query engine, connection layer                      |
| `kristijanhusak/vim-dadbod-ui`         | Sidebar UI, connection tree, saved queries          |
| `kristijanhusak/vim-dadbod-completion` | `nvim-cmp` source for tables/columns in SQL buffers |

Spec: `lua/plugins/override/vim-dadbod-ui.lua` (single authoritative file).

## System CLI requirements

Dadbod shells out to the vendor client:

| Driver          | Required CLI | Install                                                                  |
| --------------- | ------------ | ------------------------------------------------------------------------ |
| SQLite          | `sqlite3`    | already present (Xcode / Android SDK) — `brew install sqlite` if missing |
| PostgreSQL      | `psql`       | `brew install postgresql@15`                                             |
| MySQL / MariaDB | `mysql`      | `brew install mysql`                                                     |

All three are currently available on this machine.

### Visualization tool

| Tool   | Used by                  | Install                       |
| ------ | ------------------------ | ----------------------------- |
| `tbls` | `:GenSchemaDocs`, `:ERD` | `brew install k1low/tap/tbls` |

Single Go binary, no runtime deps. Both commands print an install hint if missing — nothing else breaks.

`mermerd` was evaluated but requires interactive table-select prompts by default (needs a `--runConfig` file to run non-interactively), so `tbls out -t mermaid` is used for `:ERD` instead — same Mermaid output, one less tool.

## LSP

`sqlls` (sql-language-server) is enabled for `sql`/`mysql`/`plsql`. Mason installs it via npm (in the `ensure_installed` list).

Config file: `lsp/sqlls.lua`. Real connections are attached via `~/.config/sql-language-server/.sqllsrc.json` or `<project>/.sqllsrc.json`:

```json
{
  "connections": [
    {
      "name": "local-pg",
      "adapter": "postgresql",
      "host": "localhost",
      "port": 5432,
      "user": "postgres",
      "database": "app_dev",
      "projectPaths": ["/Users/you/project"]
    }
  ]
}
```

Without a connection file, sqlls still gives keyword completion, syntax check, and formatting (uppercased keywords).

## Dadbod table helpers

Sidebar → table → these run instantly without typing SQL:

| SQLite                   | PostgreSQL                        | MySQL           |
| ------------------------ | --------------------------------- | --------------- |
| Info (PRAGMA table_info) | Info (information_schema.columns) | Info (DESCRIBE) |
| Indexes                  | Size (pg_size_pretty)             | Status          |
| ForeignKeys              | Explain                           | Explain         |
| Count                    | Count                             | Count           |

## Commands

| Command                         | Purpose                                                                    |
| ------------------------------- | -------------------------------------------------------------------------- |
| `:DBUI`                         | Open sidebar                                                               |
| `:DBUIToggle`                   | Toggle sidebar                                                             |
| `:DBUIAddConnection`            | Interactive connection prompt                                              |
| `:DBUIFindBuffer`               | Jump sidebar cursor to the DB owning the current query buffer              |
| `:DBUIRenameBuffer`             | Rename a saved query file                                                  |
| `:DBOpenFile [path]`            | Open a SQLite file via Dadbod (defaults to current buffer's path)          |
| `:DB <URI>`                     | One-shot connect (dadbod core)                                             |
| `:GenSchemaDocs [dsn] [outdir]` | `tbls doc` → Markdown docs + Mermaid ERD (default outdir: `./docs/schema`) |
| `:ERD [dsn]`                    | `tbls out -t mermaid` → Mermaid ERD in a scratch markdown buffer           |

`:GenSchemaDocs` and `:ERD` fall back to the current buffer's `.db/.sqlite/.sqlite3` if `dsn` is omitted.

## Keymaps

All under `<leader>D` (WhichKey group `Database`).

| Keys         | Action                                            |
| ------------ | ------------------------------------------------- |
| `<leader>Du` | Toggle DBUI                                       |
| `<leader>Da` | Add connection                                    |
| `<leader>Df` | Find current DB buffer in sidebar                 |
| `<leader>Dr` | Rename saved query                                |
| `<leader>Do` | `:DBOpenFile` (opens current buffer's `.db` file) |

Inside DBUI sidebar, plugin-local mappings work as documented (`o` open, `S` open in split, `d` delete, `R` refresh, etc.).

Inside a query buffer opened by DBUI: `<leader>S` executes the query (dadbod-ui default).

## Opening a SQLite file

```vim
:DBOpenFile /absolute/path/to/database.db
```

or from the file explorer / fff — put cursor on the file, `:DBOpenFile` (no arg → uses current buffer path). Auto-detected extensions: `.db`, `.sqlite`, `.sqlite3`.

A `BufReadCmd` guard prevents these extensions from being read as text — opening one shows a 7-line hint buffer with the `:DBOpenFile` and `:DB sqlite:...` commands ready to use.

## Connection URIs

| Driver          | URI                                                |
| --------------- | -------------------------------------------------- |
| SQLite          | `sqlite:/absolute/path/to/db.sqlite`               |
| PostgreSQL      | `postgresql://user:password@localhost:5432/dbname` |
| MySQL / MariaDB | `mysql://user:password@localhost:3306/dbname`      |

**Do NOT commit passwords.** Prefer:

- Interactive: `:DBUIAddConnection` and let DBUI store the connection in `$XDG_DATA_HOME/nvim/db_ui/connections.json`
- Environment: `postgresql://user@localhost/dbname?password=$MY_DB_PASS` (dadbod expands env)
- `.env` in project root + `$DBUI_ENV_FILE`

## Completion

`vim-dadbod-completion` is registered as a per-buffer `nvim-cmp` source on `FileType sql`, `mysql`, `plsql` (autogroup `NoahDadbodCompletion`). It queries the active `:DB` connection for tables and columns.

## Files touched

- `lua/plugins/override/vim-dadbod-ui.lua` — spec + keymaps + `:DBOpenFile` + `BufReadCmd` guard + cmp FileType wiring
- `lua/plugins/override/whichkey.lua` — added `<leader>D` group label

## Config knobs (init-time `vim.g.*`)

```lua
vim.g.db_ui_use_nerd_fonts           = 1
vim.g.db_ui_show_database_icon       = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_win_position             = "left"
vim.g.db_ui_winwidth                 = 36
vim.g.db_ui_save_location            = vim.fn.stdpath("data") .. "/db_ui"
vim.g.db_ui_execute_on_save          = 0   -- don't run query on :w
vim.g.db_ui_use_nvim_notify          = 0
```
