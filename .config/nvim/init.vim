
if exists('g:vscode')
 set clipboard+=unnamedplus

 nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
 xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
 nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
 xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
 nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
 xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
 nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
 xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

 nnoremap ; :
 vnoremap ; :

 xmap gc  <Plug>VSCodeCommentary
 nmap gc  <Plug>VSCodeCommentary
 omap gc  <Plug>VSCodeCommentary
 nmap gcc <Plug>VSCodeCommentaryLine

 xmap cm  <Plug>VSCodeCommentary
 nmap cm  <Plug>VSCodeCommentary
 omap cm  <Plug>VSCodeCommentary
 nmap cml <Plug>VSCodeCommentaryLine

 command! Rg call VSCodeNotify('extension.ripgrep')
 command! Fix call VSCodeNotify('keyboard-quickfix.openQuickFix')
 command! Reload call VSCodeNotify('workbench.action.reloadWindow')
 command! GStatus call VSCodeNotify('magit.status')
 command! GCommit call VSCodeNotify('extension.conventionalCommits')
 command! Sidebar call VSCodeNotify('multiCommand.toggleSidebar')

 nmap <silent> <BS> :Find<CR>
 nmap <silent> <Tab> :tabn<CR>
 nmap <silent> <S-Tab> :tabp<CR>

 " Redo with U instead of Ctrl+R
 noremap U <C-R

 " Quick get that register!
 nnoremap Q @q
 vnoremap Q :normal @q

 AlterCommand o[pen] Find

" let mapleader = "\<SPACE>"
 nnoremap <space> :call VSCodeNotify('whichkey.show')<cr>
 
else
endif