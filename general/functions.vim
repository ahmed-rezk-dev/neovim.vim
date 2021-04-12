" Random Useful Functions

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Fold setting
"if has('folding')
 "" if has('windows')
  ""  set fillchars=vert:┃              " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
  "endif
  set foldmethod=indent               " not as cool as syntax, but faster
  "set foldlevelstart=99               " start unfolded
"endif



" Turn spellcheck on for markdown files
augroup auto_spellcheck
  autocmd BufNewFile,BufRead *.md setlocal spell
augroup END

nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

