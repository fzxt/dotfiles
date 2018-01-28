""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ENABLE PLUGINS VIA PATHOGEN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Command T for fast fuzzy file finding
Plug 'wincent/command-t'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'airblade/vim-gitgutter'

" Typescript
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'

" C++
Plug 'zchee/deoplete-clang'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'machakann/vim-sandwich'
Plug 'Valloric/YouCompleteMe'
call plug#end()

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:ale_linters = ['eslint']

" See @https://github.com/Shougo/deoplete.nvim/issues/460
" ctrl+c completely fucks up deoplete
inoremap <C-c>  <Esc>

set winwidth=84

" Settings below are needed for tmux
set t_8f=[38;2;%lu;%lu;%lum 
set t_8b=[48;2;%lu;%lu;%lum

set wildmenu
set wildmode=longest,list
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=**/node_modules
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript typescript setlocal omnifunc=tern#Complete
endif

"" NerdTREE shortcut
map <silent> <C-\> :NERDTreeToggle<CR>

"autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

set number
nnoremap tn :tabnew<Space>

nnoremap tN :tabnext<CR>
nnoremap tp :tabprev<CR>

nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>

syntax on
set expandtab
filetype plugin indent on
set termguicolors
set tabstop=2 softtabstop=0 expandtab shiftwidth=4 smarttab

set smarttab
set incsearch
set backspace=indent,eol,start
set hlsearch
set smartindent
set magic
set title
set bs=indent,eol,start
set wildmenu
set ruler
set showmatch
set smartcase
set nobackup
set mouse=v

let mapleader=","

if $TMUX == ''
    set clipboard+=unnamed
endif

set clipboard=unnamedplus

set background=dark
colorscheme gooey
set nowrap

set nobackup
set nowritebackup
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PERSISTENT UNDO 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off
  
  " *.md is markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=

  " indent slim two spaces, not four
  autocmd! FileType *.slim set sw=2 sts=2 et
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND T IGNORE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTWildIgnore=&wildignore . ",*/bower_components,*/node_modules"
