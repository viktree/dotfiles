"                           _
"                 __ __    (_)    _ __      _ _    __
"           _     \ V /    | |   | '  \    | '_|  / _|
"         _(_)_   _\_/_   _|_|_  |_|_|_|  _|_|_   \__|_
"       _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"       `-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'
"
"----------------------------------------------------------------------------------------

" === Set Settings === {{{

set showmatch               " Show matching brackets.
set mouse=a                 " middle-click paste with mouse
set ignorecase              " Do case insensitive matching
set smartcase               " When searching try to be smart about cases
set nohlsearch                " highlight search results
set incsearch               " make search act like search in webrowsers
set tabstop=2               " number of columns occupied by a tab character
set softtabstop=2           " see multiple spaces as tabstops so <BS> does it right 
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set magic                   " For regular expressings
set wildmode=longest,list   " get bash-like tab completions
set cc=90                   " set an 80 column border for good coding style
set clipboard+=unnamedplus  " map nvim clipboard to system clipboard
set ffs=unix,dos,mac        " Unix as standard file type
set invspell                " Spell
set undodir=~/.undodir/     " Save history for undo tree 
set undofile                " Save history for undo tree

" }}}

" === Filetype Specific === {{{

" This should be moved into seperate files for each filetype.
augroup configFold
    " fold vimrc itself by categories
    autocmd!
    autocmd filetype vim setlocal foldmethod=marker
    autocmd filetype vim setlocal foldlevel=0
augroup end

" detect .md as markdown instead of modula-2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" }}}

" === Line Numbers === {{{

" Line Numbers: different numbering for different modes
set rnu
  au InsertEnter * :set nu nornu
  au InsertLeave * :set rnu nonu
  au FocusGained * :set rnu nonu
  au FocusLost * :set nu nornu

" }}}

" === Leader === {{{

" Map the leader key to SPACE
let mapleader="\<SPACE>"

" clear highlighted search
noremap  <leader>h :set hlsearch! hlsearch?<CR>
noremap  <leader>gt :Magit <CR>
noremap  <leader>b :BookmarkToggle <CR>
noremap  <leader>ss :BookmarkShow <CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>gu :UndotreeToggle<CR><Paste>

map <leader>s :setlocal spell!<cr>


" }}}

" === Navigation === {{{

"Tab between files
noremap <Tab> :<C-U>tabnext<CR>
noremap <S-Tab> :<C-U>tabprevious<CR>

" Swap modes easily
nnoremap ; :
vnoremap ; :

" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>
tnoremap jj <C-\><C-n>

" Navigate between display lines
noremap  <silent> k gk
noremap  <silent> j gj

" Remap Arrow Keys to move lines up and down.
nnoremap <UP> ddkP
vnoremap <UP> xkP`[V`]
nnoremap <DOWN> ddp
vnoremap <DOWN> xp`[V`]

" Easier moving of code blocks
" Try to go into visual mode (v),
" " then select lines of code here and press ``>``.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

"Easily Switch between tabs.
map <c-k> <c-w>k<CR>
map <c-j> <c-w>j<CR>
map <c-l> <c-w>l<CR>
map <c-h> <c-w>h<CR>


" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

"}}}

" === Colour Scheme === {{{

" set background=dark
colorscheme gruvbox
" let g:enable_bold_font = 1

"}}}

" === Plugins === {{{
call plug#begin('~/.config/nvim/plugged')

" Start Page
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'

" Indentation of varios sorts
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'

Plug 'terryma/vim-multiple-cursors'

" CtrlP
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Snippets and completion
Plug 'jiangmiao/auto-pairs'
" Plug 'Shougo/neocomplcache'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }


" Airline:Pluggable themes
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = "gruvbox"

" Commentary:makes commenting easy
Plug 'tpope/vim-commentary'
nmap cm <Plug>Commentary

" Editorconfig: Consistancy across IDEs
Plug 'editorconfig/editorconfig-vim'

" Open a file to a specific line
Plug 'bogado/file-line'

" Fuzzyfinder
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Jedi: Python stuff
" Plug 'davidhalter/jedi-vim'

" Polyglot: Language Support
Plug 'sheerun/vim-polyglot'

" Tagbar: for quick navigation between tags
Plug 'majutsushi/tagbar'

" Undotree:Graph of all edits to easily undo mistakes
Plug 'mbbill/undotree'

"Deoplete: Code completion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

"SuperTab
Plug 'ervandew/supertab'

"Bookmarks: jump to places in code
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_auto_close = 1

"Surrond: Change braces on the fly
Plug 'tpope/vim-surround'

"Vim man pages
Plug 'jez/vim-superman'

"GitIgnore: gitingnore
Plug 'vim-scripts/gitignore'

Plug 'neomake/neomake'
let g:neomake_open_list = 2
let g:neomake_haskell_enabled_makers = []

call plug#end()

" }}}

" === Airline === {{{

let g:airline#extensions#hunks#enabled = 1

" }}}

autocmd filetype crontab setlocal nobackup nowritebackup
