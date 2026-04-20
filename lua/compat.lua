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
  local original_diagnostic_enable = vim.diagnostic.enable
  local legacy_validators = {
    n = "number",
    s = "string",
    t = "table",
    b = "boolean",
    f = "function",
    c = vim.is_callable,
  }

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

  local function normalize_diagnostic_filter(value, namespace)
    if type(value) == "number" then
      return namespace and { bufnr = value, ns_id = namespace } or { bufnr = value }
    end

    if value == nil then
      return namespace and { ns_id = namespace } or nil
    end

    if type(value) == "table" then
      if namespace ~= nil and value.ns_id == nil then
        return vim.tbl_extend("keep", value, { ns_id = namespace })
      end
      return value
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

      if type(spec[2]) == "string" and legacy_validators[spec[2]] ~= nil then
        spec[2] = legacy_validators[spec[2]]
      end

      original_validate(param_name, spec[1], spec[2], spec[3], spec[4])
    end
  end

  if not vim.g.noah_diagnostic_compat then
    vim.diagnostic.enable = function(enable, filter)
      if type(enable) == "boolean" then
        return original_diagnostic_enable(enable, filter)
      end

      return original_diagnostic_enable(true, normalize_diagnostic_filter(enable, filter))
    end

    if type(vim.diagnostic.disable) ~= "function" then
      vim.diagnostic.disable = function(filter, namespace)
        return original_diagnostic_enable(false, normalize_diagnostic_filter(filter, namespace))
      end
    end

    vim.g.noah_diagnostic_compat = true
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

if not vim.g.noah_tsdk_compat then
  vim.g.noah_tsdk_compat = true

  local mason_tsdk = vim.fn.stdpath "data" .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
  local original_lsp_start = vim.lsp.start
  local original_lsp_start_client = vim.lsp.start_client

  local function valid_tsdk(path)
    if type(path) ~= "string" or path == "" or vim.fn.isdirectory(path) ~= 1 then
      return false
    end

    local typescript_js = vim.fs.joinpath(path, "typescript.js")
    local tsserverlibrary_js = vim.fs.joinpath(path, "tsserverlibrary.js")
    return vim.uv.fs_stat(typescript_js) ~= nil or vim.uv.fs_stat(tsserverlibrary_js) ~= nil
  end

  local function resolve_typescript_tsdk(root_dir)
    if valid_tsdk(vim.g.tsdk) then
      return vim.g.tsdk
    end

    local ok, util = pcall(require, "lspconfig.util")
    if ok then
      local candidate = util.get_typescript_server_path(type(root_dir) == "string" and root_dir or vim.uv.cwd())
      if valid_tsdk(candidate) then
        return candidate
      end
    end

    if valid_tsdk(mason_tsdk) then
      return mason_tsdk
    end
  end

  local function ensure_typescript_tsdk(config)
    if type(config) ~= "table" then
      return config
    end

    local init_options = config.init_options
    if type(init_options) ~= "table" or type(init_options.typescript) ~= "table" then
      return config
    end

    if valid_tsdk(init_options.typescript.tsdk) then
      return config
    end

    init_options.typescript.tsdk = resolve_typescript_tsdk(config.root_dir)
    return config
  end

  local function wrap_before_init(config)
    if type(config) ~= "table" or type(config.before_init) ~= "function" or config._noah_tsdk_before_init_wrapped then
      return config
    end

    local before_init = config.before_init
    config.before_init = function(init_params, cfg)
      ensure_typescript_tsdk(cfg)
      return before_init(init_params, cfg)
    end
    config._noah_tsdk_before_init_wrapped = true
    return config
  end

  vim.lsp.start = function(config, opts)
    wrap_before_init(ensure_typescript_tsdk(config))
    return original_lsp_start(config, opts)
  end

  if type(original_lsp_start_client) == "function" then
    vim.lsp.start_client = function(config)
      wrap_before_init(ensure_typescript_tsdk(config))
      return original_lsp_start_client(config)
    end
  end
end

return M
