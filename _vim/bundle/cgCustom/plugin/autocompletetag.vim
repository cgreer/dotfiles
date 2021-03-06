
fun! CompleteTags(findstart, base)
    if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
        let start -= 1
    endwhile
    return start
    else
    " find months matching with "a:base"
    let res = []
    let tagsText = system("/home/chris/Dropbox/wiki/vimsieve/autotagcollect.sh")
    for m in split(tagsText)
        if m =~ '^' . a:base
    call add(res, m)
        endif
    endfor
    return res
    endif
endfun

set completefunc=CompleteTags
inoremap @ 
