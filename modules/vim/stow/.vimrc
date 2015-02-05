" Settings
set nocompatible
set backspace=indent,eol,start
set ruler
set hidden

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set hlsearch
set ignorecase
set smartcase

set showmatch
set matchtime=5

set novisualbell
set noerrorbells

set nowrap
set list
set listchars=tab:\ \ ,trail:.,extends:#,nbsp:.

" Plugins
filetype plugin indent on
syntax on

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
Bundle 'gmarik/vundle'

" Github Bundles
Bundle 'tpope/vim-fugitive'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'kien/ctrlp.vim'

" Vimscript Bundles
Bundle 'Markdown'

" Plugin options
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'

" Because I keep forgetting sudo
cmap w!! %!sudo tee > /dev/null %
