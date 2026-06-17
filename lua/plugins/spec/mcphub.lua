-- Read a secret from the macOS Keychain. Returns nil if missing, so we never
-- crash mcphub setup when the entry isn't there yet — just surface a hint.
-- Store with:  security add-generic-password -s <service> -a "$USER" -w
local function keychain(service, opts)
  local user = os.getenv "USER" or ""
  local out = vim.fn.system { "security", "find-generic-password", "-s", service, "-a", user, "-w" }
  if vim.v.shell_error ~= 0 then
    if not (opts and opts.silent) then
      vim.schedule(function()
        vim.notify(
          ("mcphub: Keychain entry '%s' not found. Store it with: security add-generic-password -s %s -a $USER -w"):format(service, service),
          vim.log.levels.WARN
        )
      end)
    end
    return nil
  end
  return vim.trim(out)
end

---@type NvPluginSpec
return {
  "ravitemer/mcphub.nvim",
  -- VeryLazy (not cmd=) so the mcp-hub binary starts shortly after Neovim
  -- opens, exposing http://localhost:37373/mcp for external clients
  -- (Claude Code, Codex) without having to run `:MCPHub` first.
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- Installs the `mcp-hub` Node binary globally; re-runs on plugin update.
  build = "npm install -g mcp-hub@latest",
  opts = function()
    return {
      config = vim.fn.expand "~/.config/mcphub/servers.json",
      -- Safety: never auto-run tools without a prompt; flip to true once you trust
      -- a given server set.
      auto_approve = false,
      -- Let LLMs start/stop registered MCP servers on demand instead of keeping
      -- them all running.
      auto_toggle_mcp_servers = true,
      -- Keep the mcp-hub binary alive 10 min after the last Neovim instance
      -- exits, so a terminal `claude` / `codex` session that outlives nvim can
      -- still reach the hub.
      shutdown_delay = 10 * 60 * 1000,
      -- Env vars exposed to every MCP server mcp-hub spawns. `${VAR}` references
      -- in ~/.config/mcphub/servers.json resolve from here.
      global_env = {
        GITHUB_PERSONAL_ACCESS_TOKEN = keychain "github-pat",
      },
      ui = {
        window = {
          border = "rounded",
          width = 0.85,
          height = 0.85,
          relative = "editor",
        },
      },
      log = {
        level = vim.log.levels.WARN,
        to_file = false,
      },
    }
  end,
}
