local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "c", "bash", "nix", "lua", "php", "python", "rust", "vimdoc" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})
