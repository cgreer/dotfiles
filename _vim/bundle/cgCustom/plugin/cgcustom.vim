
" create new window for exploring to occur in
function! CGWikiExploreWindow()
    
    " Current file name is needed for depth mode
    let g:cgwikiFN= expand("%:t")
    let g:cgwikiCurrentMode="WikiRecentMode"
    let g:cgwikiCurrentDepth="2"
    let g:cgwikiCurrentDepthMode="paths"

    " create new window
    belowright 12new
   
    " start in recent mode
    call CGUpdateWikiMode()
endfunction 

function! CGUpdateWikiMode()
    let eCommand= "call " . g:cgwikiCurrentMode . "()"
    execute eCommand
endfunction

" show recently used wiki files in list
function! WikiRecentMode()

    " assumes you are currently in the CGWikiExplore Window
    " create a list of recent wikis
    call system("./vimsieve/recent_wiki.sh")
    edit ./vimsieve/recent.wiki

    "re-establish mappings
    call CGWikiExploreMappings()

endfunction

" show formatted history of recent files and their line by line additions
function! WikiHistoryMode()

    " assumes you are currently in the CGWikiExplore Window
    " create a list of recent wikis
    " take care of master directory ^^ todo
    call system("./vimsieve/update_current_history.sh")
    edit ./vimsieve/current_history.data

    "re-establish mappings
    call CGWikiExploreMappings()

endfunction

function! WikiLinkDepthMode()
    
    " create a list of recent wikis
    let cmdString = "python ./vimsieve/depth_links.py show_depth ./vimsieve/linkdb.json \"" . g:cgwikiFN . "\" " . g:cgwikiCurrentDepth . " " . g:cgwikiCurrentDepthMode . " > ./vimsieve/depth.wiki"
    echom cmdString
   
    call system(cmdString)

    " open list in new buffer on bottom
    edit ./vimsieve/depth.wiki

    call CGWikiExploreMappings()

endfunction


function! CGWikiExploreMappings()
    
    "mappings
    nnoremap <buffer>q :q<CR>
    nnoremap <buffer><CR> :call CGFollowLink()<CR> 

    " main modes
    nmap <buffer>d :let g:cgwikiCurrentMode="WikiLinkDepthMode"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>r :let g:cgwikiCurrentMode="WikiRecentMode"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>h :let g:cgwikiCurrentMode="WikiHistoryMode"<CR>:call CGUpdateWikiMode()<CR>

    " alter variables
    nmap <buffer>2 :let g:cgwikiCurrentDepth="2"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>3 :let g:cgwikiCurrentDepth="3"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>4 :let g:cgwikiCurrentDepth="4"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>5 :let g:cgwikiCurrentDepth="5"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>6 :let g:cgwikiCurrentDepth="6"<CR>:call CGUpdateWikiMode()<CR>
    
    nmap <buffer>p :let g:cgwikiCurrentDepthMode="paths"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>c :let g:cgwikiCurrentDepthMode="centrality"<CR>:call CGUpdateWikiMode()<CR>


endfunction
    
function! CGWikiNewPage(withHighlight, addLinkToCurrentPage)

    " grab currently selected text
    if a:withHighlight == "true"
        execute "normal! `<v`>d" 
    endif

    " grab the new page name
    let newPageName = input('New Page Name? (w/out ".wiki" suffix): ', '')

    " add link to current page 
    " tags: if else vim normal insert text
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

function! ToCollector()
    echom "calling collector"
    execute "normal! `<v`>d" 
    execute "edit ".fnameescape("Collector\ General.wiki")
    execute "normal! 2O"
    execute "normal! P"
    execute "b#"
endfunction 

" index mapping
nnoremap <leader><leader>0 :e index.wiki<CR>

" collector general stuff
nnoremap <leader><leader>1 :e Collector\ General.wiki<CR>
nnoremap <leader><leader>2 :e mobile/Collector\ Mobile.wiki<CR>
vnoremap <leader><leader>mc :<c-u>call ToCollector()<CR>

" using autocomplete link to page, clean link
inoremap <leader><leader>wl [[]]<ESC>hi./
nnoremap <leader><leader>wl a[[]]<ESC>hi./
nnoremap <leader><leader>cl :s/\.wiki]]/]]/g<CR> :s/\.\///g<CR>

" add stuff to today's todo list
nnoremap <leader><leader>mtt Vd/TODAY<CR>p :nohlsearch<cr>
nnoremap <leader><leader>ctt Vy/TODAY<CR>p :nohlsearch<cr>

" Load Custom Vimsieve Plugin
nnoremap <leader><F2> :call CGWikiExploreWindow()<CR>

" add tags to end of line
nnoremap <leader><leader>at $a<SPACE>^^<SPACE>

" depth displays
nnoremap <leader><leader>u :call system("./vimsieve/update_wiki_db.sh")<CR>

" link highlighted/non-highlighted text to current page and go there
" lh = link here, le = link elsewhere
" the c-u clears the line (when you press : in V mode it auto adds some stuff)
vnoremap <leader><leader>lh :<c-u>call CGWikiNewPage('true', 'true')<CR>
vnoremap <leader><leader>le :<c-u>call CGWikiNewPage('true', 'false')<CR>
nnoremap <leader><leader>lh :call CGWikiNewPage('false', 'true')<CR>
nnoremap <leader><leader>le :call CGWikiNewPage('false', 'false')<CR>
