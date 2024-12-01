local S = {}

require("gale.LSP.luasnip.SSOT.javascript").extend(S)
require("gale.LSP.luasnip.SSOT.typescript").extend(S)
require("gale.LSP.luasnip.SSOT.typescriptreact").extend(S)

return S
