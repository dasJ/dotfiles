-- Editing
vim.wo.number = true
vim.wo.cursorline = true -- Highlight current line
vim.o.virtualedit = "onemore" -- Allow the cursor to go past the end of the line
vim.o.whichwrap = "b,s,h,l,<,>,[,]" -- Backspace wraps, too
vim.o.list = true
vim.o.listchars = "tab:>-,eol:¶,trail:~,multispace:·,lead: "
vim.o.scrolloff = 5
vim.o.showmatch = true
vim.o.autoindent = true -- Indent as previous line
vim.o.smarttab = true
vim.o.backspace = "indent,eol,start"
-- Sane defaults
vim.o.expandtab = false
vim.o.tabstop = 4 -- Indentation every 4 columns
vim.o.shiftwidth = 4 -- Indent with 4 spaces
vim.o.softtabstop = -1 -- Let backspace delete indentation

-- Search
vim.o.hlsearch = true -- Highlight search terms
vim.o.ignorecase = true -- Ignore case by default but...
vim.o.smartcase = true -- ...not when searching an uppercase letter
vim.o.incsearch = true -- Search as you type
vim.o.inccommand = "split" -- Show preview pane on subsitution

-- History
vim.o.history = 1000
vim.bo.undofile = true
vim.o.undolevels = 1000000
vim.o.undoreload = 1000000
vim.o.backupskip = "/tmp/*"
vim.o.updatetime = 400

-- Completion
vim.o.completeopt = "menuone,preview,noinsert,noselect"

-- Fix relative paths in onmnicomplete
local omnigroup = vim.api.nvim_create_augroup("OmniFile", {})
vim.api.nvim_clear_autocmds({ group = "OmniFile", buffer = bufnr })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = omnigroup,
  callback = function()
      vim.g.omnicwd = vim.fn.getcwd()
      vim.o.autochdir = true
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = omnigroup,
  callback = function()
      vim.o.autochdir = false
      vim.fn.execute("cd " .. vim.fn.fnameescape(vim.g.omnicwd))
  end,
})

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Status bar
vim.o.laststatus = 2 -- Always display status bar
vim.o.showcmd = true
vim.o.showmode = true
vim.o.ruler = true -- Show current position
vim.o.wildmode = "list:longest,full"

-- Path things
vim.o.path = ".,/,,@HOME@/projects/nixpkgs/lib,@HOME@/projects/nixpkgs/pkgs/top-level"
vim.opt.runtimepath:append("/run/current-system/sw/share/vim-plugins")

-- Terminal
vim.o.title = true
vim.o.encoding = "utf-8"

-- Netrw
vim.g.netrw_mousemaps = 0
vim.g.netrw_banner = false
vim.g.netrw_liststyle = 3 -- Tree

-- Keymaps
vim.g.mapleader = ","
vim.g.maplocalleader = ","
