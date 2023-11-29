local lspconfig = require('lspconfig')

for _, server in ipairs {
  {
    "bashls",
    settings = {
      ['bashIde'] = {
        shellcheckArguments = "-o add-default-case,avoid-nullary-conditions,check-set-e-suppressed,deprecate-which,quote-safe-variables,require-double-brackets,require-variable-braces -S style"
      },
    },
  },
  {
    "nil_ls",
  },
  {
    "perlpls",
  },
  {
    "rust_analyzer",
    cmd = { "rust-analyzer" },
  },
} do
  lspconfig[server[1]].setup {
    cmd = server.cmd,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = server.settings,
  }
end
