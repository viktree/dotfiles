" vim: fdm=marker foldlevel=0 foldenable sw=2 ts=2 sts=2
"----------------------------------------------------------------------------------------
" Title:    Neovim configuration
" Author:    Vikram Venkataramanan
" Description:  Should work out of the box on most mac/unix machines
"----------------------------------------------------------------------------------------
"
" general {{{

" encodings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" no more swap files
set noswapfile
set nobackup
set nowritebackup

set cmdheight=2            " Give more space for displaying messages
set noshowcmd         " don't show last command
set wildmode=longest,list  " get bash-like tab completions

set clipboard=unnamedplus  " map nvim clipboard to system clipboard
set ffs=unix,dos,mac       " Unix as standard file type
set updatetime=100         " faster, faster, faster!
set autoread         " automatically reload file when underlying files change
set mouse=a                " sometimes helpful
set secure                 " disallows :autocmd, shell + write commands in local .vimrc
set showmatch              " Show matching brackets

set signcolumn=yes
set shortmess+=c       " don't pass messages to |ins-completion-menu|.

" searching
set nohlsearch         " highlight search results
set gdefault         " by default, swap out all instances in a line

let mapleader = "\<SPACE>"

set number
set relativenumber
augroup line_numbers
  autocmd!
  autocmd InsertEnter       *    set norelativenumber
  autocmd InsertLeave       *    set relativenumber
  autocmd BufEnter,Bufnew *.md set nonumber
  autocmd BufEnter,Bufnew *.md set norelativenumber
  autocmd BufLeave *.md set number
  autocmd BufLeave *.md set relativenumber
  autocmd InsertEnter *.md set nonumber
  autocmd InsertLeave *.md set norelativenumber
augroup END

" Default tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Spelling
set spell
set spelllang=en_us

" }}}
" key mappings {{{
"
" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>
tnoremap jj <C-\><C-n>

" why 3 strokes for command mode?
nnoremap ; :

" Faster shell commands
nnoremap C :!

" Easier moving of code blocks
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" Quick get that register!
nnoremap Q @q
vnoremap Q :normal @q

" Redo with U instead of Ctrl + R
noremap U <C-R>
" }}}
" setup vim-plug {{{
let g:plug_home = '~/.vim/plugged'
" }}}
"
call plug#begin(plug_home)
"
" essentials {{{
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
"}}}
" leader mappings and which-key {{{
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

let g:which_key_map =  {}

autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map.t = { 'name' : '+toggle' }
nnoremap <leader>t<space> :Buffers<cr>

let g:which_key_map['.'] = 'exec-last-cmd'
nnoremap <leader>. :!!<cr>

nnoremap <leader>d :put =strftime('%Y_%b_%d_%a:')<cr>
let g:which_key_map.d = 'insert-date'

nnoremap <leader>ts :set spell!<cr>
let g:which_key_map.t.s = 'spelling'

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<cr>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<cr>

let g:which_key_map.s = { 'name' : '+spelling' }
nnoremap <leader>sg :spellgood!<space>
let g:which_key_map.s.g = 'save-word'
nnoremap <leader>sw :spellwrong!<space>
let g:which_key_map.s.w = 'save-wrong'
" }}}
" navigation + tmux {{{

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>
tnoremap <C-H> <C-W><C-H>

tnoremap <leader>j <down>
tnoremap <leader>k <up>
tnoremap <C-L> clear<cr>

if executable("tmux")
  Plug 'christoomey/vim-tmux-navigator'
  let g:tmux_navigator_no_mappings = 1
  nnoremap <C-H> :TmuxNavigateLeft<cr>
  nnoremap <C-J> :TmuxNavigateDown<cr>
  nnoremap <C-K> :TmuxNavigateUp<cr>
  nnoremap <C-L> :TmuxNavigateRight<cr>
  nnoremap <C-P> :TmuxNavigatePrevious<cr>
endif

