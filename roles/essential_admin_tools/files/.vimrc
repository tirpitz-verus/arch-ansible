" Set vim-airline style
let g:airline_theme='molokai'

" Indentation & Tabs
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Display & format
set number
set textwidth=80
set wrapmargin=2
set showmatch
syntax on

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Browse & Scroll
set scrolloff=5
set laststatus=2

" Spell
set spelllang=en,pl

" Miscellaneous
set autochdir
set undofile

" enable find menu completition
set wildmenu

" add subfolders and files to path
path+=**

" ignore some known big folders from path
wildignore+=**/node_modules/**
