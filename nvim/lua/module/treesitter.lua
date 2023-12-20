local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "c", "bash", "nix", "lua" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})
