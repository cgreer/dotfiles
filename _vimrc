" https://github.com/sontek/dotfiles/
" Plugins included
" ==========================================================
" Pathogen
"     Better Management of VIM plugins
"
" Snipmate
"     Configurable snippets to avoid re-typing common comands
"
" Git
"    Syntax highlighting for git config files
"
" Minibufexpl
"    Visually display what buffers are currently opened
"
" Pydoc
"    Opens up pydoc within vim
"
" Surround
"    Allows you to surround text with open/close tags
"
"
" ==========================================================
" Shortcuts
" ==========================================================
set nocompatible              " Don't be compatible with vi
let mapleader=","             " change the leader to be a comma vs slash

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

" Toggle the tasklist
map <leader>td <Plug>TaskList

" jk as escape
inoremap jk <Esc>

"toggle paste for pasting from outside 
set pastetoggle=<F8>

" ranger test
fun! RangerChooser()
   silent !ranger --choosefile=/tmp/chosenfile `[ -z '%' ] && echo -n . || dirname %`
   if filereadable('/tmp/chosenfile')
     exec 'edit ' . system('cat /tmp/chosenfile')
     call system('rm /tmp/chosenfile')
   endif
   redraw!
 endfun
 map ,r :call RangerChooser()<CR>

" begin/end of line to H/L
noremap H ^
noremap L $

noremap <leader>jj 8j
noremap <leader>kk 8k

" Map lTab to next buffer 
map <leader><TAB> :bn<CR>
map <leader>d :bd<CR>

" Map lnn to toggle lines off
nmap <leader>nn :set number! <CR>

"Map lc to comment out ind lines
map <leader>cc <plug>NERDCommenterInvert<CR>
map <leader>c <plug>NERDCommenterToggle<CR>

" Class Browser
nmap <F3> :TagbarToggle<CR><c-l> 

" Most recently used files
map <F2> :MRU <CR>

" ,v brings up my .vimrc
" ,V reloads it -- making all changes active (have to save first)
map <leader>v :sp ~/.vimrc<CR><C-W>_
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" ,h brings up my snippets
map <leader>h :sp ~/.vim/snippets/_.snippets<CR><C-W>

" Show all current snippets
nnoremap <leader>g ! ~/.vim/snippets/displaySnips.sh <CR>

" Thought template
nnoremap <leader>th ! ~/.vim/snippets/thoughtTemplate.sh <CR><c-j><c-j>

" clean wiki link
nnoremap <leader>cl :s/\.wiki]]/]]/<CR> :s/\.\///<CR>

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
imap <C-W> <C-O><C-W>

"Almost never use but might find useful in future
" Open NerdTree
" map <leader>n :NERDTreeToggle<CR>

" ==========================================================
" Pathogen - Allows us to organize our vim plugins
" ==========================================================
" Load pathogen with docs for all plugins

"Disable things if vim wasnt compiled with python support
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'pyflakes')


filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" ==========================================================
" Basic Settings
" ==========================================================
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set background=dark           " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set noswapfile

" don't bell or blink
set noerrorbells
set vb t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=menuone,longest,preview
set pumheight=6             " Keep a small completion window

""" Moving Around/Editing
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set wrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word


set autoindent              " always set autoindenting on
"set smartindent             " use smart indent if there is no indent file
set cindent
set tabstop=4               " <tab> inserts 4 spaces 
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default

" don't outdent hashes
" inoremap # #

" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
set nolist

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently 
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

" colorscheme wombat
colorscheme blackboard

" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Select the item in the list with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Don't allow snipmate to take over tab
autocmd VimEnter * ino <c-j> <c-r>=TriggerSnippet()<cr>

" Use tab to scroll through autocomplete menus
autocmd VimEnter * imap <expr> <Tab> pumvisible() ? "<C-N>" : "<Tab>"
autocmd VimEnter * imap <expr> <S-Tab> pumvisible() ? "<C-P>" : "<S-Tab>"
snor <c-j> <esc>i<right><c-r>=TriggerSnippet()<cr>
let g:acp_completeoptPreview=1


" ===========================================================
" FileType specific changes
" ============================================================
" Mako/HTML
autocmd BufNewFile,BufRead *.mako,*.mak setlocal ft=html
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Python
"au BufRead *.py compiler nose
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Tab Stuff for Nexus format file
autocmd BufRead *.format set noexpandtab
