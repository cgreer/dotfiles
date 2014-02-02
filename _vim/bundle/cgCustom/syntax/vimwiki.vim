
" CGCUSTOM VIMSIEVE HIGHLIGHTING
" my custom stuff for tags and what not ^^ cgcustom tags syntax-highlighting vim custom
hi Conceal guibg=black guifg=white
syntax match vimsieveTags "\v\/\%\%.*\%\%\/" conceal cchar=*

syntax match vimsieveTags "\v\^\^ .*$"
syntax match vimsieveTags "\v\]\*"
highlight link vimsieveTags VimsieveTag
highlight VimsieveTag cterm=italic gui=italic ctermfg=darkyellow guifg=darkyellow

syntax match fcTags "\v\%F[FBE]"
highlight link fcTags FCTag
highlight FCTag cterm=italic gui=italic ctermfg=darkblue guifg=darkblue
