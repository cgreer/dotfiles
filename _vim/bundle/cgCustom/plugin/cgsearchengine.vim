
let g:vimsieve_home = "/home/chris/Dropbox/wiki"

function! ExecuteSearch()

    " grab current paragraph
    execute "normal! `{v}y" 

    " execute similarity search
    let pythonfxn = g:vimsieve_home . "/vimsieve/paragraph/paragraphparse.py"
    let resultsFN = g:vimsieve_home . "/vimsieve/paragraph/currentResults.txt"
    let cmdString = "python " . pythonfxn . " search_vim_selection " . shellescape(@") . " > " . resultsFN 
    let callResult = system(cmdString)

    " open results in new buffer
    " example of updating a buffer or window with results vim ^^ vim example
    
    set splitright
    let bOpen = bufwinnr(resultsFN)
    if bOpen == -1
        exe "vsplit " . resultsFN
    else
        exe bOpen . "wincmd w"
        exe "edit " . resultsFN
    endif

    "change mappings on this search result buffer
    nnoremap <buffer>q :q<CR>

endfunction

nnoremap <F4> :call ExecuteSearch()<CR>
