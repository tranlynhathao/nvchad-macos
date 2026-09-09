-- sql-language-server (joe-re/sql-language-server).
--
-- Connections live in ~/.config/sql-language-server/.sqllsrc.json OR
-- <project-root>/.sqllsrc.json. Format:
--   {
--     "connections": [
--       {
--         "name": "local-postgres",
--         "adapter": "postgresql",
--         "host": "localhost",
--         "port": 5432,
--         "user": "postgres",
--         "database": "app_dev",
--         "projectPaths": ["/Users/you/project"]
--       }
--     ]
--   }
--
-- Without a connection, sqlls still gives keyword completion, syntax hover,
-- and dialect-aware validation.

return {
  filetypes = { "sql", "mysql", "plsql" },
  root_markers = { ".sqllsrc.json", ".git" },
  settings = {
    sqlLanguageServer = {
      lint = {
        rules = {
          ["align-column-to-the-first"] = "error",
          ["column-new-line"] = "error",
          ["linebreak-after-clause-keyword"] = "off",
          ["reserved-word-case"] = { "error", "upper" },
          ["space-surrounding-operators"] = "error",
          ["where-clause-new-line"] = "error",
          ["align-where-clause-to-the-first"] = "error",
        },
      },
      format = {
        keywordCase = "upper",
      },
    },
  },
}
