local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "c", "bash", "nix", "lua", "php", "python", "rust", "vimdoc", "comment" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true }
})

vim.api.nvim_set_hl(0, "@comment.todo", { link = "@text.todo" })
vim.api.nvim_set_hl(0, "@text.note", { link = "Ignore" })
vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
