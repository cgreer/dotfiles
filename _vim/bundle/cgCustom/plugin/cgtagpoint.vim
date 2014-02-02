
" Grab Text [x]
" Filter text through python toggle fxn


" Test /%% there is stuff in here 
"
"
"
" %%/

" Test /%% there is stuff in here %%/

let g:vimsieve_home = "/home/chris/Dropbox/wiki"

function! GrabAnnotationBlock()

    " TODO Grab 
    " "//e" goes to end of last character of last search
    execute "normal! " . '?/%%' . "\<cr>" . "0V" . '/%%\/' . "\<cr>" . '//e'

endfunction

function! ToggleTag()

    call GrabAnnotationBlock()    
    " call writefile(split(@", "\n"), "filename)
    " http://vim.wikia.com/wiki/Use_filter_commands_to_process_text
    execute "normal! " . "'<,'>!python " . g:vimsieve_home . "/vimsieve/annotatetoggle.py"
    





    " execute similarity search
    "let pythonfxn = g:vimsieve_home . "/vimsieve/annotatetoggle.py"
    "let resultsFN = g:vimsieve_home . "/vimsieve/"
    "let cmdString = "python " . pythonfxn . " search_vim_selection " . shellescape(@") . " > " . resultsFN 
    "let callResult = system(cmdString)

endfunction

nnoremap <leader>t :call ExecuteSearch()<CR>
