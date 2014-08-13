set nocompatible " be iMproved
filetype off " required

filetype plugin indent on " required

set laststatus=2
set mouse=a
set number
set termencoding=utf-8
set encoding=utf-8

syntax enable

set clipboard=unnamed
scriptencoding=utf-8
set virtualedit=onemore
highlight clear LinNr

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers
set showmatch                   " Show matching brackets
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap, too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and under cursor
set foldenable                  " Auto fold code
set list
set t_Co=16

set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level as previous line
set noexpandtab                 " No spaces as tabs
set shiftwidth=4                " Use indents of 4 spaces
set tabstop=4                   " An indentation every 4 columns
set softtabstop=4              " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after prunctuation on a join (J)
set splitright                  " Puts a new window to the right
set splitbelow                  " Puts a new window below
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
