
" show recently used wiki files in list
function! WikiRecent()
    
    " create a list of recent wikis
    call system("./recent_wiki.sh")

    " open list in new buffer on bottom
    belowright 12new
    edit ./recent.wiki

    " Map <CR> to CGFollowLink in this buffer only
    nnoremap <buffer><CR> :call CGFollowLink()<CR> 
endfunction

" follow link using vimwiki's custom parsing and follow function
" I wrapped it in here to be able to close the WikiRecent window first
function! CGFollowLink()
  
    echom "calling cgfollow"
    " get link under cursor before you close the window
    let lnk = matchstr(vimwiki#base#matchstr_at_cursor(g:vimwiki_rxWikiLink),
          \ g:vimwiki_rxWikiLinkMatchUrl)
    echom lnk

    " close the current recent window
    silent! close

    " construct arguments for following
    let cmd = ":e "

    " call it
    call vimwiki#base#open_link(cmd, lnk)
endfunction

nnoremap ,<F2> :call WikiRecent()<CR>


