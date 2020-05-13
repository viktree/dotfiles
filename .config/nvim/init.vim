" vim: fdm=marker foldenable sw=4 ts=4 sts=4
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
set updatetime=100         " Faster, faster, faster!
set wildmode=longest,list  " get bash-like tab completions

" searching {{{
set nohlsearch			   " highlight search results
set inccommand=nosplit	   " THIS IS AMAZING! :O

" }}}

let mapleader = "\<SPACE>"

" Sync with system clipboard files
if has('macunix')
	vmap <C-x> :!pbcopy<CR>
	vmap <C-c> :w !pbcopy<CR><CR>
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
" Try to go into visual mode (v), then select lines of code here and press `>`
vnoremap < <gv
vnoremap > >gv

nnoremap Q @q
vnoremap Q :normal @q

" leader mappings {{{
function ListLeaders()
  silent! redir @a
  silent! nmap <LEADER>
  silent! redir END
  silent! new
  silent! put! a
  silent! g/^s*$/d
  silent! %s/^.*,//
  silent! normal ggVg
  silent! sort
  silent! let lines = getline(1,"$")
endfunction

let g:which_key_map =  {}

" Define prefix dictionary

let g:which_key_map.w = {
      \ 'name' : '+windows' ,
      \ 'h' : ['<C-W>h',  'window-left'],
      \ 'j' : ['<C-W>j',  'window-below'],
      \ 'l' : ['<C-W>l',  'window-right'],
      \ 'k' : ['<C-W>k',  'window-up'],
      \ 'w' : ['<C-W>w',  'other-window'],
      \ 's' : ['<C-W>s',  'split-window-below'],
      \ 'v' : ['<C-W>v',  'split-window-right'],
      \ 'd' : ['<C-W>c',  'delete-window'],
      \ '?' : ['Windows', 'fzf-window'],
      \ }

let g:which_key_map.s = {
      \ 'name' : '+sessions' ,
      \ 'o' : ['SLoad',    'open-session'],
      \ 's' : ['SSave',    'save-session'],
      \ 'd' : ['SDelete',  'delete-session'],
      \ 'c' : ['SClose',   'close-session'],
      \ }

let g:which_key_map.t = {
      \ 'name' : '+toggle' ,
      \ 's' : ['set spell!',    'spelling'],
      \ 'g' : ['Goyo',    'goyo'],
      \ }

nnoremap <leader>x	     *``cgn        " change next forwards
nnoremap <leader>X	     #``cgN        " change next backwards

" Don't think about when to use percent
nnoremap <leader>/ :%s/
vnoremap <leader>/ :s/
let g:which_key_map['/'] = { 'name' : 'find-&-replace' }

nnoremap <leader><space> :b#<CR>
nnoremap <leader>cd	     :cd %:p:h<CR> " cd into current buffer
" }}}

" }}}
"
call plug#begin('~/.config/nvim/plugged')
"
" essentials {{{
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
"}}}
" formatters {{{
Plug 'ntpeters/vim-better-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'
Plug 'psf/black', { 'for': 'python' }
Plug 'rhysd/vim-clang-format'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'yaml', 'html'] }

let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
let g:black_linelength = 100
let g:clang_format#detect_style_file = 1

function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

autocmd BufWritePre * :call TrimWhitespace()
autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.ts,*.tsx PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.css,*.less,*.scss PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.vue PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.json PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.graphql PrettierAsync
autocmd BufWritePre,TextChanged,InsertLeave *.yaml PrettierAsync
autocmd FileType c ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable

""}}}
" version control {{{
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'mhinz/vim-signify'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' }

let g:magit_default_show_all_files = 0

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
Plug 'MattesGroeger/vim-bookmarks'

if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
endif
Plug 'junegunn/fzf.vim'

let g:fzf_layout = { 'down': '~25%' }
let g:bookmark_auto_close = 1
let g:bookmark_sign = '##'
let g:bookmark_annotation_sign = '##'
let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

if isdirectory(".git")
    nmap <leader>f :GitFiles --cached --others --exclude-standard<CR>
else
    nmap <leader>f :FZF<CR>
endif

nmap     <leader>c   :BLines<CR>
nmap     <leader>bt  <Plug>BookmarkToggle
nmap     <leader>bm  <Plug>BookmarkAnnotate
nmap     <leader>ba  :BookmarkShowAll <CR>/
noremap  <leader>bb  :Buffers <CR>
"}}}
" vifm {{{
Plug 'vifm/vifm.vim'

