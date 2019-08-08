" moving to an offset can be done using <number>+j/k j to move down k to move up 
set number relativenumber

" enable spell checking typos are underlined
" use z= for suggestions zg to add the word to a dictionary or zw to remove a word from the dictionary
set spell

set nocompatible                                                                    " stop pretending to be vi

filetype off                  " required
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" Plugin 'VundleVim/Vundle.vim'
" Plugin 'ycm-core/YouCompleteMe'
" call vundle#end()            " required
" filetype plugin indent on    " required


" call plug#begin('~/.vim/plugged')
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'PotatoesMaster/i3-vim-syntax'
" call plug#end()


set background=dark
" colorscheme palenight                                                                " awesome color scheme
colorscheme badwolf

syntax enable                                                                       " enable syntax highlighting used for 

                                                                                    " TODO Fix background not being draw when there isn't a line present
" highlight Normal ctermbg=None ctermfg=white                                         " disable theme background color
" highlight LineNr ctermbg=None ctermfg=white                                         " reset the line number background

" tread tabs as 4 spaces and tell the editor how to draw tabs
set tabstop=4
set softtabstop=4
set expandtab

set showcmd                                                                         " show last command in bottom right corner

set cursorline                                                                      " highlight current line

filetype indent on                                                                  " load file type specific indent files
filetype plugin on

set wildmenu                                                                        " visual autocomplete for command menu

set lazyredraw                                                                      " redraw only when we need to. For instance don't redraw when performing a macro

set showmatch                                                                       " highlight matching bracket

set incsearch                                                                       " search as characters are entered
set hlsearch                                                                        " highlight matches

" use :find filename to open a file (globing is allowed)
set path+=**                                                                        " enable recursive file search in subdirs
set  wildignore+=**/node_modules/**                                                 " ignore node modules when searching through path

" example macro it binds ,f to select a string encased in "" and removes its content
nnoremap ,f /"<cr>v/"<cr>xi ""<esc>i
vnoremap <C-c> "*y : let @+=@*<CR>
map <C-v> "+P

