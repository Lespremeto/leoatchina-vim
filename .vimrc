" This is leoatchina's vim config forked from https://github.com/spf13/spf13-vim
" Sincerely thank him for his great job, and I have made some change according to own requires.
"                    __ _ _____              _
"         ___ _ __  / _/ |___ /      __   __(_)_ __ ___
"        / __| '_ \| |_| | |_ \ _____\ \ / /| | '_ ` _ \
"        \__ \ |_) |  _| |___) |_____|\ V / | | | | | | |
"        |___/ .__/|_| |_|____/        \_/  |_|_| |_| |_|
"            |_|
" You can find spf13's origin config at http://spf13.com
" Basics
set nocompatible
if v:version < 700
    echoe 'This vimrc requires Vim 7.0 or later.'
    quit
endif
set re=1
set ttyfast
set lazyredraw
set encoding=utf-8
set fileencodings=utf-8,gbk,gb18030,gk2312,chinese,latin-1
set background=dark     " Assume a dark background
set mouse=a             " Automatically enable mouse usage
set mousehide           " Hide the mouse cursor while typing
set noimdisable
set timeout
set timeoutlen=500 ttimeoutlen=50
" 不同文件类型加载不同插件
filetype plugin indent on   " Automatically detect file types.
filetype on                 " 开启文件类型侦测
filetype plugin on          " 根据侦测到的不同类型:加载对应的插件
syntax on
" Identify platform
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction
" Basics
if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
    if !has('nvim') && has('gui_running')
        nmap <F11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
        imap <F11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
        vmap <F11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
        smap <F11> <esc>:call libcallnr('gvim_fullscreen.dll', 'ToggleFullscreen', 0)<cr>
    endif
else
    set shell=/bin/sh
    if !has("gui")
        if !has('nvim')
            set term=xterm-256color
        endif
    endif
endif
" Functions
" Initialize directories
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir',
        \ 'swap': 'directory' }
    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif
    " To specify a different directory in which to place the vimbackup,
    let common_dir = parent . '/.' . prefix
    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" Strip whiteSpace
function! StripTrailingWhiteSpace()
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" Shell command
function! s:RunShellCommand(cmdline)
    botright new
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell
    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:ExpandFilenameAndExecute(command, file)
    execute a:command . " " . expand(a:file, ":p")
endfunction
nnoremap <C-h>s :Shell<Space>
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction
augroup resCur
    au!
    au BufWinEnter * call ResCur()
augroup END
" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
function! WrapRelativeMotion(key, ...)
    let vis_sel=""
    if a:0
        let vis_sel="gv"
    endif
    if &wrap
        execute "normal!" vis_sel . "g" . a:key
    else
        execute "normal!" vis_sel . a:key
    endif
endfunction
" Clipboard
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
" Arrow Key Fix
" https://github.com/spf13/spf13-vim/issues/780
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif
" Use plugs config
if filereadable(expand("~/.vimrc.plugs"))
    source ~/.vimrc.plugs
