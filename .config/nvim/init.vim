" vim: fdm=marker foldlevel=0 foldenable sw=2 ts=2 sts=2
"----------------------------------------------------------------------------------------
" Title:		Neovim configuration
" Author:		Vikram Venkataramanan
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
set noshowcmd			   " don't show last command
set wildmode=longest,list  " get bash-like tab completions

set clipboard+=unnamedplus " map nvim clipboard to system clipboard
set ffs=unix,dos,mac       " Unix as standard file type
set updatetime=100         " faster, faster, faster!
set autoread			   " automatically reload file when underlying files change
set mouse=a                " sometimes helpful
set secure                 " disallows :autocmd, shell + write commands in local .vimrc
set showmatch              " Show matching brackets

set shortmess+=c		   " don't pass messages to |ins-completion-menu|.

" searching
set nohlsearch			   " highlight search results
set inccommand=nosplit	   " THIS IS AMAZING! :O
set gdefault			   " by default, swap out all instances in a line

let mapleader = "\<SPACE>"

" Sync with system clipboard files
if has('macunix')
	vmap <C-x> :!pbcopy<cr>
	vmap <C-c> :w !pbcopy<cr><cr>
endif

set number
set relativenumber
augroup line_numbers
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber
augroup END

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
" setup vim-plug {{{
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let g:plug_home = stdpath('data') . '/plugged'

if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

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

if executable("tmux")
	nnoremap <C-H> :TmuxNavigateLeft<cr>
	nnoremap <C-J> :TmuxNavigateDown<cr>
	nnoremap <C-K> :TmuxNavigateUp<cr>
	nnoremap <C-L> :TmuxNavigateRight<cr>
	nnoremap <C-P> :TmuxNavigatePrevious<cr>
endif

" buffers
nnoremap <S-h> :bprevious<cr>
nnoremap <S-l> :bnext<cr>

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
	let g:which_key_map.g  = {
		\ 'name' : '+git' ,
		\ 's' : ['MagitOnly',      'status'],
		\ 't' : ['SignifyToggle',  'toggle-signs'],
		\ 'u' : ['UndotreeToggle',  'undo-tree'],
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
" fzf {{{
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
let g:which_key_map.p = 'change-file'

nmap <leader>f :BLines<cr>
let g:which_key_map.f = 'snipe-line'
"}}}
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
" file management {{{
if executable("vifm")
  Plug 'vifm/vifm.vim'
  let g:vifm_replace_netrw = 1

  nnoremap <bs> :Vifm<cr>

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
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

augroup highlight_under_cursor
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END


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

augroup trim_trailing_whitespace
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END


"""}}}
" {{{ refactoring
Plug 'da-x/name-assign.vim'

let g:name_assign_mode_maps = { "settle" : ["jj"] }

nnoremap <leader>x	   *``cgn
nnoremap <leader>X	   #``cgN
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
	autocmd!

	" tabs
	autocmd BufNewFile,BufRead *.cpp,*.c  setlocal expandtab
	autocmd BufNewFile,BufRead *.cpp,*.c  setlocal tabstop=2
	autocmd BufNewFile,BufRead *.cpp,*.c  setlocal softtabstop=2
	autocmd BufNewFile,BufRead *.cpp,*.c  setlocal shiftwidth=2

	" format
	autocmd BufWritePre * :call TrimWhitespace()
	autocmd FileType c ClangFormatAutoEnable
	autocmd FileType cpp ClangFormatAutoEnable

augroup END


"}}}
" css {{{

augroup filetype_css
	autocmd!
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
autocmd BufWritePre,TextChanged,InsertLeave *.g['['] raphql PrettierAsync
"}}}
" haskell {{{
Plug 'eagletmt/neco-ghc'
Plug 'dag/vim2hs'

"}}}
"javascript {{{
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

autocmd BufNewFile,BufRead *.js setlocal tabstop=2
autocmd BufNewFile,BufRead *.js setlocal softtabstop=2
autocmd BufNewFile,BufRead *.js setlocal shiftwidth=2

autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx PrettierAsync

"}}}
" julia {{{
Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }

augroup filetype_julia
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
augroup END

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
" colorscheme {{{
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
Plug 'mhinz/vim-startify'

colorscheme gruvbox

let g:rainbow_active   = 1
let g:startify_use_env = 1

autocmd User Startified setlocal cursorline

"}}}
" lightline {{{
Plug 'itchyny/lightline.vim'

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

augroup reload_zsh
  autocmd!
  autocmd BufWritePost .zshenv !source %
  autocmd BufWritePost .zshrc !source %
  autocmd BufWritePost .zshenv call LightlineReload()
augroup END

if executable('direnv')
	augroup reload_direnv
		autocmd!
		autocmd BufWritePost .envrc !direnv allow .
		autocmd BufWritePost .envrc call LightlineReload()
	augroup END
endif

"}}}
" goyo {{{
Plug 'junegunn/goyo.vim'
let g:vim_markdown_frontmatter = 1
let g:goyo_width               = "80%"
let g:goyo_disabled_signify    = 1
let g:which_key_map.t.g		   = 'goyo'

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
" remember position in file {{{
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" }}}
" experimental{{{
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'markonm/traces.vim'
Plug 'wellle/targets.vim'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
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
