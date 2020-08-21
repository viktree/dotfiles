" vim: fdm=marker foldlevel=0 foldenable sw=2 ts=2 sts=2
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
set noshowcmd							 " don't show last command
set wildmode=longest,list  " get bash-like tab completions

set clipboard+=unnamedplus " map nvim clipboard to system clipboard
set ffs=unix,dos,mac       " Unix as standard file type
set updatetime=100         " faster, faster, faster!
set autoread							 " automatically reload file when underlying files change
set mouse=a                " sometimes helpful
set secure                 " disallows :autocmd, shell + write commands in local .vimrc
set showmatch              " Show matching brackets
set hidden

set shortmess+=c		   " don't pass messages to |ins-completion-menu|.

" searching
set nohlsearch			   " highlight search results
set inccommand=nosplit	   " THIS IS AMAZING! :O
set gdefault			   " by default, swap out all instances in a line

" Default tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4

let mapleader = "\<SPACE>"
let g:maplocalleader = ','

" Sync with system clipboard files
if has('macunix')
	vmap <C-x> :!pbcopy<cr>
	vmap <C-c> :w !pbcopy<cr><cr>
endif

set number
set relativenumber
augroup line_numbers
  autocmd!
  autocmd TermOpen    * setlocal listchars= nonumber norelativenumber
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
	autocmd BufNewFile,BufRead,InsertLeave *.md setlocal nonumber
	autocmd BufNewFile,BufRead,InsertLeave *.md setlocal norelativenumber
augroup END

augroup remember_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Spelling
set spell
set spelllang=en_us

" }}}
" key mappings {{{
"
" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>

" why 3 strokes for command mode?
nnoremap ; :

" Easier moving of code blocks
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" Quick get that register!
nnoremap Q @q
vnoremap Q :normal @q

" Redo with U instead of Ctrl+R
noremap U <C-R>
" }}}
"
let g:plug_home = stdpath('data') . '/plugged'
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

nnoremap <leader>ts :set spell!<cr>
let g:which_key_map.t.s = 'spelling'

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<cr>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<cr>

nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

map <leader>tt :belowright split<cr>:resize 10<cr>:terminal<cr>i
let g:which_key_map.t.t = 'terminal'

if has('macunix')
	nnoremap <leader>d :!open ..<cr>
	let g:which_key_map.d = 'open-directory'
endif

" }}}
" navigation {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" buffers
nnoremap <S-h> :bprevious<cr>
nnoremap <S-l> :bnext<cr>

nnoremap <leader><space> :b#<cr>
let g:which_key_map['SPC'] = 'previous-buffer'

nnoremap <leader>q :bdelete<cr>
let g:which_key_map.q = 'quit buffer'

" }}}
" version control {{{
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify'
Plug 'rhysd/git-messenger.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' }

let g:magit_default_show_all_files = 0
let g:which_key_map.M = 'which_key_ignore'

if isdirectory(".git")
	let g:magit_enabled=1
	let g:which_key_map.g  = {
		\ 'name' : '+git' ,
		\ 's' : ['MagitOnly',      'status'],
		\ 't' : ['SignifyToggle',  'toggle-signs'],
		\ 'u' : ['UndotreeToggle', 'undo-tree'],
		\ 'i' : ['GitMessenger',   'commit-info'],
		\ }
else
	let g:magit_enabled=0
	let g:which_key_map.g  = {
		\ 'name' : '+versions' ,
		\ 't' : ['SignifyToggle',  'toggle-signs'],
		\ 'u' : ['UndotreeToggle',  'undo-tree'],
		\ }
endif

nnoremap <leader>tu :UndotreeToggle<cr>
let g:which_key_map.t.u = 'undotree'

"}}}
" fzf {{{
let fzf_program_path = stdpath('data') . '/fzf'

