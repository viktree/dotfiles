" vim: fdm=marker foldlevel=0 foldenable sw=4 ts=4 sts=4
"----------------------------------------------------------------------------------------
" Title:		Neovim configuration
" Author:		Vikram Venkataramanan
"----------------------------------------------------------------------------------------
"
" general {{{

set encoding=utf-8         " encodeings
set fileencoding=utf-8
set fileencodings=utf-8
set clipboard+=unnamedplus " map nvim clipboard to system clipboard
set cmdheight=2            " Give more space for displaying messages
set exrc                   " exrc allows loading local executing local rc files
set ffs=unix,dos,mac       " Unix as standard file type
set mouse=a                " sometimes helpful
set noshowcmd			   " don't show last command
set noswapfile             " no more swapfiles
set secure                 " disallows :autocmd, shell + write commands in local .vimrc
set showmatch              " Show matching brackets
set updatetime=100         " faster, faster, faster!
set wildmode=longest,list  " get bash-like tab completions
set gdefault			   " by default, swap out all instances in a line
set autoread			   " automatically reload file when underlying files change

" Automatically reload .vimrc file on save
augroup reload_vimrc
  au!
  au BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
augroup END

" searching
set nohlsearch			   " highlight search results
set inccommand=nosplit	   " THIS IS AMAZING! :O

let mapleader = "\<SPACE>"

" Sync with system clipboard files
if has('macunix')
	vmap <C-x> :!pbcopy<cr>
	vmap <C-c> :w !pbcopy<cr><cr>
endif

" line numbers
set number
autocmd TermOpen * setlocal listchars= nonumber norelativenumber

" }}}
" key mappings {{{
" Quickly exit insert mode
ino jj <esc>
cno jj <c-c>

" Easier moving of code blocks
" try to go into visual mode (v), then select lines of code here and press `>`
vnoremap < <gv
vnoremap > >gv

" Quick get that register!
nnoremap Q @q
vnoremap Q :normal @q

" Redo with U instead of Ctrl+R
noremap U <C-R>
" }}}
"
call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
"
" essentials {{{
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
"}}}
" which-key {{{
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

let g:which_key_map =  {}

autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map.t = { 'name' : '+toggle' }
nnoremap <leader>t<space> :Buffers<cr>

nnoremap <leader>d :put =strftime('%Y_%b_%d_%a:')<cr>
let g:which_key_map.d = 'insert-date'

nnoremap <leader>ts :set spell!<cr>
let g:which_key_map.t.s = 'spelling'

" cd into current buffer
nnoremap <leader>cd :cd %:p:h<cr>

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<cr>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<cr>

" }}}
" navigation + tmux {{{
Plug 'christoomey/vim-tmux-navigator'

let g:tmux_navigator_no_mappings = 1

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-H> :TmuxNavigateLeft<cr>
nnoremap <C-J> :TmuxNavigateDown<cr>
nnoremap <C-K> :TmuxNavigateUp<cr>
nnoremap <C-L> :TmuxNavigateRight<cr>
nnoremap <C-P> :TmuxNavigatePrevious<cr>

nnoremap <leader><space> :b#<cr>
let g:which_key_map['SPC'] = 'previous-buffer'

" }}}
" version control {{{
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' }

let g:magit_default_show_all_files = 0
let g:which_key_map.M = 'which_key_ignore'

if isdirectory(".git")
	let g:magit_enabled=1
	let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 's' : ['MagitOnly',      'status'],
      \ 't' : ['SignifyToggle',  'toggle-signs'],
      \ 'u' : ['UndotreeToggle',  'undo-tree'],
      \ }

else
	let g:magit_enabled=0
	let g:which_key_map.g = {
      \ 'name' : '+versions' ,
      \ 't' : ['SignifyToggle',  'toggle-signs'],
      \ 'u' : ['UndotreeToggle',  'undo-tree'],
      \ }
endif
"}}}
" fzf and bookmarks {{{
if executable("fzf")
    Plug '/usr/local/opt/fzf'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
endif
Plug 'junegunn/fzf.vim'

let g:fzf_layout = { 'down': '~25%' }
let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

if isdirectory(".git")
    nmap <leader>p :GitFiles --cached --others --exclude-standard<cr>
else
    nmap <leader>p :FZF .<cr>
endif
let g:which_key_map.p = 'snipe-file'

nmap <leader>f   :BLines<cr>
let g:which_key_map.f = 'snipe-line'
"}}}
" bookmarks {{{
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_auto_close = 1
let g:bookmark_sign = '##'
let g:bookmark_annotation_sign = '##'

let g:which_key_map.b = {
      \ 'name' : '+bookmarks' ,
      \ 't' : ['BookmarkToggle',    'toggle-bookmark'],
      \ 'r' : ['BookmarkAnnotate',    'rename-bookmark'],
      \ 'o' : ['BookmarkShowAll',  'open-bookmark'],
      \ }

