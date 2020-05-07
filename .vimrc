
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
set cc=90                   " set an 90 column border for good coding style
set clipboard+=unnamedplus  " map nvim clipboard to system clipboard
set ffs=unix,dos,mac        " Unix as standard file type
set invspell                " Spell

" Line numbers
set rnu
  au InsertEnter * :set nu nornu
  au InsertLeave * :set rnu nonu
  au FocusGained * :set rnu nonu
  au FocusLost * :set nu nornu

" Swap modes easily
nnoremap ; :
vnoremap ; :

" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>

" Remap Arrow Keys to move lines up and down.
nnoremap <UP> ddkP
vnoremap <UP> xkP`[V`]
nnoremap <DOWN> ddp
vnoremap <DOWN> xp`[V`]
set noswapfile
