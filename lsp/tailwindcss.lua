-- Tailwind CSS language server.
-- Only spawns when the project has a tailwind or postcss config file.
-- Prevents "server not installed" errors on every plain .css buffer.
return {
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.mjs",
    "postcss.config.ts",
  },
}
