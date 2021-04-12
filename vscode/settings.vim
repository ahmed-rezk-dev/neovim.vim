" TODO there is a more contemporary version of this file
" TODO Also some of it is redundant
"VSCode
function! s:split(...) abort
    let direction = a:1
    let file = a:2
    call VSCodeCall(direction == 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if file != ''
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

function! s:splitNew(...)
    let file = a:2
    call s:split(a:1, file == '' ? '__vscode_new__' : file)
endfunction

function! s:closeOtherEditors()
    call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
    call VSCodeNotify('workbench.action.closeOtherEditors')
endfunction

function! s:manageEditorSize(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
    endfor
endfunction

function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

function! s:openVSCodeCommandsInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

function! s:openWhichKeyInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction


command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
command! -bang Only if <q-bang> == '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

" Better Navigation
nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>

" Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
xnoremap <expr> <C-/> <SID>vscodeCommentary()
nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine



" MORE SETTINGS

" Folding
set nofoldenable
"set foldlevelstart=99
set foldmethod=indent

" Folding cursor over fold without open it.
nnoremap j :<C-u>call VSCodeCall('cursorDown')<CR>
nnoremap k :<C-u>call VSCodeCall('cursorUp')<CR>

nnoremap <silent> <C-w>za :<C-u>call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> <C-w>zA :<C-u>call VSCodeNotify('editor.unfoldRecursively')<CR>


" gf/gF . Map to go to definition for now
nnoremap <silent> gf :<C-u>call <SID>vscodeGoToDefinition()<CR>
nnoremap <silent> gd :<C-u>call <SID>vscodeGoToDefinition()<CR>
nnoremap <silent> gh :<C-u>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap <silent> <C-]> :<C-u>call <SID>vscodeGoToDefinition()<CR>
nnoremap <silent> gF :<C-u>call VSCodeNotify('editor.action.peekDefinition')<CR>
nnoremap <silent> gD :<C-u>call VSCodeNotify('editor.action.peekDefinition')<CR>

xnoremap <silent> gf :<C-u>call <SID>vscodeGoToDefinition()<CR>
xnoremap <silent> gd :<C-u>call <SID>vscodeGoToDefinition()<CR>
xnoremap <silent> gh :<C-u>call <SID>hover()<CR>
xnoremap <silent> <C-]> :<C-u>call <SID>vscodeGoToDefinition()<CR>
xnoremap <silent> gF :<C-u>call VSCodeNotify('editor.action.peekDefinition')<CR>
xnoremap <silent> gD :<C-u>call VSCodeNotify('editor.action.peekDefinition')<CR>
" <C-w> gf opens definition on the side
nnoremap <silent> <C-w>gf :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
nnoremap <silent> <C-w>gd :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
nnoremap <silent> <C-w>gF :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
xnoremap <silent> <C-w>gf :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
xnoremap <silent> <C-w>gd :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
xnoremap <silent> <C-w>gF :<C-u>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>

" Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
xnoremap <expr> <C-/> <SID>vscodeCommentary()
nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

" Workaround for gk/gj
nnoremap gk :<C-u>call VSCodeCall('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>
nnoremap gj :<C-u>call VSCodeCall('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>

" workaround for calling command picker in visual mode
xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>


inoremap <expr> <c-e> pumvisible() ? "\<c-e>" : "\<c-o>A"

nnoremap <expr> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <expr> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <expr> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <expr> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
