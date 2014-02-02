let g:collectPluginHome = expand("<sfile>:p:h")

function! CollectTags()

    execute "edit " . g:collectPluginHome . "../data/collect_tmp.wiki"
    execute "normal! ggVGd"

    let uInput = input("Tag Names? ")

    execute "read !" . g:collectPluginHome . "/collect.py " . uInput    

endfunction

nnoremap <leader>C :call CollectTags()<CR>
