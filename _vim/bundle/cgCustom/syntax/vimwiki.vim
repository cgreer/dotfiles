
" CGCUSTOM VIMSIEVE HIGHLIGHTING
" my custom stuff for tags and what not ^^ cgcustom tags syntax-highlighting vim custom
syntax match vimsieveTags "\v\^\^ .*$"
syntax match vimsieveTags "\v\]\*"
highlight link vimsieveTags VimsieveTag
highlight VimsieveTag cterm=italic gui=italic ctermfg=darkyellow guifg=darkyellow

