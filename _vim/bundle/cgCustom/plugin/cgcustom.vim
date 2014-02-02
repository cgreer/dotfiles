
let g:vimsieve_home = "/home/chris/Dropbox/wiki"

" create new window for exploring to occur in
function! CGWikiExploreWindow()
    
    " Current file name is needed for depth mode
    let g:cgwikiFN= expand("%:p")
    echom "CURRENT FILE " . g:cgwikiFN
    let g:cgwikiCurrentMode="WikiRecentMode"
    let g:cgwikiCurrentDepth="2"
    let g:cgwikiCurrentDepthMode="centrality"
    let g:cgwikiCurrentTagDepth="2"

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
    " check if this will output the recent to the cwd or not ^^ todo
    call system(g:vimsieve_home . "/vimsieve/recent_wiki.sh")
    let eFile = g:vimsieve_home . "/vimsieve/recent.wiki"
    exe "edit " . eFile

    "re-establish mappings
    call CGWikiExploreMappings("normal")

endfunction

" show formatted history of recent files and their line by line additions
function! WikiHistoryMode()

    " assumes you are currently in the CGWikiExplore Window
    " create a list of recent wikis
    " take care of master directory ^^ todo
    call system(g:vimsieve_home . "/vimsieve/update_current_history.sh")
    exe "edit " . g:vimsieve_home . "/vimsieve/current_history.data"

    "re-establish mappings
    call CGWikiExploreMappings("normal")

endfunction

function! WikiTagsMode()

    " set up filename stuff
    let currentFN = "fn::[[" . g:cgwikiFN . "]]"
    let serverMessage = "type::TAG\tdepth::" . g:cgwikiCurrentTagDepth . "\t" . currentFN

    echom "SENDING SERVER MESSAGE" . serverMessage

    " assumes you are currently in the CGWikiExplore Window
    echom system(g:vimsieve_home . "/vimsieve/wikiclient.py server_message " . shellescape(serverMessage))
    exe "edit " . g:vimsieve_home . "/vimsieve/current_tag.data"
    exe "set ft=linefile"

    "re-establish mappings
    call CGWikiExploreMappings("tag")
endfunction

function! WikiLinkDepthMode()
    
    " create a list of recent wikis
    let cmdString = "python " . g:vimsieve_home . "/vimsieve/depth_links.py show_depth ./vimsieve/linkdb.json \"" . g:cgwikiFN . "\" " . g:cgwikiCurrentDepth . " " . g:cgwikiCurrentDepthMode . " > ./vimsieve/depth.wiki"
    echom cmdString
   
    call system(cmdString)

    " open list in new buffer on bottom
    exe "edit " . g:vimsieve_home . "/vimsieve/depth.wiki"

    call CGWikiExploreMappings("normal")

endfunction


function! CGWikiExploreMappings(wikiMode)
    
    "mappings
    nnoremap <buffer>q :q<CR>
    if a:wikiMode == "tag"
        nnoremap <buffer><CR> :call CGFollowTag("true")<CR> 
    else
        nnoremap <buffer><CR> :call CGFollowLink("true")<CR> 
    endif

    " main modes
    nmap <buffer>d :let g:cgwikiCurrentMode="WikiLinkDepthMode"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>r :let g:cgwikiCurrentMode="WikiRecentMode"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>h :let g:cgwikiCurrentMode="WikiHistoryMode"<CR>:call CGUpdateWikiMode()<CR>
    nmap <buffer>t :let g:cgwikiCurrentMode="WikiTagsMode"<CR>:call CGUpdateWikiMode()<CR>

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
    " ^^ if else vim normal insert text
    if a:addLinkToCurrentPage == "true"
        if a:withHighlight == "true"
            execute "normal! O[[".newPageName.".wiki]]"
        else
            execute "normal! a[[".newPageName.".wiki]]"
        endif
    endif
    
    "" edit (open) the new page
    " make this work from any cwd ^^ todo
    execute "edit " . fnameescape(newPageName) . ".wiki"

    "" paste text into document
    if a:withHighlight == "true"
        execute "normal! p"
    endif
endfunction

function! MoveUpOneLine()
    let lineToMoveBelow = line(".") - 2
    let exString = line(".") . "m" . lineToMoveBelow
    execute exString 
    execute "normal! h"
endfunction

function! MoveDownOneLine()
    let lineToMoveBelow = line(".") + 1
    let exString = line(".") . "m" . lineToMoveBelow
    execute exString 
    execute "normal! h"
endfunction

