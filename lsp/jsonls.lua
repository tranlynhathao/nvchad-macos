-- JSON language server. Loads SchemaStore catalog lazily so
-- ~150+ known schemas (package.json, tsconfig.json, ...) auto-attach.
return {
  before_init = function(_, config)
    local ok, schemastore = pcall(require, "schemastore")
    if not ok then return end
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    })
  end,
}
