
syntax match vimsieveTagLineOne "^.\{-}::"
highlight link vimsieveTagLineOne CGFN
highlight CGFN cterm=italic gui=italic ctermfg=gray guifg=gray

syntax match vimsieveTagLineTwo "|.\{-}-->"
highlight link vimsieveTagLineTwo CGTT
highlight CGTT cterm=italic gui=italic ctermfg=darkyellow guifg=darkyellow

syntax match vimsieveTagLineThree "++.*$"
highlight link vimsieveTagLineThree CGTTT
highlight CGTTT cterm=italic gui=italic ctermfg=red guifg=red

syn match cgAnnotation 'hello' conceal contained conceal cchar=←

highlight link cgAnnotation CGA
highlight CGA cterm=italic gui=italic ctermfg=red guifg=red
