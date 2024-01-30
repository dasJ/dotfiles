local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "c", "bash", "nix", "lua", "php", "rust" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})
