---@type NvPluginSpec
return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
    "Gdiffsplit",
    "Gvdiffsplit",
    "Gread",
    "Gwrite",
    "Gclog",
    "Glog",
    "GBrowse",
  },
  dependencies = {
    "tpope/vim-rhubarb",
    "tpope/vim-obsession",
    "tpope/vim-unimpaired",
    "sindrets/diffview.nvim",
  },
}
