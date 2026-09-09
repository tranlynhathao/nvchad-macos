---@type NvPluginSpec
return {
  "windwp/nvim-ts-autotag",
  -- ft-only so the plugin (~110ms) is skipped on Lua/Rust/Go/etc. buffers.
  -- BufReadPre would fire for every file open and defeat that.
  ft = {
    "html",
    "xml",
    "vue",
    "svelte",
    "astro",
    "markdown",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
  },
  config = function() require("nvim-ts-autotag").setup() end,
}
