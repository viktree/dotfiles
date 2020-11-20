" vim: fdm=marker foldlevel=0 foldenable sw=2 ts=2 sts=2
"----------------------------------------------------------------------------------------
"
" general {{{
" Always support UTF-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" I'll handle backups myself, thank you
set noswapfile
set nobackup
set nowritebackup

" More modern view
set cmdheight=2            " give more space for displaying messages
set noshowcmd              " don't show last command
set wildmode=longest,list  " get bash-like tab completions
set shortmess+=c           " don't pass messages to |ins-completion-menu|.

" searching
set nohlsearch	           " highlight search results
set inccommand=nosplit     " THIS IS AMAZING! :O
set gdefault               " by default, swap out all instances in a line
" }}}
" setup vim-plug {{{
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let g:plug_home = stdpath('data') . '/plugged'

if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path
" }}}
call plug#begin(plug_home)
"
" clipboards {{{
set clipboard+=unnamedplus " map nvim clipboard to system clipboard

" Sync with system clipboard files
if has('macunix') && executable("pbcopy")
  vmap <C-x> :!pbcopy<cr>
  vmap <C-c> :w !pbcopy<cr><cr>
endif
" }}}
" text objects {{{
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" }}}
" keybindings {{{

" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>

" Easier moving of code blocks
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" Quick get that register!
nnoremap Q @q
vnoremap Q :normal @q

" Redo with U instead of Ctrl+R
noremap U <C-R>

" Navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" }}}
" leader mappings {{{
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
let g:which_key_map =  {}

" Space is the leader key
let mapleader = "\<SPACE>"
autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<cr>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<cr>

let g:which_key_map = {
		\ 't' : {
			\ 'name' : '+toggle' ,
			\	's' : ['set !spell', 'spelling'],
			\ },
		\ 'm' : {
			\ 'name' : 'Git Status' 
			\ },
		\ 'M' : {
			\ 'name' : 'Magit'
			\ },
		\ }

let g:which_key_map.M = 'which_key_ignore'

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" }}}
" version control {{{
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify'
let g:magit_default_fold_level = 0
" }}}
" bookmarks {{{
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_auto_close = 1
let g:bookmark_sign = '##'
let g:bookmark_annotation_sign = '##'

let g:which_key_map.b = {
    \ 'name' : '+bookmarks' ,
    \ 't' : ['BookmarkToggle',   'toggle-bookmark'],
    \ 'a' : ['BookmarkAnnotate', 'rename-bookmark'],
    \ 'b' : ['BookmarkShowAll',  'open-bookmark'],
    \ }

nnoremap <leader>tb :BookmarkToggle<cr>
let g:which_key_map.t.b = 'bookmark'

" Shortcuts for frequently accessed files
command! Vimrc e $MYVIMRC
command! PU PlugUpdate | PlugUpgrade

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

if executable('brew')
	command! Brew  e $HOMEBREW_BUNDLE_FILE
endif

if !empty(glob('$XDG_CONFIG_HOME/yadm/bootstrap'))
	command! Yadm  e $XDG_CONFIG_HOME/yadm/bootstrap
elseif !empty(glob('.yadm/bootstrap'))
	command! Yadm  e .yadm/bootstrap
endif

"}}}
"
" ale {{{
" }}}
" coc {{{

if executable("python") && executable("yarn")
	Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
endif

let g:coc_global_extensions = [
	\ 'coc-css',
	\ 'coc-clangd',
	\ 'coc-eslint',
	\ 'coc-html',
	\ 'coc-json',
	\ 'coc-rls',
	\ 'coc-sh',
	\ 'coc-snippets',
	\ 'coc-stylelint',
	\ 'coc-tslint',
	\ 'coc-tsserver',
	\ 'coc-vimlsp',
	\ 'coc-vimtex',
	\ 'coc-yaml',
	\ ]

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

imap <C-e> <Plug>(coc-snippets-expand)
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:which_key_map.c  = { 'name' : '+coc' }
nmap <leader>cp <Plug>(coc-diagnostic-prev)
let g:which_key_map.c.p = 'jump-out'
nmap <leader>cn <Plug>(coc-diagnostic-next)
let g:which_key_map.c.n  = 'jump-in'
nmap <leader>cd <Plug>(coc-definition)
let g:which_key_map.c.d  = 'definition'
nmap <leader>cy <Plug>(coc-type-definition)
let g:which_key_map.c.y  = 'type-definition'
nmap <leader>ci <Plug>(coc-implementation)
let g:which_key_map.c.i  = 'implementation'
nmap <leader>cr <Plug>(coc-references)
let g:which_key_map.c.r  = 'references'
nmap <leader>cf  <Plug>(coc-fix-current)
let g:which_key_map.c.f  = 'fix'

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" }}}
" editor-config {{{
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" }}}
" fzf {{{
if executable("fzf")
  Plug '/usr/local/opt/fzf'
else
	let fzf_program_path = stdpath('data') . '/fzf'
  Plug 'junegunn/fzf', { 'dir': fzf_program_path, 'do': './install --bin' }
endif
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
" file management {{{
if executable("vifm")
  Plug 'vifm/vifm.vim'
  let g:vifm_replace_netrw = 1
  nnoremap <bs> :Vifm<cr>
endif

" }}}
" rainbow parens {{{
Plug 'luochen1990/rainbow'
let g:rainbow_active   = 1
"}}}
"
call plug#end()
"
" transparency! {{{
highlight Folded                       ctermbg=NONE
highlight Normal                       ctermbg=NONE
highlight SignColumn                   ctermbg=NONE
highlight WhichKeyFloating						 ctermbg=NONE

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
" }}}
"----------------------------------------------------------------------------------------


