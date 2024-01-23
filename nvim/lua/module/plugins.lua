local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "lewis6991/fileline.nvim",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require "module.lsp"
    end,
  },
  -- Syntaxes
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "module.treesitter"
    end,
    lazy = false,
  },
  {
    "nvim-treesitter/playground",
    config = function()
      require "nvim-treesitter.configs".setup {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      }
    end,
    cmd = "TSPlaygroundToggle",
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = "rust",
  },
  {
    "vim-scripts/exim.vim",
    ft = "exim",
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    ft = "nix",
    config = function()
      require "module.none-ls"
    end,
  },
  -- Look and feel
  {
    "tomasr/molokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.molokai_original = 1
      vim.cmd([[colorscheme molokai]])
    end,
  },
  {
    "vim-airline/vim-airline",
    lazy = false,
    config = function()
      vim.g["airline#extensions#tabline#enabled"] = true
    end,
  },
}, {
  defaults = {
    lazy = true,
  },
  checker = {
    enabled = true,
    notify = false,
    frequency = 36000,
  },
})