nnoremap <leader>tb :BookmarkToggle<cr>
let g:which_key_map.t.b = 'bookmark'

" Shortcuts for frequently accessed files
command! Vimrc e $MYVIMRC
command! Zshrc e $XDG_CONFIG_HOME/zsh/.zshrc
command! J vs /Volumes/vikram/planner/app.txt
command! Brew e $XDG_CONFIG_HOME/brew/config
command! Env e $XDG_CONFIG_HOME/zsh/.zshenv
"}}}
" file management {{{
if executable("vifm")
  Plug 'vifm/vifm.vim'
  nnoremap <BS> :Vifm<cr>
endif

" }}}
" filetypes {{{
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'honza/vim-snippets'
Plug 'ap/vim-css-color'

if executable('shellcheck')
	Plug 'itspriddle/vim-shellcheck'
endif

" coc {{{

let g:coc_global_extensions = [
	\ 'coc-css',
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

"" }}}
" formatters {{{
Plug 'ntpeters/vim-better-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'yaml', 'html'] }

let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0


function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

autocmd BufWritePre * :call TrimWhitespace()

"""}}}
" {{{ refactoring
Plug 'da-x/name-assign.vim'

let g:name_assign_mode_maps = { "settle" : ["jj"] }

nnoremap <leader>x	     *``cgn
nnoremap <leader>X	     #``cgN
let g:which_key_map.x = 'change-next-forward'
let g:which_key_map.X = 'change-next-backwards'

" Don't think about when to use percent
nnoremap <leader>/ :%s/
vnoremap <leader>/ :s/
let g:which_key_map['/'] = 'find-&-replace'

vmap <leader>r <Plug>NameAssign
let g:which_key_map.r = 'refactor'
" }}}
" documentation {{{

if executable("zeal")
	Plug 'KabbAmine/zeavim.vim'
endif

if executable("dash")
	Plug 'rizzatti/dash.vim'
endif

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
	au!

	" tabs
	au BufNewFile,BufRead *.cpp,*.c  setlocal expandtab
	au BufNewFile,BufRead *.cpp,*.c  setlocal tabstop=2
	au BufNewFile,BufRead *.cpp,*.c  setlocal softtabstop=2
	au BufNewFile,BufRead *.cpp,*.c  setlocal shiftwidth=2

	" format
	au BufWritePre * :call TrimWhitespace()
	au FileType c ClangFormatAutoEnable
	au FileType cpp ClangFormatAutoEnable

augroup END


"}}}
" css {{{

augroup filetype_css
	au!
	autocmd BufWritePre * :call TrimWhitespace()
	autocmd BufWritePre,TextChanged,InsertLeave *.css,*.less,*.scss PrettierAsync
augroup END


" }}}
" elixir {{{
Plug 'elixir-editors/vim-elixir',     { 'for': 'elixir' }
Plug 'carlosgaldino/elixir-snippets', { 'for': 'elixir' }
Plug 'avdgaag/vim-phoenix',           { 'for': 'elixir' }
Plug 'mmorearty/elixir-ctags',        { 'for': 'elixir'}
Plug 'mattreduce/vim-mix',            { 'for': 'elixir'}
Plug 'BjRo/vim-extest',               { 'for': 'elixir'}
Plug 'frost/vim-eh-docs',             { 'for': 'elixir'}

" }}}
" golang {{{
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
" }}}
" gql{{{
Plug 'jparise/vim-graphql'
autocmd BufWritePre,TextChanged,InsertLeave *.graphql PrettierAsync
"}}}
" haskell {{{
" Plug 'eagletmt/neco-ghc'
" Plug 'dag/vim2hs'

"}}}
"javascript {{{
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

au BufNewFile,BufRead *.js setlocal tabstop=2
au BufNewFile,BufRead *.js setlocal softtabstop=2
au BufNewFile,BufRead *.js setlocal shiftwidth=2

autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx PrettierAsync

"}}}
" julia {{{
Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }

autocmd BufNewFile,BufRead *.jmd set syntax=markdown
autocmd BufNewFile,BufRead *.jmd set filetype=markdown
autocmd BufNewFile,BufRead *.jmd setlocal tabstop=4
autocmd BufNewFile,BufRead *.jmd setlocal softtabstop=4
autocmd BufNewFile,BufRead *.jmd setlocal shiftwidth=4
autocmd BufNewFile,BufRead *.jmd setlocal textwidth=79
autocmd BufNewFile,BufRead *.jmd setlocal expandtab
autocmd BufNewFile,BufRead *.jmd setlocal autoindent
autocmd BufNewFile,BufRead *.jmd setlocal nofoldenable

autocmd BufNewFile,BufRead *.tpl set syntax=tex
" }}}
" latex {{{
Plug 'lervag/vimtex'
"}}}
" markdown {{{
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.md set syntax=markdown
autocmd BufNewFile,BufRead *.md setlocal nonumber
autocmd BufNewFile,BufRead *.md setlocal nofoldenable
autocmd BufNewFile,BufRead *.md setlocal spell
"}}}
" nix {{{
Plug 'LnL7/vim-nix', { 'for': 'nix' }
" }}}
" python {{{
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'psf/black', { 'tag': '19.10b0', 'for': 'python' }

let g:black_linelength = 100

function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

augroup filetype_python
	au!

	" indentation
	au BufNewFile,BufRead *.py setlocal expandtab
	au BufNewFile,BufRead *.py setlocal tabstop=4
	au BufNewFile,BufRead *.py setlocal softtabstop=4
	au BufNewFile,BufRead *.py setlocal shiftwidth=4
	au BufNewFile,BufRead *.py setlocal autoindent

	" textwidth
	au BufNewFile,BufRead *.py setlocal colorcolumn=81
	au BufNewFile,BufRead *.py setlocal textwidth=79

	" code folding
	autocmd BufNewFile,BufRead *.jmd setlocal nofoldenable

	" format on save
	autocmd BufWritePre * :call TrimWhitespace()
	autocmd BufWritePre *.py execute ':Black'
augroup END

" }}}
" r {{{
Plug 'jalvesaq/Nvim-R', { 'for': 'r' }
Plug 'vim-pandoc/vim-pandoc', { 'for': 'r' }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'r' }

autocmd BufNewFile,BufRead *.Rmd setlocal nonumber
"}}}
" rust {{{
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

let g:rustfmt_autosave = 1
"  }}}
" terraform {{{
Plug 'hashivim/vim-terraform'
" }}}
" typscript {{{
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescipt' }

let g:yats_host_keyword = 1

autocmd BufWritePre,TextChanged,InsertLeave *.ts,*.tsx PrettierAsync

"}}}
" vue {{{
autocmd BufWritePre,TextChanged,InsertLeave *.vue PrettierAsync
" }}}
" webgl {{{
Plug 'petrbroz/vim-glsl', { 'for': 'glsl' }
"}}}
" yaml {{{
Plug 'avakhov/vim-yaml'
autocmd BufWritePre,TextChanged,InsertLeave *.yaml PrettierAsync
" }}}

"}}}
" english better {{{
Plug 'reedes/vim-lexical'          " better spellcheck mappings
Plug 'reedes/vim-litecorrect'      " better autocorrections
Plug 'reedes/vim-textobj-sentence' " treat sentences as text objects
Plug 'reedes/vim-wordy'            " weasel words and passive voice
Plug 'Ron89/thesaurus_query.vim'   " use better words
Plug 'sedm0784/vim-you-autocorrect'
"}}}
" visual and user interface {{{
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'

colorscheme gruvbox

let g:rainbow_active   = 1
let g:startify_use_env = 1

let g:startify_commands = [
        \   { 'up': [ 'Update Plugins',			':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \   { 'uc': [ 'Clean Plugin Manager',	':PlugClean' ] },
        \ ]

autocmd User Startified setlocal cursorline

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
      \ 'colorscheme': 'gruvbox',
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
      \ },
      \ }

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" Automatically reload .vimrc file on save
augroup reload_vimrc
  au BufWritePost $MYVIMRC call LightlineReload()
augroup END

augroup reload_zshenv
  au!
  au BufWritePost .zshenv !source %
  au BufWritePost .zshenv call LightlineReload()
augroup END

augroup reload_zshrc
  au!
  au BufWritePost .zshrc  !source %
  au BufWritePost .zshrc call LightlineReload()
augroup END


"}}}
" goyo {{{
Plug 'junegunn/goyo.vim'
let g:vim_markdown_frontmatter = 1
let g:goyo_width               = "80%"
let g:goyo_disabled_signify    = 1
let g:which_key_map.t.g = 'goyo'

function! s:goyo_enter()
	set nonumber
	set linespace=7
endfunction

function! s:goyo_leave()
	set number
	set linespace=0
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

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <leader>tg :Goyo<cr>

" }}}
" sessions {{{
let g:which_key_map.s = {
      \ 'name' : '+sessions' ,
      \ 'o' : ['SLoad',    'open-session'],
      \ 's' : ['SSave',    'save-session'],
      \ 'd' : ['SDelete',  'delete-session'],
      \ 'c' : ['SClose',   'close-session'],
      \ }
" }}}
" experimental{{{
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'markonm/traces.vim'
Plug 'wellle/targets.vim'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
" }}}
" remember position in file {{{
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" }}}
"
call plug#end()
"
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
" }}}
"
"----------------------------------------------------------------------------------------