nnoremap <BS> :Vifm<CR>
" }}}
" filetypes {{{
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'honza/vim-snippets'

" coc {{{

let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
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
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

let g:coc_snippet_next = '<tab>'

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" }}}

let g:devdocs_filetype_map = {
    \   'javascript.jsx'  : 'react',
    \   'javascript.test' : 'chai',
	\   '*'               : ''
    \ }

nmap J <Plug>(devdocs-under-cursor)

" bash {{{
Plug 'kovetskiy/vim-bash', { 'for': 'bash' }
" }}}
" c/cpp {{{
Plug 'arakashic/chromatica.nvim', { 'for': ['c', 'cpp']}

autocmd BufNewFile,BufRead *.cpp setlocal fdm=syntax
autocmd BufNewFile,BufRead *.cpp setlocal nofoldenable
autocmd BufNewFile,BufRead *.cpp setlocal tabstop=4
autocmd BufNewFile,BufRead *.cpp setlocal softtabstop=4
autocmd BufNewFile,BufRead *.cpp setlocal shiftwidth=4
"}}}
" elixir {{{
" Plug 'elixir-editors/vim-elixir',     { 'for': 'elixir' }
" Plug 'carlosgaldino/elixir-snippets', { 'for': 'elixir' }
" Plug 'avdgaag/vim-phoenix',           { 'for': 'elixir' }
" Plug 'mmorearty/elixir-ctags', { 'for': 'elixir'}
" Plug 'mattreduce/vim-mix', { 'for': 'elixir'}
" Plug 'BjRo/vim-extest', { 'for': 'elixir'}
" Plug 'frost/vim-eh-docs', { 'for': 'elixir'}
" Plug 'slashmili/alchemist.vim', { 'for': 'elixir'}

" }}}
" golang {{{
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries'}
" }}}
" gql{{{
Plug 'jparise/vim-graphql'
"}}}
" haskell {{{
" Plug 'eagletmt/neco-ghc'
" Plug 'dag/vim2hs'
" Plug 'pbrisbin/vim-syntax-shakespeare'

"}}}
"javascript {{{
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

au BufNewFile,BufRead *.js setlocal tabstop=2
au BufNewFile,BufRead *.js setlocal softtabstop=2
au BufNewFile,BufRead *.js setlocal shiftwidth=2

"}}}
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
" Plug 'vim-scripts/indentpython.vim'

autocmd BufNewFile,BufRead *.py setlocal tabstop=4
autocmd BufNewFile,BufRead *.py setlocal softtabstop=4
autocmd BufNewFile,BufRead *.py setlocal shiftwidth=4
autocmd BufNewFile,BufRead *.py setlocal textwidth=79
autocmd BufNewFile,BufRead *.py setlocal expandtab
autocmd BufNewFile,BufRead *.py setlocal foldlevel=30
autocmd BufNewFile,BufRead *.py setlocal autoindent
autocmd BufNewFile,BufRead *.py setlocal fileformat=unix
autocmd BufNewFile,BufRead *.py setlocal colorcolumn=81
" }}}
" r {{{
Plug 'jalvesaq/Nvim-R', { 'for': 'r' }
Plug 'vim-pandoc/vim-pandoc', { 'for': 'r' }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'r' }

autocmd BufNewFile,BufRead *.Rmd setlocal nonumber
"}}}
" rust {{{
" Plug 'racer-rust/vim-racer', { 'for': 'rust' }
" Plug 'rust-lang/rust.vim', { 'for': 'rust' }
"  }}}
" terraform {{{
Plug 'hashivim/vim-terraform'
" }}}
" typscript {{{
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescipt' }

let g:yats_host_keyword = 1
"}}}
" webgl {{{
Plug 'petrbroz/vim-glsl', { 'for': 'glsl' }
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
Plug 'junegunn/goyo.vim'

" Goyo {{{
let g:vim_markdown_frontmatter = 1
let g:goyo_width               = "80%"
let g:goyo_disabled_signify    = 1

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
" }}}

colorscheme gruvbox

let g:rainbow_active   = 1
let g:startify_use_env = 1

let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \   { 'uc': [ 'Clean Plugin Manager', ':PlugClean' ] },
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
      \ 'colorscheme': 'wombat',
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

"}}}
" experimental{{{
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'markonm/traces.vim'
Plug 'wellle/targets.vim'
" }}}
" which-key {{{
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
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
" Transparency! {{{
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
