local S = {}

require("noah.LSP.luasnip.SSOT.javascript").extend(S)
require("noah.LSP.luasnip.SSOT.typescript").extend(S)
require("noah.LSP.luasnip.SSOT.typescriptreact").extend(S)

return S