Plug 'junegunn/fzf', { 'dir': fzf_program_path, 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

let g:fzf_layout = { 'down': '~25%' }
let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

if isdirectory(".git")
  nmap <leader>p :GitFiles --cached --others --exclude-standard<cr>
else
  nmap <leader>p :FZF .<cr>
endif
let g:which_key_map.p = 'change-file'

nmap <leader>f :BLines<cr>
let g:which_key_map.f = 'snipe-line'
"}}}
" commands {{{

" Shortcuts for frequently accessed files
command! Vimrc e $MYVIMRC
command! InsertDate put =strftime('%Y_%b_%d_%a:')
command! PU PlugUpdate | PlugUpgrade

if executable('zsh')
	command! Shell e $ZDOTDIR/.zshrc
	command! Env   e $ZDOTDIR/.zshenv
elseif executable('bash')
	command! Shell e $HOME/.bashrc
	command! Env   e $HOME/.profile
endif

if executable('brew')
	command! Brew  e $HOMEBREW_BUNDLE_FILE
endif

if executable('skhd')
	command! Keys  e $XDG_CONFIG_HOME/skhd/skhdrc
endif

if executable('yadm')
	function! YadmCommit()
		let curline = getline('.')
		call inputsave()
		let message = input('Enter message: ')
		call inputrestore()
		execute '!yadm commit -m' . "'" . message . "'"
	endfunction

	command! YadmAdd execute('!yadm add %')
	command! YadmCommit call YadmCommit()
	command! YadmPush execute('!yadm push')

	if !empty(glob('$XDG_CONFIG_HOME/yadm/bootstrap'))
		command! Bootstrap  e $XDG_CONFIG_HOME/yadm/bootstrap
	elseif !empty(glob('.yadm/bootstrap'))
		command! Bootstrap  e .yadm/bootstrap
	endif
endif

if executable('yabai')
	command! Wm  e $XDG_CONFIG_HOME/yabai/yabairc
endif

if executable('alacritty')
	command! Term e $XDG_CONFIG_HOME/alacritty/alacritty.yml
endif

" }}}
" file management {{{
if executable("vifm")
  Plug 'vifm/vifm.vim'
  let g:vifm_replace_netrw = 1
  nnoremap <bs> :Vifm<cr>
endif
" }}}
" filetypes {{{
" }}}
" english better {{{
Plug 'reedes/vim-lexical'          " better spellcheck mappings
Plug 'reedes/vim-litecorrect'      " better autocorrections
Plug 'reedes/vim-textobj-sentence' " treat sentences as text objects
Plug 'reedes/vim-wordy'            " weasel words and passive voice
Plug 'Ron89/thesaurus_query.vim'   " use better words
Plug 'sedm0784/vim-you-autocorrect'
"}}}
" colour scheme {{{
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
Plug 'mhinz/vim-startify'

let g:gruvbox_termcolors=16
let g:rainbow_active   = 1
let g:startify_use_env = 1

function FixColours()
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
endfunction

autocmd vimenter * colorscheme gruvbox
autocmd vimenter * call FixColours()
autocmd User Startified setlocal cursorline

"}}}
" light line {{{
Plug 'itchyny/lightline.vim'

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! CurrFunction()
	return get(b:, 'coc_current_function', '')
endfunction

function! StatusDiagnostic() abort
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return '' | endif
	let msgs = []
	if get(info, 'error', 0)
		call add(msgs, 'E' . info['error'])
	endif
	if get(info, 'warning', 0)
		call add(msgs, 'W' . info['warning'])
	endif
	return join(msgs, ' ')
endfunction

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
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'filename', 'gitbranch', 'stats', 'currentfunction'],
	\             ['readonly', 'modified', 'lint' ]
	\   ]
	\ },
	\ 'component_function': {
	\   'currentfunction': 'CurrFunction',
	\   'gitbranch': 'FugitiveHead',
	\   'stats': 'GitStats',
	\   'lint': 'StatusDiagnostic'
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
	\ }
	\ }

autocmd vimenter,BufWritePost $MYVIMRC call LightlineReload()
"}}}
" On save hooks {{{

augroup reload_vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
  autocmd BufWritePost $MYVIMRC call LightlineReload()
augroup END

augroup reload_shell
  autocmd!
  if executable('bash')
		autocmd BufWritePost .bashrc,.profile !source %
	endif
	if executable('zsh')
		autocmd BufWritePost .zshenv,.zshrc !source %
	endif  
	autocmd BufWritePost $MYVIMRC call LightlineReload()
augroup END

"}}}
"
call plug#end()
"
"
"----------------------------------------------------------------------------------------
