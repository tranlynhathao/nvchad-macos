-- Pyright: Python type checker + navigation + completion.
-- Formatting is disabled via the LspAttach hook (conform + ruff_format handle it).

local function resolve_project_python(root)
  if not root or root == "" then return nil end
  local venv_python = root .. "/.venv/bin/python"
  if vim.fn.executable(venv_python) == 1 then return venv_python, root, ".venv" end
  local env_venv = vim.env.VIRTUAL_ENV
  if env_venv and env_venv ~= "" then
    local p = env_venv .. "/bin/python"
    if vim.fn.executable(p) == 1 then return p, vim.fs.dirname(env_venv), vim.fs.basename(env_venv) end
  end
  return nil
end

return {
  filetypes = { "python" },
  before_init = function(_, config)
    local root = config.root_dir
    local py, venv_dir, venv_name = resolve_project_python(root)
    if not py then return end
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      python = {
        pythonPath = py,
        venvPath = venv_dir,
        venv = venv_name,
      },
    })
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
      },
    },
    pyright = {
      -- Ruff handles import sorting via `source.organizeImports`; do not
      -- offer a competing provider from pyright.
      disableOrganizeImports = true,
    },
  },
}
