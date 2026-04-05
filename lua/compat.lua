local M = {}

if vim.g.noah_compat_loaded then
  return M
end

vim.g.noah_compat_loaded = true

if vim.health then
  vim.health.report_start = vim.health.report_start or vim.health.start
  vim.health.report_info = vim.health.report_info or vim.health.info
  vim.health.report_ok = vim.health.report_ok or vim.health.ok
  vim.health.report_warn = vim.health.report_warn or vim.health.warn
  vim.health.report_error = vim.health.report_error or vim.health.error
end

if vim.fn.has "nvim-0.12" == 1 then
  local ts = vim.treesitter
  local original_validate = vim.validate
  local original_str_utfindex = vim.str_utfindex
  local original_get_node_range = ts.get_node_range
  local original_get_range = ts.get_range
  local original_get_node_text = ts.get_node_text
  local original_is_ancestor = ts.is_ancestor
  local original_node_contains = ts.node_contains
  local original_is_in_node_range = ts.is_in_node_range

  local function unwrap_ts_node(value)
    if type(value) ~= "table" then
      return value
    end

    local first = value[1]
    if type(first) == "userdata" then
      return first
    end
    if type(first) == "table" and type(first.range) == "function" then
      return first
    end

    return value
  end

  -- Keep older plugins working without tripping 0.12's deprecation warnings.
  vim.validate = function(name, value, validator, optional, message)
    if validator ~= nil or type(name) ~= "table" then
      return original_validate(name, value, validator, optional, message)
    end

    local keys = vim.tbl_keys(name)
    table.sort(keys)

    for _, param_name in ipairs(keys) do
      local spec = name[param_name]
      if type(spec) ~= "table" then
        error(string.format("opt[%s]: expected table, got %s", param_name, type(spec)), 2)
      end

      original_validate(param_name, spec[1], spec[2], spec[3], spec[4])
    end
  end

  vim.str_utfindex = function(s, encoding, index, strict_indexing)
    if encoding == nil or type(encoding) == "number" then
      original_validate("s", s, "string")
      original_validate("index", encoding, "number", true)

      local col32, col16 = vim._str_utfindex(s, encoding)
      if not col32 or not col16 then
        error "index out of range"
      end

      return col32, col16
    end

    return original_str_utfindex(s, encoding, index, strict_indexing)
  end

  -- Neovim 0.12 query iterators can return TSNode[] capture tables where older
  -- plugins still expect a single TSNode.
  ts.get_node_range = function(node_or_range)
    return original_get_node_range(unwrap_ts_node(node_or_range))
  end

  ts.get_range = function(node, source, metadata)
    return original_get_range(unwrap_ts_node(node), source, metadata)
  end

  ts.get_node_text = function(node, source, opts)
    return original_get_node_text(unwrap_ts_node(node), source, opts)
  end

  ts.is_ancestor = function(dest, source)
    return original_is_ancestor(unwrap_ts_node(dest), unwrap_ts_node(source))
  end

  ts.node_contains = function(node, range)
    return original_node_contains(unwrap_ts_node(node), range)
  end

  ts.is_in_node_range = function(node, line, col)
    return original_is_in_node_range(unwrap_ts_node(node), line, col)
  end
end

if not vim.g.noah_lsp_float_defaults then
  vim.g.noah_lsp_float_defaults = true

  local border = "rounded"
  local original_hover = vim.lsp.buf.hover
  local original_signature_help = vim.lsp.buf.signature_help

  -- Preserve the old global rounded-border behavior using the 0.12 buf API.
  vim.lsp.buf.hover = function(config)
    return original_hover(vim.tbl_deep_extend("force", { border = border }, config or {}))
  end

  vim.lsp.buf.signature_help = function(config)
    return original_signature_help(vim.tbl_deep_extend("force", { border = border }, config or {}))
  end
end

return M
