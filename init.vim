set nocompatible

" NOTE: I have symlinked this file to init.vim `ln -s ~/.vimrc init.vim`
if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim/plugged')
endif
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'maralla/completor.vim'
Plug 'w0rp/ale'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tasn/vim-tsx'
Plug 'rakr/vim-one'
call plug#end()

" COC Autocomplete
set updatetime=300

" Tab autocomplete
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Linting and Code formatting
filetype plugin indent on

let g:ale_linters_explicit=1

let g:ale_linters = {
\   'bash': ['shellcheck'],
\   'c': ['clang'],
\   'go': ['go vet'],
\   'javascript': ['eslint'],
\   'javascript.jsx': ['eslint'],
\   'python': ['pyflakes'], 
\   'sh': ['shellcheck'],
\   'zsh': ['shellcheck'],
\}

let g:ale_fixers = {
\   'c': ['clang-format'],
\   'css': ['prettier'],
\   'go': ['goimports'],
\   'html': ['prettier'],
\   'javascript': ['prettier'],
\   'javascript.jsx': ['prettier'],
\   'json': ['prettier'],
\   'python': ['pyflakes'], 
\}


let g:ale_fix_on_save=1
let g:ale_fix_on_enter=1
let g:ale_lint_on_save=1
let g:ale_lint_on_enter=1

let g:ale_c_clangformat_options='--style=file'

let g:ale_go_gofmt_options='-s'

let g:ale_sign_column_always=1


set tabstop=4
set shiftwidth=4
set smartindent
set expandtab
set number 
set mouse=a
syntax on

set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set undodir=~/.vim/tmp
set swapfile    " keep a swap file
set backup    " keep a backup file (restore to previous version)
set undofile  " keep an undo file (undo changes after closing)
set history=50  " keep 50 lines of command line history
set ruler

" ONLY WRITES TO DISK IF CHANGES SINCE LAST WRITE
cnoreabbrev w update

" go to the position i was last at 
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
set backspace=indent,eol,start " allow backspace over everything in insertion mode 
" Unix style line endings
set ff=unix
set showcmd		" display incomplete
set incsearch	" do incremental searching
vnoremap * "*y

" Detect filetype then load plugin file, set syntax highlighting,
" and set indentation accordingly
filetype plugin indent on
if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

inoremap jk <Esc>
inoremap Jk <Esc>
inoremap <Esc> <nop>

" Don't autoselect an item from the completion menu, and always show the menu
let g:completor_complete_options='menuone,noinsert'

" No delay on showing the completion pop-up
let g:completor_completion_delay=0
set t_ut=



