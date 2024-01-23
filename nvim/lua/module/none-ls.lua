local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.statix,
    null_ls.builtins.diagnostics.statix,
    null_ls.builtins.diagnostics.deadnix,
  }
})