" buffers
nnoremap <S-h> :bprevious<cr>
nnoremap <S-l> :bnext<cr>

nnoremap <leader><space> :b#<cr>
let g:which_key_map['SPC'] = 'previous-buffer'

nnoremap <leader>q :bdelete<cr>
let g:which_key_map.q = 'quit buffer'

" cd into current buffer
nnoremap <leader>cd :cd %:p:h<cr>

" }}}
" version control {{{
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify'
Plug 'rhysd/git-messenger.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' }

let g:magit_default_show_all_files = 0
let g:which_key_map.M = 'which_key_ignore'

silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
  let g:magit_enabled=1
  let g:which_key_map.g  = {
    \ 'name' : '+git' ,
    \ 's' : ['MagitOnly',      'status'],
    \ 't' : ['SignifyToggle',  'toggle-signs'],
    \ 'u' : ['UndotreeToggle',  'undo-tree'],
    \ 'i' : ['GitMessenger',  'commit-info'],
    \ }
else
  let g:magit_enabled=0
  let g:which_key_map.g  = {
    \ 'name' : '+versions' ,
    \ 't' : ['SignifyToggle',  'toggle-signs'],
    \ 'u' : ['UndotreeToggle',  'undo-tree'],
    \ }
endif

"}}}
" english {{{
Plug 'reedes/vim-wordy'
Plug 'reedes/vim-litecorrect'
" }}}
" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

let g:fzf_layout = { 'down': '~25%' }
let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
  nmap <leader>p :GitFiles --cached --others --exclude-standard<cr>
else
  nmap <leader>p :FZF .<cr>
endif
let g:which_key_map.p = 'change-file'

nmap <leader>f :BLines<cr>
let g:which_key_map.f = 'snipe-line'
"}}}
" bookmarks {{{

" Shortcuts for frequently accessed files
command! Vimrc e $MYVIMRC
command! PU PlugUpdate | PlugUpgrade
command! Dictonary e $HOME/.vim/spell/en.utf-8.add
command! SSH e $HOME/.ssh/config

if !empty(glob('/Volumes/vikram/planner/app.txt'))
  command! J e /Volumes/vikram/planner/app.txt
endif

if executable('zsh')
  command! Shell e $ZDOTDIR/.zshrc
  command! Env   e $ZDOTDIR/.zshenv
elseif executable('bash')
  command! Shell e $HOME/.bashrc
  command! Env   e $HOME/.profile
endif

function! YadmCommit()
  let curline = getline('.')
  call inputsave()
  let message = input('Enter message: ')
  call inputrestore()
  execute '!yadm commit -m' . "'" . message . "'"
endfunction

if !empty(glob('$XDG_CONFIG_HOME/yadm/bootstrap'))
  command! YadmAdd execute('!yadm add %')
  command! YadmCommit call YadmCommit()
  command! YadmPush execute('!yadm push')

  command! Bootstrap  e $XDG_CONFIG_HOME/yadm/bootstrap
elseif !empty(glob('.yadm/bootstrap'))
  command! YadmAdd execute('!yadm add %')
  command! YadmCommit call YadmCommit()
  command! YadmPush execute('!yadm push')

  command! Bootstrap  e .yadm/bootstrap
endif

"}}}
" file management {{{
if executable("vifm")
  Plug 'vifm/vifm.vim'
  let g:vifm_replace_netrw = 1

  nnoremap <bs> :Vifm<cr>

endif

" }}}
" completions {{{
" Plug 'VundleVim/Vundle.vim'
" Plug 'ycm-core/YouCompleteMe'
" }}}
" filetypes {{{
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'

if executable('shellcheck')
  Plug 'itspriddle/vim-shellcheck'
endif

" formatters {{{
Plug 'ntpeters/vim-better-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'

function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

augroup trim_trailing_whitespace
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END


