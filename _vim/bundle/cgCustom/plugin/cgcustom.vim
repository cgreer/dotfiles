
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

" show links 
function! WikiLinkDepth(depth, dType)
    
    " create a list of recent wikis
    let currentFN = expand("%:t")
    let cmdString = "python ./depth_links.py show_depth zzz.out \"".currentFN."\" ".a:depth." ".a:dType." > ./depth.wiki"
    echom currentFN
    echom cmdString
   
    call system(cmdString)

    " open list in new buffer on bottom
    belowright 12new
    edit ./depth.wiki

    " Map <CR> to CGFollowLink in this buffer only
    nnoremap <buffer><CR> :call CGFollowLink()<CR> 
endfunction

function! CGWikiNewPage(withHighlight, addLinkToCurrentPage)

    " grab currently selected text
    if a:withHighlight == "true"
        execute "normal! `<v`>d" 
    endif

    " grab the new page name
    let newPageName = input('New Page Name? (w/out ".wiki" suffix): ', '')

    " add link to current page 
    " tag: if else vim normal insert text
    if a:addLinkToCurrentPage == "true"
        if a:withHighlight == "true"
            execute "normal! O[[".newPageName.".wiki]]"
        else
            execute "normal! a[[".newPageName.".wiki]]"
        endif
    endif
    
    "" edit (open) the new page
    execute "edit " . fnameescape(newPageName) . ".wiki"

    "" paste text into document
    if a:withHighlight == "true"
        execute "normal! p"
    endif
    
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

" mappings
"
nnoremap <leader><leader>1 :e Collector\ General.wiki<CR>

" using autocomplete link to page, clean link
nnoremap <leader><leader>wl a[[]]<ESC>hi./
nnoremap <leader><leader>cl :s/\.wiki]]/]]/g<CR> :s/\.\///g<CR>

" add stuff to today's todo list
nnoremap <leader><leader>tt Vd/TODAY<CR>p

" all recently edited wiki files
nnoremap ,<F2> :call WikiRecent()<CR>

" depth displays
nnoremap <leader><leader>d1 :call WikiLinkDepth("1", "centrality")<CR>
nnoremap <leader><leader>d2 :call WikiLinkDepth("2", "centrality")<CR>
nnoremap <leader><leader>d3 :call WikiLinkDepth("3", "centrality")<CR>
nnoremap <leader><leader>d4 :call WikiLinkDepth("4", "centrality")<CR>
nnoremap <leader><leader>d5 :call WikiLinkDepth("5", "centrality")<CR>

nnoremap <leader><leader>p1 :call WikiLinkDepth("1", "paths")<CR>
nnoremap <leader><leader>p2 :call WikiLinkDepth("2", "paths")<CR>
nnoremap <leader><leader>p3 :call WikiLinkDepth("3", "paths")<CR>

" link highlighted/non-highlighted text to current page and go there
" lh = link here, le = link elsewhere
" the c-u clears the line (when you press : in V mode it auto adds some stuff)
vnoremap <leader><leader>lh :<c-u>call CGWikiNewPage('true', 'true')<CR>
vnoremap <leader><leader>le :<c-u>call CGWikiNewPage('true', 'false')<CR>
nnoremap <leader><leader>lh :call CGWikiNewPage('false', 'true')<CR>
nnoremap <leader><leader>le :call CGWikiNewPage('false', 'false')<CR>
