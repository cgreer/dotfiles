" highlight Normal ctermbg=darkgrey
syntax clear

" ODD INDENT
syntax match oddindent "\v^( )+\w.*$"
highlight link oddindent SINDENT 

" EVEN INDENT
syntax match evenindent "\v^(    )+\w.*$"
highlight link evenindent DINDENT 

highlight SINDENT ctermfg=blue guifg=blue
highlight DINDENT ctermfg=white guifg=white
" highlight HBack ctermfg=darkgray guifg=background