"""}}}
" {{{ refactoring
Plug 'da-x/name-assign.vim'

let g:name_assign_mode_maps = { "settle" : ["jj"] }

nnoremap <leader>x     *``cgn
nnoremap <leader>X     #``cgN
let g:which_key_map.x = 'change-next-forward'
let g:which_key_map.X = 'change-next-backwards'

augroup vimrc
  autocmd!
  autocmd VimEnter * vmap <leader>r <Plug>NameAssign
  let g:which_key_map.r = 'refactor'
augroup END

nnoremap <leader>/ :%s/
vnoremap <leader>/ :s/
let g:which_key_map['/'] = 'find-&-replace'

" }}}

" bash {{{
Plug 'kovetskiy/vim-bash', { 'for': 'bash' }

augroup filetype_sh
  autocmd!
  autocmd BufNewFile,BufRead *.sh setlocal expandtab
  autocmd BufNewFile,BufRead *.sh setlocal tabstop=4
  autocmd BufNewFile,BufRead *.sh setlocal softtabstop=4
  autocmd BufNewFile,BufRead *.sh setlocal shiftwidth=4
augroup END

" }}}
" c/cpp {{{
Plug 'arakashic/chromatica.nvim', { 'for': ['c', 'cpp']}
Plug 'rhysd/vim-clang-format'

let g:clang_format#detect_style_file = 1

augroup filetype_c_cpp
  autocmd!

  " tabs
  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal expandtab
  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal tabstop=2
  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal softtabstop=2
  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal shiftwidth=2

  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal foldmethod=syntax
  autocmd BufNewFile,BufRead *.cpp,*.c  setlocal foldlevelstart=20

  " format
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd FileType c ClangFormatAutoEnable
  autocmd FileType cpp ClangFormatAutoEnable

augroup END


"}}}
" markdown {{{
Plug 'masukomi/vim-markdown-folding'
Plug 'dhruvasagar/vim-table-mode'
let g:which_key_map.t.m = 'table-mode'

function GetURLTitle(url)
    " Bail early if the url obviously isn't a URL.
    if a:url !~ '^https\?://'
        return ""
    endif

    " Use Python/BeautifulSoup to get link's page title.
    let title = system("python3 -c \"import bs4, requests; print(bs4.BeautifulSoup(requests.get('" . a:url . "').content, 'lxml').title.text.strip())\"")

    " Echo the error if getting title failed.
    if v:shell_error != 0
        echom title
        return ""
    endif

    " Strip trailing newline
    return substitute(title, '\n', '', 'g')
endfunction

function PasteMDLink()
    let url = getreg("+")
    let title = GetURLTitle(url)
    let mdLink = printf("[%s](%s)", title, url)
    execute "normal! a" . mdLink . "\<Esc>"
endfunction

augroup filetype_markdown
  autocmd!
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  autocmd BufNewFile,BufRead *.md setlocal syntax=markdown
  autocmd BufNewFile,BufRead *.md setlocal nonumber
  autocmd BufNewFile,BufRead *.md setlocal nofoldenable
  " autocmd BufNewFile,BufRead *.md setlocal spell

  autocmd BufNewFile,BufRead *.md :TableModeToggle
  autocmd BufLeave *.md           :TableModeToggle

  autocmd Filetype markdown :iabbrev <buffer> h1 #
  autocmd Filetype markdown :iabbrev <buffer> h2 ##
  autocmd Filetype markdown :iabbrev <buffer> h3 ###
  autocmd Filetype markdown :iabbrev <buffer> - <space>-

  autocmd FileType markdown setlocal tabstop=4
  autocmd FileType markdown setlocal shiftwidth=4
  autocmd FileType markdown setlocal softtabstop=4
augroup END

"}}}
" nix {{{
if executable('nix-env')
  Plug 'LnL7/vim-nix', { 'for': 'nix' }
endif
" }}}
" python {{{
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'psf/black', { 'tag': '19.10b0', 'for': 'python' }

let g:black_linelength = 100

augroup filetype_python
  autocmd!

  " indentation
  autocmd BufNewFile,BufRead *.py setlocal expandtab
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4
  autocmd BufNewFile,BufRead *.py setlocal softtabstop=4
  autocmd BufNewFile,BufRead *.py setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.py setlocal autoindent

  " textwidth
  autocmd BufNewFile,BufRead *.py setlocal colorcolumn=81
  autocmd BufNewFile,BufRead *.py setlocal textwidth=79

  " code folding
  autocmd BufNewFile,BufRead *.jmd setlocal nofoldenable

  " format on save
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd BufWritePre *.py execute ':Black'
augroup END

" }}}
" vim {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal colorcolumn=81
  autocmd FileType vim setlocal textwidth=79
  autocmd FileType vim setlocal tabstop=2
  autocmd FileType vim setlocal shiftwidth=2
  autocmd FileType vim setlocal softtabstop=2
augroup END
" }}}

"}}}
" vim-over {{{
Plug 'osyo-manga/vim-over'
Plug 'lambdalisue/reword.vim'

nnoremap <leader>/ :OverCommandLine<cr>%s/
vnoremap <leader>/ :OverCommandLine<cr>s/
" }}}
" theme {{{
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'

set background=dark
let g:rainbow_active = 1
colorscheme gruvbox
" }}}
" lightline {{{

set laststatus=2
Plug 'itchyny/lightline.vim'

function! GitStats()
  let [added, modified, removed] = sy#repo#get_stats()
  let symbols = ['+', '-', '~']
  let stats = [added, removed, modified]  " reorder
  let statline = ''

  for i in range(3)
    if stats[i] > 0
      let statline .= printf('%s%s ', symbols[i], stats[i])
    endif
  endfor

  if !empty(statline)
    let statline = printf('%s', statline[:-2])
  endif

  return statline
endfunction

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'filename', 'gitbranch', 'stats'],
  \             ['readonly', 'modified', ]
  \   ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'stats': 'GitStats',
  \ },
  \ 'mode_map': {
  \   'n' : 'N',
  \   'i' : 'I',
  \   'R' : 'R',
  \   'v' : 'V',
  \   'V' : 'VL',
  \   "\<C-v>": 'VB',
  \   'c' : 'C',
  \   's' : 'S',
  \   'S' : 'SL',
  \   "\<C-s>": 'SB',
  \   't': 'T',
  \ },
  \ }

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

command! LightlineReload call LightlineReload()

augroup reload_vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
  autocmd BufWritePost $MYVIMRC call LightlineReload()
augroup END

augroup reload_bash
  autocmd!
  autocmd BufWritePost .bashrc !source %
  autocmd BufWritePost .profile !source %
  autocmd BufWritePost .bashrc call LightlineReload()
augroup END

"}}}
" transparency! {{{
highlight Folded                       ctermbg=NONE
highlight Normal                       ctermbg=NONE
highlight SignColumn                   ctermbg=NONE

highlight SignifyLineAdd               ctermbg=NONE ctermfg=green
highlight SignifyLineChange            ctermbg=NONE ctermfg=blue
highlight SignifyLineDelete            ctermbg=NONE ctermfg=red
highlight SignifyLineDeleteFirstLine   ctermbg=NONE ctermfg=red
highlight SignifySignAdd               ctermbg=NONE ctermfg=green
highlight SignifySignChange            ctermbg=NONE ctermfg=blue
highlight SignifySignDelete            ctermbg=NONE ctermfg=red
highlight SignifySignDeleteFirstLine   ctermbg=NONE ctermfg=red

highlight BookmarkSign                 ctermbg=NONE ctermfg=blue
highlight BookmarkLine                 ctermbg=NONE ctermfg=blue

highlight clear                        SpellBad
highlight SpellBad                     ctermbg=red ctermfg=black
" }}}
"
call plug#end()
"
"----------------------------------------------------------------------------------------