" follow link using vimwiki's custom parsing and follow function
" I wrapped it in here to be able to close the WikiRecent window first
function! CGFollowLink(withClose)
  
    " get link under cursor before you close the window
    " This just gives you whatever is inside the double bracket enclosure
    " So if an entire directory is there with a non-acceptble ending, you
    " still get it
    " ie [[/u/home/hello world.sh]] will give you "/u/home/hello world.sh"
    let lnk = matchstr(vimwiki#base#matchstr_at_cursor(g:vimwiki_rxWikiLink),
          \ g:vimwiki_rxWikiLinkMatchUrl)
    echom lnk

    " close the current recent window
    if a:withClose == "true"
        silent! close
    endif

    " call vimwiki#base#open_link(cmd, lnk)
    " Might want to make a directory first
    " if vimwiki#base#mkdir(dir, 1)
    
    " if the name + .wiki exists, it is in the "base" directory so open it
    let potBaseName = g:vimsieve_home . "/" . lnk . ".wiki"
    if filereadable(potBaseName)
        execute ":e " . fnameescape(potBaseName)
        return 1
    endif

    " just bluntly open the file
    " Note: if it is a jpg or non-vim file it will error out I suppose
    execute ":e " . fnameescape(lnk)

endfunction

function! CGFollowTag(withClose)
 
    let currentLine = getline('.')
    echom currentLine
    let lineSplit = split(currentLine, '-->')
    echom "this is the split" . lineSplit[0]
    let tagFN = lineSplit[1]
    let tagLineNum = lineSplit[2]
    echom "This is the split vars" . tagFN . "...." . tagLineNum

    " close the current recent window
    if a:withClose == "true"
        silent! close
    endif

    " just bluntly open the file
    " Note: if it is a jpg or non-vim file it will error out I suppose
    " open on specific line ^^ vim open file edit line number
    execute "edit +" . tagLineNum . " " . fnameescape(tagFN)

endfunction

function! ToCollector()
    echom "calling collector"
    execute "normal! `<v`>d" 
    " make this work cwd ^^ todo
    execute "edit ".fnameescape("Collector\ General.wiki")
    execute "normal! 2O"
    execute "normal! P"
    execute "b#"
endfunction 

function! MakeLineFC()
    echom "calling FC Maker"
    " how to add spaces and escapes in macro call ^^ vimscript vim
    execute "normal! ^i%FF\ \<esc>f-a\ %FB\<esc>$a\ %FE" 
endfunction 

function! ToPList()
    " select visually select ^^ vim script select 
    execute "normal! `<v`>d" 
    execute "4"
    execute "normal! p"
endfunction 

function! NewSubPage()
    let subName = input('Sub Section Name? (w/out ".wiki" suffix): ', '')
    let newPageName = "[[" . expand("%:p:r") . " - " . subName . ".wiki]]"
    execute "normal! i". newPageName
    echom newPageName
endfunction

" index mapping
nnoremap <leader><leader>0 :exe "edit " . g:vimsieve_home . "/index.wiki"<CR>
nnoremap <leader><leader>sub :call NewSubPage()<CR>

" collector general stuff
nnoremap <leader><leader>1 :exe "edit " . g:vimsieve_home . fnameescape("/Collector\ General.wiki")<CR>
nnoremap <leader><leader>2 :exe "edit " . g:vimsieve_home . fnameescape("/mobile/Collector\ Mobile.wiki")<CR>
nnoremap <leader><leader>3 :exe "edit " . g:vimsieve_home . fnameescape("/Todo\ Day.wiki")<CR>
nnoremap <leader><leader>4 :exe "edit " . g:vimsieve_home . fnameescape("/IDG\ Tracking.wiki")<CR>
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
nnoremap <leader><leader>at $a<SPACE>@<SPACE>

" convert line into a flashcard
nnoremap <leader>f :call MakeLineFC()<CR> 

" convert line into a flashcard
nnoremap <RIGHT> :call MoveDownOneLine()<CR> 
nnoremap <LEFT> :call MoveUpOneLine()<CR> 

" depth displays
nnoremap <leader><leader>u :call system("./vimsieve/update_wiki_db.sh")<CR>

" link highlighted/non-highlighted text to current page and go there
" lh = link here, le = link elsewhere
" the c-u clears the line (when you press : in V mode it auto adds some stuff)
vnoremap <leader><leader>lh :<c-u>call CGWikiNewPage('true', 'true')<CR>
vnoremap <leader><leader>le :<c-u>call CGWikiNewPage('true', 'false')<CR>
nnoremap <leader><leader>lh :call CGWikiNewPage('false', 'true')<CR>
nnoremap <leader><leader>le :call CGWikiNewPage('false', 'false')<CR>

" move to priority list
vnoremap <leader><leader>9 :call ToPList()<CR>

" always use my goto commmand, need to fix overlap mapping ^^ todo
nnoremap <CR> :call CGFollowLink("false")<CR>