endif
" Key (re)Mappings
" some internal key remap
map  gt <Nop>
map  gT <Nop>
map <C-s> <Nop>
map <C-q> <Nop>
map <C-z> <Nop>
nmap ! :!
let mapleader=' '
let maplocalleader = '\'
" pastetoggle (sane indentation on pastes)
set pastetoggle=<F12>
" 定义快捷键保存当前窗口内容
nnoremap <leader><Cr> :source ~/.vimrc<CR>
" Allow using the repeat operator with a visual selection (!)
vnoremap . :normal .<CR>
" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null
" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <localleader><localleader> %
" remap c-a/e , for home/end
nnoremap <Leader>, <C-X>
nnoremap <Leader>. <C-A>
nmap <C-a> ^
vmap <C-a> ^
smap <C-a> ^
imap <C-a> <Esc>I
nmap <C-e> $
vmap <C-e> $
smap <C-e> $<Left>
imap <expr><silent><C-e> pumvisible()? "\<C-e>":"\<ESC>A"
" C-f/b in insert mode
nmap <BS>  <Nop>
nmap <C-h> <Nop>
nmap <C-j> <Nop>
nmap <C-k> <Nop>
nmap <C-f> <Nop>
vmap <C-f> <Nop>
nmap <C-b> <Nop>
vmap <C-b> <Nop>
imap <C-f> <Right>
imap <C-b> <Left>
" Find merge conflict markers
nmap <C-f>c /\v^[<\|=>]{7}( .*\|$)<CR>
" and ask which one to jump to
nmap <C-f>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
nnoremap <C-x> <C-f>
nnoremap <C-y> <C-b>
" tab control
set tabpagemax=10 " Only show 10 tabs
cmap Tabe tabe
nnoremap <silent>-          :tabprevious<CR>
nnoremap <silent><Tab>      :tabnext<CR>
nnoremap <Leader>tp         :tabprevious<CR>
nnoremap <Leader>tn         :tabnext<CR>
nnoremap <leader>-          :tabm -1<CR>
nnoremap <leader><Tab>      :tabm +1<CR>
nnoremap <localleader>-     :tabfirst<CR>
nnoremap <localleader><Tab> :tablast<CR>
nnoremap <Leader>te         :tabe<Space>
nnoremap <Leader>ts         :tab  split<CR>
nnoremap <Leader>tw         :tabs<CR>
nnoremap <Leader>tm         :tabm<Space>
" buffer switch
nnoremap <localleader><Backspace> :buffers<CR>
nnoremap <localleader>]           :bn<CR>
nnoremap <localleader>[           :bp<CR>
" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <leader>y  "+y
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
nnoremap <leader>Y  "*y
vnoremap <leader>Y  "*y
nnoremap Y y$
vnoremap Y *y$
" p and P for paste
nnoremap <leader>p "+p
nnoremap <leader>P "*P
vnoremap <leader>p "+p
vnoremap <leader>P "*P
" Easier horizontal scrolling
map zl zL
map zh zH
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <silent>j gj
noremap <silent>k gk
" F1 for help
nnoremap <F1> <ESC>:tab help<Space>
inoremap <F1> <ESC>:tab help<Space>
snoremap <F1> <ESC>:tab help<Space>
vnoremap <F1> <ESC>:tab help<Space>
" F2 toggle hlsearch
nnoremap <F2> <ESC>:set nohlsearch! nohlsearch?<CR>
inoremap <F2> <ESC>:set nohlsearch! nohlsearch?<CR>
vnoremap <F2> <ESC>:set nohlsearch! nohlsearch?<CR>
snoremap <F2> <ESC>:set nohlsearch! nohlsearch?<CR>
" F3 show clipboard
nnoremap <F3> <ESC>:reg<Cr>
inoremap <F3> <ESC>:reg<Cr>
vnoremap <F3> <ESC>:reg<Cr>
snoremap <F3> <ESC>:reg<Cr>
" toggleFold
nnoremap <leader>fd :set nofoldenable! nofoldenable?<CR>
" toggleWrap
nnoremap <leader>fw :set nowrap! nowrap?<CR>
nmap <Leader>w :w<CR>
nmap <Leader>W :wq!<CR>
" Q
nnoremap ~ Q
nnoremap Q :q!<CR>
" 定义快捷键保存所有窗口内容并退出 vim
nmap <Leader>WQ :wa<CR>:q<CR>
" 定义快捷键关闭当前窗口
nmap <Leader>q :q!
" 不做任何保存，直接退出 vim
nmap <Leader>Q :qa!
" 设置分割页面
nmap <leader>\ :vsplit<Space>
nmap <leader><leader>\ :split<Space>
nmap <leader>= <C-W>=
"设置垂直高度减增
nmap <Leader><Down>  :resize -3<CR>
nmap <Leader><Up>    :resize +3<CR>
"设置水平宽度减增
nmap <Leader><Left>  :vertical resize -3<CR>
nmap <Leader><Right> :vertical resize +3<CR>
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>
"离开插入模式后关闭预览窗口
au InsertLeave * if pumvisible() == 0|pclose|endif
" auto close qfixwindows when leave vim
aug QFClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END
" Formatting
set autoindent                  " Indent at the same level of the previous line
set nojoinspaces                " Prevents inserting two Spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
" 不生成back文件
set nobackup
"set noswapfile
set nowritebackup
"set noundofile
" 关闭拼写检查
set nospell
" 关闭声音
set noeb
set vb
" 列光标加亮
set nocursorcolumn
" 光标加亮
set cursorline
" 允许折行
set wrap
" 不折叠
set nofoldenable
" 标签控制
set showtabline=2
" 开启实时搜索功能
set incsearch
" 显示行号
set number
" 在help里显示行号
autocmd FileType help setlocal number
" 显示光标当前位置
set ruler
" 高亮显示搜索结果
set hlsearch
set incsearch                   " Find as you type search
set smartcase                   " Case sensitive when uc present
set ignorecase                  " Case insensitive search
" 一些格式
set backspace=indent,eol,start  " BackSpace for dummies
set linespace=0                 " No extra Spaces between rows
set showmatch                   " Show matching brackets/parenthesis
set winminheight=0              " Windows can be 0 line high
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " BackSpace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set shiftwidth=4                " Use indents of 4 Spaces
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backSpace delete indent
set expandtab                   " Tabs are Spaces, not tabs
set autoindent
" 没有滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 没有菜单和工具条
set guioptions-=m
set guioptions-=T
" sepcial setting for different type of files
au BufNewFile,BufRead *.py
    \ set foldmethod=indent
au FileType python au BufWritePost <buffer> :%retab
" yaml
au FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
" Remove trailing whiteSpaces and ^M chars
au FileType markdown,vim,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql au BufWritePre <buffer>  call StripTrailingWhiteSpace()
au BufNewFile,BufRead *.html.twig set filetype=html.twig
au BufNewFile,BufRead *.md,*.markdown,README set filetype=markdown
au BufNewFile,BufRead *.pandoc set filetype=pandoc
" preceding line best in a plugin but here for now.
au BufNewFile,BufRead *.coffee set filetype=coffee
" Workaround vim-commentary for Haskell
au FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
au FileType haskell,rust setlocal nospell
" General
au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" Map g* keys in Normal, Operator-pending, and Visual+select
noremap $ :call WrapRelativeMotion("$")<CR>
noremap 0 :call WrapRelativeMotion("0")<CR>
noremap ^ :call WrapRelativeMotion("^")<CR>
" Overwrite the operator pending $/<End> mappings from above
" to force inclusive motion with :execute normal!
onoremap $ v:call WrapRelativeMotion("$")<CR>
onoremap <End> v:call WrapRelativeMotion("$")<CR>
" Overwrite the Visual+select mode mappings from above
" to ensuwe the correct vis_sel flag is passed to function
vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap <Home> :<C-U>call WrapRelativeMotion("^", 1)<CR>
vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
" Stupid shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif
" Plugins, if vim-plug works
if (has('job') || python_version || has('nvim') || has('lua'))
    function! HasDirectory(dir)
        return isdirectory(expand($PLUG_PATH."/".a:dir))
    endfunction
    " vim-fullscreen
    if HasDirectory("vim_fullscreen")
        let g:fullscreen#enable_default_keymap = 1
        if has('nvim')
            let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
            let g:fullscreen#stop_command  = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"
        endif
        nmap <silent><F11> :FullscreenToggle<cr>
        imap <silent><F11> <Esc>:FullscreenToggle<cr>
        smap <silent><F11> <Esc>:FullscreenToggle<cr>
        vmap <silent><F11> <Esc>:FullscreenToggle<cr>
    endif
    " markdown preview for gvim
    if has("gui_running") && HasDirectory('markdown-preview.vim')
        let g:vim_markdown_folding_disabled = 1
        let g:vim_markdown_no_default_key_mappings = 1
        let g:vim_markdown_preview_started = 0
        au FileType markdown nmap <silent> <C-z> <Plug>MarkdownPreview
        au FileType markdown vmap <silent> <C-z> <Plug>MarkdownPreview
        au FileType markdown nmap <silent> <C-s> <Plug>StopMarkdownPreview
        au FileType markdown vmap <silent> <C-s> <Plug>StopMarkdownPreview
        au FileType markdown nmap <silent> <C-q> <Plug>Markdown_OpenUrlUnderCursor
        au FileType markdown vmap <silent> <C-q> <Plug>Markdown_OpenUrlUnderCursor
        au FileType markdown imap <silent> <C-q> <Plug>Markdown_EditUrlUnderCursor
        au FileType markdown nmap ]] <Plug>Markdown_MoveToNextHeader
        au FileType markdown nmap [[ <Plug>Markdown_MoveToPreviousHeader
        au FileType markdown nmap ][ <Plug>Markdown_MoveToNextSiblingHeader
        au FileType markdown nmap [] <Plug>Markdown_MoveToPreviousSiblingHeader
        au FileType markdown nmap ]c <Plug>Markdown_MoveToCurHeader
        au FileType markdown nmap ]u <Plug>Markdown_MoveToParentHeader
        let g:vim_markdown_folding_style_pythonic = 1
        let g:vim_markdown_override_foldtext = 0
        let g:vim_markdown_toc_autofit = 1
        let g:vim_markdown_emphasis_multiline = 0
        let g:vim_markdown_conceal = 0
        let g:vim_markdown_math = 1
        let g:vim_markdown_frontmatter = 1
        let g:vim_markdown_auto_insert_bullets = 0
        let g:vim_markdown_new_list_item_indent = 0
        if v:version >= 704
            let g:vmt_auto_update_on_save = 1
            let g:vmt_cycle_list_item_markers = 1
        endif
    endif
    " autopairs
    if HasDirectory("auto-pairs")
        let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`'}
        let g:AutoPairsShortcutToggle     = "<C-b>t"
        let g:AutoPairsShortcutFastWrap   = "<C-b>f"
        let g:AutoPairsShortcutJump       = "<C-b>j"
        let g:AutoPairsShortcutBackInsert = "<C-b>i"
        inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>
    endif
    " fugitive
    if HasDirectory("vim-fugitive")
        nnoremap + :Git<Space>
        nnoremap gc :Gcommit -a -v<CR>
    endif
    " startify
    if HasDirectory("vim-startify")
        let g:startify_custom_header = [
            \ '+---------------------------------------------------------+',
            \ '|  Welcome to use leoatchina vim config forked from spf13 |',
            \ '|                                                         |',
            \ '|  https://github.com/leoatchina/leoatchina-vim           |',
            \ '|                                                         |',
            \ '|  https://github.com/spf13/spf13-vim                     |',
            \ '+---------------------------------------------------------+',
            \ ]
        let g:startify_session_dir = '~/.vim/session'
        let g:startify_files_number = 5
        let g:startify_session_number = 5
        let g:startify_list_order = [
            \ ['   最近项目:'],
            \ 'sessions',
            \ ['   最近文件:'],
            \ 'files',
            \ ['   快捷命令:'],
            \ 'commands',
            \ ['   常用书签:'],
            \ 'bookmarks',
            \ ]
        let g:startify_commands = [
            \ {'r': ['说明', '!vim -p ~/.vimrc.md']},
            \ {'h': ['帮助', 'help howto']},
            \ {'v': ['版本', 'version']}
            \ ]
    endif
    " themes
    if HasDirectory("/vim-colorschemes-collections")
        " dark theme
        set background=dark
        " 总是显示状态栏
        set laststatus=2
        if has('nvim')
            if has("gui_running")
                colorscheme onedark
            else
                set t_Co=256
                colorscheme wombat256mod
            endif
        elseif has('gui_running')
            colorscheme hybrid_material
        else
            set t_Co=256
            colorscheme gruvbox
        endif
    endif
    " bufferline
    if HasDirectory("vim-bufferline")
        let g:bufferline_show_bufnr = 0
        let g:bufferline_rotate = 1
        let g:bufferline_fixed_index =  0
    endif
    " statusline
    if HasDirectory('vim-airline')
        let g:airline_powerline_fonts = 0
        let g:airline_symbols_ascii = 1
        let g:airline_exclude_preview = 0
        let g:airline_highlighting_cache = 1
        let g:airline#extensions#whiteSpace#enabled = 0
        " tab序号
        let g:airline#extensions#tabline#tab_nr_type = 1
        let g:airline#extensions#tabline#enabled = 1
        " disable buffers on topright
        let g:airline#extensions#tabline#tabs_label = ''
        let g:airline#extensions#tabline#show_splits = 0
        let g:airline#extensions#tabline#show_close_button = 0
        let g:airline#extensions#tabline#buffer_nr_show = 0
        " shw full_path of the file
        let g:airline_section_c = "\ %F"
        if !exists('g:airline_symbols')
            let g:airline_symbols = {}
            let g:airline_symbols.crypt = '🔒'
            let g:airline_symbols.linenr = '☰'
            let g:airline_symbols.maxlinenr = ''
            let g:airline_symbols.branch = '⎇'
            let g:airline_symbols.paste = 'ρ'
            let g:airline_symbols.notexists = '∄'
            let g:airline_symbols.whiteSpace = 'Ξ'
            let g:airline_left_sep = '▶'
            let g:airline_left_alt_sep = '❯'
            let g:airline_right_sep = '◀'
            let g:airline_right_alt_sep = '❮'
        endif
    elseif has('statusline')
        if HasDirectory("lightline.vim")
            let g:lightline = {
                \ 'colorscheme': 'onedark',
                \ 'active': {
                \  'left': [ [ 'mode', 'paste' ],
                \     [ 'gitbranch', 'readonly' ],
                \     [ 'filefullpath', 'modified' ]],
                \  'right': [
                \     [ 'percent' ],
                \     [ 'filetype', 'fileformat', 'fileencoding' , 'lineinfo']]
                \ },
                \ 'inactive' : {
                \   'left': [ [ 'mode', 'paste' ],[ 'filefullpath' ] ],
                \   'right': [ [ 'lineinfo' ], [ 'percent' ] ] },
                \ 'component': {
                \  'filefullpath': '%F',
                \  'lineinfo': '%l/%L : %c',
                \ },
                \ 'component_function': {
                \  'gitbranch': 'fugitive#head',
                \  'readonly': 'LightlineReadonly',
                \ },
            \ }
            function! LightlineReadonly()
                return &readonly && &filetype !=# 'help' ? 'RO' : ''
            endfunction
            if HasDirectory("ale")
                let g:lightline.active.right = [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
                    \  [ 'percent' ],
                    \  [ 'filetype', 'fileformat', 'fileencoding', 'lineinfo']]
                let g:lightline.component_expand =  {
                    \  'linter_checking': 'lightline#ale#checking',
                    \  'linter_warnings': 'lightline#ale#warnings',
                    \  'linter_errors': 'lightline#ale#errors',
                    \  'linter_ok': 'lightline#ale#ok'
                    \ }
                let g:lightline.component_type = {
                    \  'linter_checking': 'right',
                    \  'linter_warnings': 'warning',
                    \  'linter_errors': 'error',
                    \  'linter_ok': 'left'
                    \ }
            endif
        else
            set statusline=%1*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
            set statusline+=%2*\ %F\ %*
            set statusline+=%3*\ \ %m%r%y\ %*
            set statusline+=%=%4*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-14.(%l\/%L\ %c%)%*
            set statusline+=%5*\ %P\ %<
            " default bg for statusline is 236 in space-vim-dark
            hi User1 cterm=bold ctermfg=232 ctermbg=179
            hi User2 cterm=bold ctermfg=255 ctermbg=100
            hi User3 cterm=None ctermfg=208 ctermbg=238
            hi User4 cterm=None ctermfg=246 ctermbg=237
            hi User5 cterm=None ctermfg=250 ctermbg=238
        endif
    endif
    " ctags
    if HasDirectory("tagbar")
        let g:tagbar_sort = 0
        set tags=./tags;/,~/.cache/tags
        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
        nmap <silent><leader>tt :TagbarToggle<CR>
        nmap <silent><leader>tj :TagbarOpen j<CR>
        " AutoCloseTag
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
            \ nmap <Leader>ta <Plug>ToggleAutoCloseMappings
        if HasDirectory("vim-gutentags")
            set tags=./.tags;,.tags
            " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
            let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
            " 所生成的数据文件的名称
            let g:gutentags_ctags_tagfile = '.tags'
            " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
            let s:vim_tags = expand("~/.cache/tags")
            let g:gutentags_cache_dir = s:vim_tags
            " 配置 ctags 的参数
            let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
            let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
            let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
            " 检测 ~/.cache/tags 不存在就新建
            if !isdirectory(s:vim_tags)
                silent! call mkdir(s:vim_tags, 'p')
            endif
        endif
    endif
    " indent_guides
    if HasDirectory("vim-indent-guides")
        let g:indent_guides_enable_on_vim_startup = 1
        let g:indent_guides_start_level           = 2
        let g:indent_guides_guide_size            = 1
        hi IndentGuidesOdd  ctermbg=black
        hi IndentGuidesEven ctermbg=darkgrey
    endif
    " conflict-marker
    if HasDirectory("conflict-marker.vim")
        let g:conflict_marker_enable_mappings = 1
    endif
    " multiple-cursors
    if HasDirectory("vim-multiple-cursors")
        let g:multi_cursor_use_default_mapping=0
        let g:multi_cursor_start_word_key      = '<C-n>'
        let g:multi_cursor_select_all_word_key = '<leader><C-n>'
        let g:multi_cursor_start_key           = 'g<C-n>'
        let g:multi_cursor_select_all_key      = '<localleader><C-n>'
        let g:multi_cursor_next_key            = '<C-n>'
        let g:multi_cursor_prev_key            = '<C-\>'
        let g:multi_cursor_skip_key            = '<C-h>'
        let g:multi_cursor_quit_key            = '<ESC>'
        highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
        highlight link multiple_cursors_visual Visual
        function! Multiple_cursors_before()
            if exists(':NeoCompleteLock') == 2
                exe 'NeoCompleteLock'
            endif
        endfunction
        function! Multiple_cursors_after()
            if exists(':NeoCompleteUnlock') == 2
                exe 'NeoCompleteUnlock'
            endif
        endfunction
    endif
    " NerdTree
    if HasDirectory("nerdtree")
        nmap <leader>nn :NERDTreeTabsToggle<CR>
        nmap <leader>nf :NERDTreeFind<CR>
        let g:NERDShutUp                            = 1
        let s:has_nerdtree                          = 1
        let g:nerdtree_tabs_open_on_gui_startup     = 0
        let g:nerdtree_tabs_open_on_console_startup = 0
        let g:nerdtree_tabs_smart_startup_focus     = 2
        let g:nerdtree_tabs_focus_on_files          = 1
        let g:NERDTreeWinSize                       = 30
        let g:NERDTreeShowBookmarks                 =1
        let g:nerdtree_tabs_smart_startup_focus     = 0
        let g:NERDTreeIgnore = ['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let g:NERDTreeChDirMode                 =0
        let g:NERDTreeQuitOnOpen                =1
        let g:NERDTreeMouseMode                 =2
        let g:NERDTreeShowHidden                =1
        let g:NERDTreeKeepTreeInNewTab          =1
        let g:nerdtree_tabs_focus_on_files      = 1
        let g:nerdtree_tabs_open_on_gui_startup = 0
        let g:NERDTreeWinPos                    =0
        let g:NERDTreeDirArrowExpandable        = '▸'
        let g:NERDTreeDirArrowCollapsible       = '▾'
        au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
        " nerdtree-git
        if HasDirectory("nerdtree-git-plugin")
            let g:NERDTreeIndicatorMapCustom = {
                \ "Modified"  : "*",
                \ "Staged"    : "+",
                \ "Untracked" : "★",
                \ "Renamed"   : "→ ",
                \ "Unmerged"  : "=",
                \ "Deleted"   : "X",
                \ "Dirty"     : "●",
                \ "Clean"     : "√",
                \ "Unknown"   : "?"
                \ }
        endif
    endif
    " ywvim,vim里的中文输入法
    if HasDirectory("ywvim")
        set showmode
        if count(g:plug_groups, 'pinyin')
            let g:ywvim_ims=[
                    \['py', '拼音', 'pinyin.ywvim'],
                    \['wb', '五笔', 'wubi.ywvim'],
                \]
        elseif count(g:plug_groups, 'wubi')
            let g:ywvim_ims=[
                    \['wb', '五笔', 'wubi.ywvim'],
                    \['py', '拼音', 'pinyin.ywvim'],
                \]
        endif
        let g:ywvim_py               = { 'helpim':'wb', 'gb':0 }
        let g:ywvim_zhpunc           = 0
        let g:ywvim_listmax          = 8
        let g:ywvim_esc_autoff       = 1
        let g:ywvim_autoinput        = 2
        let g:ywvim_circlecandidates = 1
        let g:ywvim_helpim_on        = 0
        let g:ywvim_matchexact       = 0
        let g:ywvim_chinesecode      = 1
        let g:ywvim_gb               = 0
        let g:ywvim_preconv          = 'g2b'
        let g:ywvim_conv             = ''
        let g:ywvim_lockb            = 1
        imap <silent> <C-\> <C-R>=Ywvim_toggle()<CR>
        cmap <silent> <C-\> <C-R>=Ywvim_toggle()<CR>
    else
        set noshowmode
    endif
    " search tools
    if HasDirectory('FlyGrep.vim')
        nmap <C-f><C-f> :FlyGrep<Cr>
    endif
    if HasDirectory('ctrlsf.vim')
        let g:ctrlsf_position='right'
        nmap <C-F>s <Plug>CtrlSFPrompt
        nmap <C-F>c <Plug>CtrlSFCwordPath
        nmap <C-F>p <Plug>CtrlSFPwordPath
        nmap <C-F>o :CtrlSFOpen<CR>
        nmap <C-F>t :CtrlSFToggle<CR>
        " vmap
        vmap <C-F>s <Plug>CtrlSFVwordExec
        vmap <C-F>f <Plug>CtrlSFVwordPath
    elseif HasDirectory('vim-finder')
        nnoremap <C-f>s :finder<Space>
    else
        nnoremap <C-f>s :vimgrep<Space>
    endif
    " Shell
    if has('terminal') || has('nvim')
        tnoremap <C-[> <C-\><C-n>
        tnoremap <ESC> <C-\><C-n>
        tnoremap <C-w>h <C-\><C-N><C-w>h
        tnoremap <C-w>j <C-\><C-N><C-w>j
        tnoremap <C-w>k <C-\><C-N><C-w>k
        tnoremap <C-w>l <C-\><C-N><C-w>l
        tnoremap <C-w><right> <C-\><C-N><C-w><right>
        tnoremap <C-w><left>  <C-\><C-N><C-w><left>
        tnoremap <C-w><down>  <C-\><C-N><C-w><down>
        tnoremap <C-w><up>    <C-\><C-N><C-w><up>
        if has('nvim')
            tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
            nmap <C-h>v :vsplit term://bash<Cr>i
            nmap <C-h>h :split  term://bash<Cr>i
            nmap <C-h>t :tabe   term://bash<Cr>i
            nmap <C-h>V :vsplit term://
            nmap <C-h>H :split  term://
            nmap <C-h>T :tabe   term://
        else
            nmap <C-h>v :vertical terminal<cr>bash<cr>
            nmap <C-h>h :terminal<cr>bash<cr>
            nmap <C-h>t :tab terminal<Cr>bash<Cr>
            nmap <C-h>V :vertical terminal
            nmap <C-h>H :terminal
            nmap <C-h>T :tab terminal
        endif
    endif
    " easy-align
    if HasDirectory("vim-easy-align")
        nmap <localleader><Cr> <Plug>(EasyAlign)
        vmap <Cr> <Plug>(EasyAlign)
        if !exists('g:easy_align_delimiters')
            let g:easy_align_delimiters = {}
        endif
        let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
    endif
    if HasDirectory("vim-easymotion")
        nmap <C-j><C-j> <Plug>(easymotion-w)
        nmap <C-k><C-k> <Plug>(easymotion-b)
    endif
    " Go program
    if isdirectory(expand($PLUG_PATH."vim-go"))
        let g:go_highlight_functions         = 1
        let g:go_highlight_methods           = 1
        let g:go_highlight_structs           = 1
        let g:go_highlight_operators         = 1
        let g:go_highlight_build_constraints = 1
        let g:go_fmt_command                 = "gofmt"
        let g:syntastic_go_checkers          = ['golint', 'govet', 'errcheck']
        let g:syntastic_mode_map             = { 'mode': 'active', 'passive_filetypes': ['go'] }
        au FileType go imap <C-b>     <C-x><C-o>
        au FileType go nmap <Leader>i <Plug>(go-implements)
        au FileType go nmap <Leader>I <Plug>(go-info)
        au FileType go nmap <Leader>r <Plug>(go-rename)
        au FileType go nmap <leader>R <Plug>(go-run)
        au FileType go nmap <leader>b <Plug>(go-build)
        au FileType go nmap <leader>t <Plug>(go-test)
        au FileType go nmap <Leader>d <Plug>(go-doc)
        au FileType go nmap <Leader>v <Plug>(go-doc-vertical)
        au FileType go nmap <leader>c <Plug>(go-coverage)
    endif
    " PyMode
    if HasDirectory("python-mode")
        " python version
        if g:python_version     == 3
            let g:pymode_python  = 'python3'
        else
            let g:pymode_python  = 'python'
        endif
        let g:pymode_syntax = 0
        let g:pymode_syntax_all = 0
        " disable pymode_rope and pymode_folding for slow problem
        let g:pymode_rope             = 0
        let g:pymode_folding          = 0
        let g:pymode_trim_whiteSpaces = 0
        let g:pymode_options          = 0
        " doc for python
        let g:pymode_doc              = 1
        " motion
        let g:pymode_motion           = 1
        " run python
        let g:pymode_run_bind         = '<leader>R'
        " breakpoint
        let g:pymode_breakpoint       = 1
        let g:pymode_breakpoint_bind  = '<BS>'
        let g:pymode_breakpoint_cmd   = 'import pdb;pdb.set_trace()'
        " pymode check disable
        if count(g:plug_groups, 'syntax')
            let g:pymode_lint = 0
            let g:pymode_rope_goto_definition_bind = '<Nop>'
        else
            nmap <C-l><C-l> :PymodeLint<CR>
            let g:pymode_rope_goto_definition_bind = 'gd'
            let g:pymode_lint            = 1
            let g:pymode_lint_signs      = 1
            " no check when write
            let g:pymode_lint_on_write   = 0
            " check when save
            let g:pymode_lint_unmodified = 0
            " not check of fly
            let g:pymode_lint_on_fly     = 0
            " show message of error line
            let g:pymode_lint_message    = 1
            " checkers
            let g:pymode_lint_checkers   = ['pyflakes', 'pep8']
            let g:pymode_lint_ignore     = "E128,E2,E3,E501"
            " not Auto open cwindow (quickfix) if any errors have been found
            let g:pymode_lint_cwindow    = 0
        endif
    endif
    " browser seris
    if g:browser_tool == 'fzf' && HasDirectory("fzf.vim")
        nnoremap <silent>   <C-p>      :FZF<CR>
        nnoremap <silent>   <leader>lb :Buffers<CR>
        nnoremap <Leader>lf :FZF<Space>
        nnoremap <silent>   <Leader>lt :Filetypes<CR>
        nnoremap <silent>   <Leader>lg :GFiles?<CR>
        nnoremap <silent>   <Leader>lm :Maps<CR>
        nnoremap <silent>   <Leader>lc :Commits<CR>
        nnoremap <silent>   <Leader>lk :Colors<CR>
        nnoremap <silent>   <Leader>lh :History/<CR>
        " Mapping selecting mappings
        nmap <leader><tab> <plug>(fzf-maps-n)
        xmap <leader><tab> <plug>(fzf-maps-x)
        omap <leader><tab> <plug>(fzf-maps-o)
        " insert map
        imap <c-x><c-k> <plug>(fzf-complete-word)
        imap <c-x><c-f> <plug>(fzf-complete-path)
        imap <c-x><c-j> <plug>(fzf-complete-file-ag)
        imap <c-x><c-l> <plug>(fzf-complete-line)
        " [Buffers] Jump to the existing window if possible
        let g:fzf_buffers_jump = 1
        " [[B]Commits] Customize the options used by 'git log':
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
        " [Tags] Command to generate tags file
        let g:fzf_tags_command = 'ctags -R'
        " [Commands] --expect expression for directly executing the command
        let g:fzf_commands_expect = 'alt-enter,ctrl-x'
        let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
              \ 'bg':      ['bg', 'Normal'],
              \ 'hl':      ['fg', 'Comment'],
              \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
              \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
              \ 'hl+':     ['fg', 'Statement'],
              \ 'info':    ['fg', 'PreProc'],
              \ 'border':  ['fg', 'Ignore'],
              \ 'prompt':  ['fg', 'Conditional'],
              \ 'pointer': ['fg', 'Exception'],
              \ 'marker':  ['fg', 'Keyword'],
              \ 'spinner': ['fg', 'Label'],
              \ 'header':  ['fg', 'Comment'] }
        if has('nvim')
            let g:fzf_layout = { 'window': '10split enew' }
        else
            let g:fzf_layout = { 'down': '~40%' }
        endif
        function! s:build_quickfix_list(lines)
            call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
            copen
            cc
        endfunction
        let g:fzf_action = {
            \ 'ctrl-q': function('s:build_quickfix_list'),
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit'}
    elseif g:browser_tool == 'denite' && HasDirectory("denite.nvim")
        nnoremap <C-p> :Denite file/rec buffer<Cr>
        nnoremap <leader>lf :Denite
        nnoremap <leader>lb :DeniteBufferDir
        nnoremap <leader>lw :DeniteCursorWord
        nnoremap <Leader>/ :call denite#start([{'name': 'grep', 'args': ['', '', '!']}])<cr>
        call denite#custom#option('_', {
                \ 'prompt': 'λ:',
                \ 'empty': 0,
                \ 'winheight': 16,
                \ 'source_names': 'short',
                \ 'vertical_preview': 1,
                \ 'auto-accel': 1,
                \ 'auto-resume': 1,
            \ })
        call denite#custom#option('list', {})
        call denite#custom#option('mpc', {
                \ 'quit': 0,
                \ 'mode': 'normal',
                \ 'winheight': 20,
            \ })
        " MATCHERS
        " Default is 'matcher_fuzzy'
        call denite#custom#source('tag', 'matchers', ['matcher_substring'])
        if has('nvim') && &runtimepath =~# '\/cpsm'
            call denite#custom#source(
                \ 'buffer,file_mru,file_old,file_rec,grep,mpc,line',
                \ 'matchers', ['matcher_cpsm', 'matcher_fuzzy'])
        endif
        " SORTERS
        " Default is 'sorter_rank'
        call denite#custom#source('z', 'sorters', ['sorter_z'])
        " CONVERTERS
        " Default is none
        call denite#custom#source(
            \ 'buffer,file_mru,file_old',
            \ 'converters', ['converter_relative_word'])
        " FIND and GREP COMMANDS
        if executable('ag')
            " The Silver Searcher
            call denite#custom#var('file_rec', 'command',
                \ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])
            " Setup ignore patterns in your .agignore file!
            " https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage
            call denite#custom#var('grep', 'command', ['ag'])
            call denite#custom#var('grep', 'recursive_opts', [])
            call denite#custom#var('grep', 'pattern_opt', [])
            call denite#custom#var('grep', 'separator', ['--'])
            call denite#custom#var('grep', 'final_opts', [])
            call denite#custom#var('grep', 'default_opts',
                \ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])
        elseif executable('ack')
            " Ack command
            call denite#custom#var('grep', 'command', ['ack'])
            call denite#custom#var('grep', 'recursive_opts', [])
            call denite#custom#var('grep', 'pattern_opt', ['--match'])
            call denite#custom#var('grep', 'separator', ['--'])
            call denite#custom#var('grep', 'final_opts', [])
            call denite#custom#var('grep', 'default_opts',
                \ ['--ackrc', $HOME.'/.config/ackrc', '-H',
                \ '--nopager', '--nocolor', '--nogroup', '--column'])
        endif
        " KEY MAPPINGS
        let insert_mode_mappings = [
                \  ['<C-c>', '<denite:enter_mode:normal>', 'noremap'],
                \  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
                \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
                \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
                \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
                \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
                \  ['<C-Y>', '<denite:redraw>', 'noremap'],
            \ ]
        let normal_mode_mappings = [
                \   ["'", '<denite:toggle_select_down>', 'noremap'],
                \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
                \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
                \   ['gg', '<denite:move_to_first_line>', 'noremap'],
                \   ['st', '<denite:do_action:tabopen>', 'noremap'],
                \   ['vs', '<denite:do_action:vsplit>', 'noremap'],
                \   ['sv', '<denite:do_action:split>', 'noremap'],
                \   ['qt', '<denite:quit>', 'noremap'],
                \   ['r', '<denite:redraw>', 'noremap'],
            \ ]
        for m in insert_mode_mappings
            call denite#custom#map('insert', m[0], m[1], m[2])
        endfor
        for m in normal_mode_mappings
            call denite#custom#map('normal', m[0], m[1], m[2])
        endfor
    elseif g:browser_tool == "LeaderF" && HasDirectory("LeaderF")
        let g:Lf_ShortcutF = '<C-p>'
        let g:Lf_PythonVersion = g:python_version
        let g:Lf_ShortcutB = '<leader>B'
        nmap <leader>lf :Leaderf
        nmap <leader>lF :LeaderfF
        nmap <leader>lb :LeaderfB
        nmap <leader>lm :LeaderfM
    elseif HasDirectory("ctrlp.vim")
        let g:ctrlp_map = '<C-p>'
        let g:ctrlp_cmd = 'CtrlP'
        let g:ctrlp_working_path_mode = 'ar'
        let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
        if executable('ag')
            let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
        elseif executable('ack-grep')
            let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
        elseif executable('ack')
            let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
        elseif WINDOWS()
            let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
        else
            let s:ctrlp_fallback = 'find %s -type f'
        endif
        if exists("g:ctrlp_user_command")
            unlet g:ctrlp_user_command
        endif
        let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }
        if HasDirectory("ctrlp-funky")
            " CtrlP extensions
            let g:ctrlp_extensions = ['funky']
            " funky
            nnoremap <Leader>lf :CtrlPFunky<Cr>
        endif
        nnoremap <leader>lm :CtrlPMRU<CR>
    endif
    " UndoTree
    if HasDirectory("undotree")
        nnoremap <silent><leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle = 0
        if has("persistent_undo")
            set undodir=~/.vim/undodir/
            set undofile
        endif
    endif
    " complete_engine && complete_snippet
    set completeopt-=menu
    set completeopt-=preview
    set completeopt+=menuone
    " ominifuc
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    if HasDirectory("deoplete.nvim")
        set shortmess+=c
        set completeopt+=noinsert,noselect
        let g:deoplete#enable_at_startup = 1
        " <BS>: close popup and delete backword char.
        inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
        if !has('nvim')
            let g:deoplete#enable_yarp = 1
        endif
        let g:deoplete#enable_camel_case = 1
        " Enable heavy omni completion.
        if !exists('g:deoplete#keyword_patterns')
            let g:deoplete#keyword_patterns = {}
        endif
        call deoplete#custom#option('omni_patterns', {
            \ 'java' : '[^. *\t]\.\w*',
            \ 'php'  : '[^. \t]->\h\w*\|\h\w*::',
            \ 'perl' : '\h\w*->\h\w*\|\h\w*::',
            \ 'c'    : '[^.[:digit:] *\t]\%(\.\|->\)',
            \ 'cpp'  : '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
            \ 'ruby' : '[^. *\t]\.\h\w*\|\h\w*::',
            \ 'go'   : '\h\w*\.\?',
        \})
        if HasDirectory('ultisnips')
            call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
        endif
    elseif HasDirectory("completor.vim")
        set shortmess+=c
        set completeopt+=noinsert,noselect
        let g:completor_set_options = 0
        let g:completor_auto_trigger = 1
    elseif HasDirectory("YouCompleteMe")
        set shortmess+=c
        set completeopt+=noinsert,noselect
        if g:python_version == 2
            let g:ycm_python_binary_path = 'python'
        else
            let g:ycm_python_binary_path = 'python3'
        endif
        " add_preview
        let g:ycm_add_preview_to_completeopt = 1
        "  补全后close窗口
        let g:ycm_autoclose_preview_window_after_completion = 1
        "  插入后close窗口
        let g:ycm_autoclose_preview_window_after_insertion = 1
        " enable completion from tags
        let g:ycm_collect_identifiers_from_tags_files = 1
        let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
        let g:ycm_key_list_previous_completion = ['<C-p', '<Up>']
        let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'nerdtree' : 1,
        \}
        let g:ycm_semantic_triggers =  {
            \ 'c' : ['->', '.'],
            \ 'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s', 're!\[.*\]\s'],
            \ 'ocaml' : ['.', '#'],
            \ 'cpp,cuda,objcpp' : ['->', '.', '::'],
            \ 'perl' : ['->'],
            \ 'php' : ['->', '::'],
            \ 'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
            \ 'ruby' : ['.', '::'],
            \ 'lua' : ['.', ':'],
            \ 'erlang' : [':'],
        \ }
        let g:ycm_confirm_extra_conf = 1 "加载.ycm_extra_conf.py提示
        let g:ycm_global_ycm_extra_conf = $PLUG_PATH."/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
        let g:ycm_key_invoke_completion = ''
        let g:ycm_collect_identifiers_from_tags_files = 1    " 开启 YC基于标签引擎
        let g:ycm_min_num_of_chars_for_completion = 2   " 从第2个键入字符就开始罗列匹配项
        let g:ycm_seed_identifiers_with_syntax = 1   " 语法关键字补全
        let g:ycm_complete_in_comments = 0
        let g:ycm_complete_in_strings = 1
        let g:ycm_collect_identifiers_from_comments_and_strings = 0
        " 跳转到定义处
        nnoremap go :YcmCompleter GoToDefinitionElseDeclaration<CR>
    elseif HasDirectory("ncm2")
        set shortmess+=c
        set completeopt+=noinsert,noselect
        autocmd BufEnter * call ncm2#enable_for_buffer()
        au User Ncm2Plugin call ncm2#register_source({
            \ 'name' : 'css',
            \ 'enable' : 1,
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css','scss'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS']
            \ })
    elseif HasDirectory("asyncomplete.vim")
        set shortmess+=c
        set completeopt+=noinsert,noselect
        let g:asyncomplete_auto_popup = 1
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
            \ 'name': 'buffer',
            \ 'whitelist': ['*'],
            \ 'blacklist': ['go'],
            \ 'completor': function('asyncomplete#sources#buffer#completor'),
            \ }))
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
            \ 'name': 'file',
            \ 'whitelist': ['*'],
            \ 'priority': 10,
            \ 'completor': function('asyncomplete#sources#file#completor')
            \ }))
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
            \ 'name': 'omni',
            \ 'whitelist': ['*'],
            \ 'blacklist': ['c', 'cpp', 'html'],
            \ 'completor': function('asyncomplete#sources#omni#completor')
            \  }))
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
            \ 'name': 'necosyntax',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
            \ }))
        if executable('pyls')
            au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
                \ })
        endif
        if count(g:plug_groups, 'go')
            au User asyncomplete_setup  call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
                \ 'name': 'gocode',
                \ 'whitelist': ['go'],
                \ 'completor': function('asyncomplete#sources#gocode#completor'),
                \ }))
        endif
        if count(g:plug_groups, 'rust')
            autocmd User asyncomplete_setup call asyncomplete#register_source(
                \ asyncomplete#sources#racer#get_source_options())
        endif
        if HasDirectory("asyncomplete-ultisnips.vim")
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                \ 'name': 'ultisnips',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#ultisnips#completor')
                \ }))
        elseif HasDirectory("asyncomplete-neosnippet.vim")
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
                \ 'name': 'neosnippet',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#neosnippet#completor')
                \ }))
        endif
    elseif HasDirectory("neocomplete.vim")
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_auto_select = 0
        let g:neocomplete#enable_camel_case = 1
        let g:neocomplete#enable_auto_delimiter = 0
        let g:neocomplete#force_overwrite_completefunc = 1
        " <BS>: close popup and delete backword char.
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        " Enable heavy omni completion.
        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns.java = '[^. \t]\.\w*'
        let g:neocomplete#force_omni_input_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplete#force_omni_input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplete#force_omni_input_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplete#force_omni_input_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
        let g:neocomplete#force_omni_input_patterns.go   = '\h\w*\.\?'
    elseif HasDirectory("neocomplcache.vim")
        let g:neocomplcache_enable_insert_char_pre       = 1
        let g:neocomplcache_enable_at_startup            = 1
        let g:neocomplcache_enable_auto_select           = 0
        let g:neocomplcache_enable_camel_case_completion = 1
        let g:neocomplcache_enable_smart_case            = 1
        let g:neocomplcache_enable_auto_delimiter        = 0
        let g:neocomplcache_force_overwrite_completefunc = 1
        " <BS>: close popup and delete backword char.
        inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
        " Enable heavy omni completion.
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
        let g:neocomplcache_omni_patterns.java = '[^. \t]\.\w*'
        let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.c    = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplcache_omni_patterns.cpp  = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.go   = '\h\w*\.\?'
    endif
    " smart completion use neosnippet to expand
    if g:complete_engine !="None"
        " headache confict
        if g:complete_engine == "YCM" || g:complete_engine == "asyncomplete"
            imap <expr><Cr>  pumvisible()? "\<C-[>a":"\<CR>"
            imap <expr><C-j> pumvisible()? "\<C-[>a":"\<CR>"
        else
            imap <expr><Cr>  pumvisible()? "\<C-y>":"\<CR>"
            imap <expr><C-j> pumvisible()? "\<C-y>":"\<CR>"
        endif
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>"                  : "\<Up>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>"                  : "\<Down>"
        inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>"   : "\<PageUp>"
        inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-n>\<C-p>" : "\<PageDown>"
        " ultisnip
        if HasDirectory('ultisnip')
            " remap Ultisnips for compatibility
            let g:UltiSnipsNoPythonWarning = 0
            let g:UltiSnipsListSnippets = "<C-l>"
            let g:UltiSnipsJumpForwardTrigger = '<C-f>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-b>'
            " Ulti python version
            let g:UltiSnipsUsePythonVersion = g:python_version
            " tab for ExpandTrigger
            function! g:UltiSnips_Tab()
                if pumvisible()
                    call UltiSnips#ExpandSnippet()
                    if g:ulti_expand_res
                        return "\<Right>"
                    else
                        if empty(v:completed_item) || !len(get(v:completed_item,'menu'))
                            return "\<C-n>"
                        else
                            return "\<C-y>"
                        endif
                    endif
                else
                    return "\<Tab>"
                endif
            endfunction
            au BufEnter * exec "inoremap <silent> <Tab> <C-R>=g:UltiSnips_Tab()<cr>"
            au BufEnter * exec "inoremap <silent> <C-k> <C-R>=g:UltiSnips_Tab()<cr>"
            " Ulti的代码片段的文件夹
            let g:UltiSnipsSnippetsDir = $PLUG_PATH."/leoatchina-snippets/UltiSnips"
            let g:UltiSnipsSnippetDirectories=["UltiSnips"]
        elseif HasDirectory('neosnippet')
            let g:neosnippet#enable_completed_snippet = 1
            " c-f to jump
            smap <C-f> <Plug>(neosnippet_jump)
            function! g:Neo_Snippet_Tab()
                if pumvisible()
                    if neosnippet#expandable()
                        return neosnippet#mappings#expand_impl()
                    else
                        if empty(v:completed_item) || !len(get(v:completed_item,'menu'))
                            return "\<C-n>"
                        else
                            return "\<C-y>"
                        endif
                    endif
                else
                    return "\<Tab>"
                endif
            endfunction
            au BufEnter * exec "inoremap <silent> <Tab> <C-R>=g:Neo_Snippet_Tab()<cr>"
            au BufEnter * exec "inoremap <silent> <C-k> <C-R>=g:Neo_Snippet_Tab()<cr>"
            " Use honza's snippets.
            let g:neosnippet#snippets_directory=$PLUG_PATH.'/vim-snippets/snippets'
            " Enable neosnippets when using go
            if count(g:plug_groups, 'go')
                let g:go_snippet_engine = "neosnippet"
            endif
        else
            inoremap <silent><expr> <C-k> pumvisible()? "<C-y>":"<C-k>"
        endif
    endif
    if HasDirectory("ale")
        let g:ale_completion_enabled   = 0
        let g:ale_lint_on_enter        = 1
        let g:ale_lint_on_text_changed = 'always'
        " signs
        let g:ale_sign_column_always   = 1
        let g:ale_set_signs            = 1
        let g:ale_set_highlights       = 0
        let g:ale_sign_error           = 'E'
        let g:ale_sign_warning         = 'w'
        " message format
        let g:ale_echo_msg_error_str   = 'E'
        let g:ale_echo_msg_warning_str = 'W'
        let g:ale_echo_msg_format      = '[%linter%] %s [%code%]'
        let g:ale_fix_on_save          = 0
        let g:ale_set_loclist          = 0
        let g:ale_set_quickfix         = 0
        let g:ale_statusline_format    = ['E:%d', 'W:%d', '']
        let g:ale_python_flake8_options = " --ignore=E501,E251,E226,E221 "
        " 特定后缀指定lint方式
        let g:ale_pattern_options_enabled = 1
        let b:ale_warn_about_trailing_whiteSpace = 0
        nmap <C-l><C-l> :ALELint<CR>
        nmap <silent> <C-l>p <Plug>(ale_previous_wrap)
        nmap <silent> <C-l>n <Plug>(ale_next_wrap)
        nnoremap gt :ALEGoToDefinitionInTab<CR>
        nnoremap gd :ALEGoToDefinition<CR>
    elseif HasDirectory("syntastic")
        let g:syntastic_error_symbol             = 'E'
        let g:syntastic_warning_symbol           = 'W'
        let g:syntastic_check_on_open            = 0
        let g:syntastic_check_on_wq              = 0
        let g:syntastic_python_checkers          = ['pyflakes'] " 使用pyflakes,速度比pylint快
        let g:syntastic_javascript_checkers      = ['jsl', 'jshint']
        let g:syntastic_html_checkers            = ['tidy', 'jshint']
        let g:syntastic_enable_highlighting      = 0
        " to see error location list
        let g:syntastic_always_populate_loc_list = 0
        let g:syntastic_auto_loc_list            = 0
        let g:syntastic_loc_list_height          = 5
        function! ToggleErrors()
            let old_last_winnr = winnr('$')
            lclose
            if old_last_winnr == winnr('$')
                Errors
            endif
        endfunction
        nmap <silent> <C-l><C-l> :call ToggleErrors()<cr>
        nmap <silent> <C-l>n :lnext<cr>
        nmap <silent> <C-l>p :lprevious<cr>
    endif
    if HasDirectory("asyncrun.vim")
        let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
        function! s:RUN_ASYNC()
            exec "w"
            call asyncrun#quickfix_toggle(8,1)
            if &filetype == 'c'
                exec ":AsyncRun g++ % -o %<"
                exec ":AsyncRun ./%<"
            elseif &filetype == 'cpp'
                exec ":AsyncRun g++ % -o %<"
                exec ":AsyncRun ./%<"
            elseif &filetype == 'java'
                exec ":AsyncRun javac %"
                exec ":AsyncRun java %<"
            elseif &filetype == 'sh'
                exec ":AsyncRun bash %"
            elseif &filetype == 'python'
                exec ":AsyncRun python %"
            elseif &filetype == 'perl'
                exec ":AsyncRun perl %"
            elseif &filetype == 'go'
                exec ":AsyncRun go run %"
            endif
        endfunction
        command! RunAsync call s:RUN_ASYNC()
        nmap <C-b>r        :RunAsync<CR>
        nmap <C-b>s        :AsyncStop<CR>
        nmap <localleade>R :AsyncRun<Space>
    endif
    if HasDirectory("vim-quickrun")
        nnoremap <F5> :QuickRun<Cr>
        inoremap <F5> <ESC>:QuickRun<Cr>
        snoremap <F5> <ESC>:QuickRun<Cr>
        vnoremap <F5> <ESC>:QuickRun<Cr>
        let g:quickrun_config={"_":{"outputter":"message"}}
        let g:quickfix_is_open = 0
        function! ToggleQuickfix()
            if g:quickfix_is_open
                cclose
                cclose
                let g:quickfix_is_open = 0
                execute g:quickfix_return_to_window . "wincmd w"
            else
                let g:quickfix_return_to_window = winnr()
                copen
                let g:quickfix_is_open = 1
            endif
        endfunction
        command! ToggleQuickfix
                    \ call ToggleQuickfix()
        nnoremap <silent><F4> :ToggleQuickfix<cr>
        inoremap <silent><F4> <ESC>:ToggleQuickfix<cr>
        vnoremap <silent><F4> <ESC>:ToggleQuickfix<cr>
        snoremap <silent><F4> <ESC>:ToggleQuickfix<cr>
    endif
endif
