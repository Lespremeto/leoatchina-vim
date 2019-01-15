set nocompatible
set t_ti=
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
set conceallevel=0
" 不同文件类型加载不同插件
filetype plugin indent on   " Automatically detect file types.
set omnifunc=syntaxcomplete#Complete
filetype on                 " 开启文件类型侦测
filetype plugin on          " 根据侦测到的不同类型:加载对应的插件
syntax on
" set english input method when insert
set noimdisable
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
" Basics, set vim-plug install path
set rtp=$HOME/.vim-plug,$VIMRUNTIME
if WINDOWS()
    set winaltkeys=no
else
    set shell=/bin/sh
    if !has("gui")
        if !has('nvim')
            set term=xterm-256color
        endif
    endif
endif
" Functions
" alt meta key
function! Alt_meta_map()
    set ttimeout
    if $TMUX != ''
        set ttimeoutlen=20
    elseif &ttimeoutlen > 60 || &ttimeoutlen <= 0
        set ttimeoutlen=60
    endif
    map ÏP <F1>
    map ÏQ <F2>
    map ÏR <F3>
    map ÏS <F4>
    inoremap ÏP <Nop>
    inoremap ÏQ <Nop>
    inoremap ÏR <Nop>
    inoremap ÏS <Nop>
    inoremap <F5> <Nop>
    inoremap <F6> <Nop>
    inoremap <F7> <Nop>
    inoremap <F8> <Nop>
    inoremap <F9> <Nop>
    inoremap <F10> <Nop>
    inoremap <F11> <Nop>
    inoremap <F12> <Nop>
    if has('nvim') || has('gui_running') && !OSX()
        return
    endif
    function! s:metacode(key)
        exec "set <M-".a:key.">=\e".a:key
    endfunction
    for i in range(26)
        call s:metacode(nr2char(char2nr('a') + i))
        call s:metacode(nr2char(char2nr('A') + i))
    endfor
    for i in range(10)
        call s:metacode(nr2char(char2nr('0') + i))
    endfor
    let s:list = [',', '.', '-', '_', ';', ':', '/', '?']
    for c in s:list
        call s:metacode(c)
    endfor
    if has('gui_macvim')
        let a:letters_dict={
            \ 'a':'å',
            \ 'b':'∫',
            \ 'c':'ç',
            \ 'd':'∂',
            \ 'e':'´',
            \ 'f':'ƒ',
            \ 'g':'©',
            \ 'h':'˙',
            \ 'i':'ˆ',
            \ 'j':'∆',
            \ 'k':'˚',
            \ 'l':'¬',
            \ 'm':'µ',
            \ 'n':'˜',
            \ 'o':'ø',
            \ 'p':'π',
            \ 'q':'œ',
            \ 'r':'®',
            \ 's':'ß',
            \ 't':'†',
            \ 'u':'¨',
            \ 'v':'√',
            \ 'w':'∑',
            \ 'x':'≈',
            \ 'y':'¥',
            \ 'z':'Ω',
            \ 'A':'Å',
            \ 'B':'ı',
            \ 'C':'Ç',
            \ 'D':'∂',
            \ 'E':'´',
            \ 'F':'Ï',
            \ 'G':'˝',
            \ 'H':'Ó',
            \ 'I':'ˆ',
            \ 'J':'Ô',
            \ 'K':'',
            \ 'L':'Ò',
            \ 'M':'Â',
            \ 'N':'˜',
            \ 'O':'Ø',
            \ 'P':'∏',
            \ 'Q':'Œ',
            \ 'R':'‰',
            \ 'S':'Í',
            \ 'T':'ˇ',
            \ 'U':'¨',
            \ 'V':'◊',
            \ 'W':'„',
            \ 'X':'˛',
            \ 'Y':'Á',
            \ 'Z':'¸',
            \ ',':'≤',
            \ '.':'≥',
            \ '-':'–',
            \ '_':'—',
            \ ';':'…',
            \ ':':'Ú',
            \ '/':'÷',
            \ '?':'¿',
            \ '0':'º',
            \ '1':'¡',
            \ '2':'™',
            \ '3':'£',
            \ '4':'¢',
            \ '5':'∞',
            \ '6':'§',
            \ '7':'¶',
            \ '8':'•',
            \ '9':'ª'
        \ }
        for c in keys(a:letters_dict)
            for m in ['nmap', 'xmap', 'smap', 'tmap']
                exec m." ".a:letters_dict[c]." <M-".c.">"
            endfor
        endfor
    endif
endfunction
call Alt_meta_map()
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
" HasPlug define
let g:plugs_group=['']
function! HasPlug(plug)
    return count(g:plugs_group, a:plug)
endfunction
" HasDirectory define
function! HasDirectory(dir)
    return isdirectory(expand($PLUG_PATH."/".a:dir))
endfunction
" Use plugs config
if filereadable(expand("~/.vimrc.plugs"))
    source ~/.vimrc.plugs
endif
" leader key
let g:mapleader = ' '
let g:maplocalleader = '\'
" remap q/Q
nnoremap `         Q
nnoremap Q         :bd!<Cr>
nnoremap <M-q>     :q!<Cr>
nnoremap <M-Q>     :qa!
nnoremap <Leader>q :tabclose<CR>
" 定义快捷键使用
nnoremap <leader><Cr> :source ~/.vimrc<CR>
cnoremap w!! w !sudo tee % >/dev/null
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
" Key reMappings
nnoremap <Cr> %
nnoremap * *``
nnoremap ! :!
xnoremap / y/<C-r>0
xnoremap ; y:%s/<C-r>0
xnoremap . :normal .<CR>
" to nop
nnoremap go <Nop>
xnoremap go <Nop>
snoremap go <Nop>
nnoremap gn <Nop>
xnoremap gn <Nop>
snoremap gn <Nop>
nnoremap gy <Nop>
xnoremap gy <Nop>
snoremap gy <Nop>
nnoremap ga <Nop>
xnoremap ga <Nop>
snoremap ga <Nop>
nnoremap gt <Nop>
nnoremap gT <Nop>
xnoremap gt <Nop>
xnoremap gT <Nop>
snoremap gt <Nop>
snoremap gT <Nop>
" some ctrl+ key remap
nnoremap <M--> <C-a>
nnoremap <M-_> <C-x>
nnoremap <C-a> <Nop>
nnoremap <C-x> <Nop>
nnoremap <C-p> <Nop>
nnoremap <C-s> <Nop>
nnoremap <C-q> <Nop>
nnoremap <C-z> <Nop>
nnoremap <C-g> <Nop>
nnoremap <C-f> <Nop>
xnoremap <C-f> <Nop>
snoremap <C-f> <Nop>
inoremap <C-f> <right>
cnoremap <C-f> <right>
inoremap <C-b> <Left>
cnoremap <C-b> <Left>
inoremap <C-k><C-u> <C-x><C-u>
inoremap <C-k><C-o> <C-x><C-o>
inoremap <C-k><C-v> <C-x><C-v>
inoremap <C-k><C-l> <C-x><C-l>
inoremap <C-l> <Nop>
" b/f for back/forword
nnoremap gb ^
nnoremap gf $
xnoremap gb ^
xnoremap gf $<left>
inoremap <C-a> <Esc>I
inoremap <expr><silent><C-e> pumvisible()? "\<C-e>":"\<ESC>A"
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" Find merge conflict markers
nnoremap <C-f>c /\v^[<\|=>]{7}( .*\|$)<CR>
" and ask which one to jump to
nnoremap <C-f>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" tab control
set tabpagemax=10 " Only show 10 tabs
cnoremap Tabe tabe
" compatible with xshell
nnoremap <silent><Tab>   :tabnext<CR>
nnoremap <silent><S-Tab> :tabprevious<CR>
nnoremap <silent>-       :tabprevious<CR>
nnoremap <leader><Tab>   :tabm +1<CR>
nnoremap <leader><S-Tab> :tabm -1<CR>
nnoremap <leader>-       :tabm -1<CR>
nnoremap <Leader>te      :tabe<Space>
nnoremap <Leader>tm      :tabm<Space>
nnoremap <Leader>ts      :tab split<CR>
nnoremap <Leader>tS      :tabs<CR>
nnoremap <M-1>           :tabn1<CR>
nnoremap <M-2>           :tabn2<CR>
nnoremap <M-3>           :tabn3<CR>
nnoremap <M-4>           :tabn4<CR>
nnoremap <M-5>           :tabn5<CR>
nnoremap <M-6>           :tabn6<CR>
nnoremap <M-7>           :tabn7<CR>
nnoremap <M-8>           :tabn8<CR>
nnoremap <M-9>           :tabn9<CR>
nnoremap <M-0>           :tablast<CR>
" buffer switch
nnoremap <localleader><BS> :ball<CR>
nnoremap <localleader>[ :bp<CR>
nnoremap <localleader>] :bn<CR>
nnoremap <localleader><Space> :Sex<CR>
" 设置copy paste键
nnoremap Y y$
nnoremap <leader>Y "*y$
nnoremap <leader>yy "*yy
nnoremap <M-c> "*y
nnoremap <M-C> "+y
xnoremap <M-c> "*y
xnoremap <M-C> "+y
nnoremap <M-x> "*x
nnoremap <M-X> "+x
xnoremap <M-x> "*x
xnoremap <M-X> "+x
nnoremap <M-v> "*P
nnoremap <M-V> "+P
xnoremap <M-v> "*P
xnoremap <M-V> "+P
cnoremap <M-v> <C-r>*
cnoremap <M-V> <C-r>+
" Swap two words with M-z
xnoremap <M-z> <ESC>`.``gvp``P
" Easier horizontal scrolling
noremap zl zL
noremap zh zH
nnoremap ZR zR
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <silent>j gj
noremap <silent>k gk
" for toggle highlight
nnoremap <C-h><C-h> :set nohlsearch! nohlsearch?<CR>
" pastetoggle (sane indentation on pastes)
nnoremap <leader>tp <ESC>:set nopaste! nopaste?<CR>
" toggleFold
nnoremap <leader>tf :set nofoldenable! nofoldenable?<CR>
" toggleWrap
nnoremap <leader>tw :set nowrap! nowrap?<CR>
" for help
nnoremap <leader>TT :tab help<Space>
" show clipboard
nnoremap <M-T> :reg<Cr>
" 定义快捷键保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :wq!<CR>
nnoremap <Leader>WQ :wa<CR>:q<CR>
" 设置分割页面
nnoremap <leader>\ :vsplit<Space>
nnoremap <leader>= :split<Space>
"设置垂直高度减增
nnoremap <Leader><Down>  :resize -3<CR>
nnoremap <Leader><Up>    :resize +3<CR>
"设置水平宽度减增
nnoremap <Leader><Left>  :vertical resize -3<CR>
nnoremap <Leader><Right> :vertical resize +3<CR>
" Visual shifting (does not exit Visual mode)
xnoremap << <gv
xnoremap >> >gv
"离开插入模式后关闭预览窗口
au! InsertLeave * if pumvisible() == 0|pclose|endif
"补全完成后关闭预览窗口
au! CompleteDone * if pumvisible() == 0 | pclose | endif
" auto close windows when leave vim
aug WINDOWClose
    au!
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END
" Formatting
set autoindent                  " Indent at the same level of the previous line
set nojoinspaces                " Prevents inserting two Spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
" 不生成back和swap件
set nobackup
set noswapfile
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
" 不折行
set nowrap
" 不折叠
set nofoldenable
" 标签控制
set showtabline=2
" 开启实时搜索功能
set incsearch
" 显示行号
set number
nnoremap <silent><leader>tn :set invrelativenumber<CR>
" 在help里显示行号
au FileType help setlocal number
" 显示光标当前位置
set ruler
" 高亮显示搜索结果
set hlsearch
set incsearch                   " Find as you type search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
" 一些格式
set backspace=indent,eol,start  " BackSpace for dummies
set linespace=0                 " No extra Spaces between rows
set showmatch                   " Show matching brackets/parenthesis
set winminheight=0              " Windows can be 0 line high
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set shiftwidth=2                " Use indents of 2 Spaces
set tabstop=2                   " An indentation every
set softtabstop=2               " Let backSpace delete indent
set expandtab                   " Tabs are Spaces, not tabs
set autoindent
setlocal textwidth=0
" 没有滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 没有菜单和工具条
set guioptions-=m
set guioptions-=M
set guioptions-=T
set guioptions-=e
set nolist
" General
au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
au BufNewFile,BufRead *.md,*.markdown,*README* set filetype=markdown
au BufNewFile,BufRead *.pandoc set filetype=pandoc
au BufNewFile,BufRead *.coffee set filetype=coffee
au BufNewFile,BufRead *.ts,*.vue set filetype=typescript
au BufNewFile,BufRead *vimrc*,*.vim set filetype=vim
" sepcial setting for different type of files
au FileType python au BufWritePre <buffer> :%retab
au FileType python,vim setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
au BufNewFile,BufRead *.py,*.vim,*.vimrc.* setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
" Workaround vim-commentary for Haskell
au FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
au FileType haskell,rust setlocal nospell
" Remove trailing whiteSpaces and ^M chars
au FileType markdown,vim,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,eperl,sql au BufWritePre <buffer> call StripTrailingWhiteSpace()
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
xnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
xnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
xnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
xnoremap <Home> :<C-U>call WrapRelativeMotion("^", 1)<CR>
xnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
" window move manager
function! g:Tools_PreviousCursor(mode)
    if winnr('$') <= 1
        return
    endif
    noautocmd silent! wincmd p
    if a:mode == 0
        exec "normal! \<c-u>"
    elseif a:mode == 1
        exec "normal! \<c-d>"
    elseif a:mode == 2
        exec "normal! \<c-e>"
    elseif a:mode == 3
        exec "normal! \<c-y>"
    elseif a:mode == 4
        exec "normal! ".winheight('.')."\<c-e>"
    elseif a:mode == 5
        exec "normal! ".winheight('.')."\<c-y>"
    elseif a:mode == 6
        exec "normal! k"
    elseif a:mode == 7
        exec "normal! j"
    elseif a:mode == 8
        normal! gg
    elseif a:mode == 9
        normal! G
    endif
    noautocmd silent! wincmd p
endfunction
nnoremap <silent> <M-u> :call Tools_PreviousCursor(0)<cr>
nnoremap <silent> <M-d> :call Tools_PreviousCursor(1)<Cr>
nnoremap <silent> <M-e> :call Tools_PreviousCursor(2)<cr>
nnoremap <silent> <M-y> :call Tools_PreviousCursor(3)<Cr>
" Stupid Shift key fixes
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
if has('job') || g:python_version || has('nvim') || has('lua')
    " full-screen
    if WINDOWS()
        if has('libcall') && !has('nvim')
            let g:MyVimLib = $HOME."\\.vim-windows-tools\\gvimfullscreen.dll"
            function! ToggleFullScreen()
                call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
            endfunction
            map <C-cr> <ESC>:call ToggleFullScreen()<CR>
            let g:VimAlpha = 240
            function! SetAlpha(alpha)
                let g:VimAlpha = g:VimAlpha + a:alpha
                if g:VimAlpha < 95
                    let g:VimAlpha = 95
                endif
                if g:VimAlpha > 255
                    let g:VimAlpha = 255
                endif
                call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
            endfunction
            nmap <silent><M-F12> <Esc>:call SetAlpha(+10)<CR>
            nmap <silent><M-F11> <Esc>:call SetAlpha(-10)<CR>
        elseif HasDirectory('vim-fullscreen')
            if has('nvim')
                let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
                let g:fullscreen#stop_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"
            endif
        endif
    endif
    " table enhanced
    if HasDirectory('vim-table-mode')
        function! s:isAtStartOfLine(mapping)
            let text_before_cursor = getline('.')[0 : col('.')-1]
            let mapping_pattern = '\V' . escape(a:mapping, '\')
            let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
            return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
        endfunction
        inoreabbrev <expr> <bar><bar>
              \ <SID>isAtStartOfLine('\|\|') ?
              \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
        inoreabbrev <expr> __
              \ <SID>isAtStartOfLine('__') ?
              \ '<c-o>:silent! TableModeDisable<cr>' : '__'
        let g:table_mode_corner='|'
        let g:table_mode_corner_corner='+'
        let g:table_mode_header_fillchar='='
    endif
    " markdown enhanced
    if g:python_version && HasDirectory('vim-markdown')
        let g:vim_markdown_folding_disabled = 1
        let g:vim_markdown_no_default_key_mappings = 1
        let g:vim_markdown_preview_started = 0
        au FileType markdown nmap ]] <Plug>Markdown_MoveToNextHeader
        au FileType markdown nmap [[ <Plug>Markdown_MoveToPreviousHeader
        au FileType markdown nmap ][ <Plug>Markdown_MoveToNextSiblingHeader
        au FileType markdown nmap [] <Plug>Markdown_MoveToPreviousSiblingHeader
        au FileType markdown nmap ]c <Plug>Markdown_MoveToCurHeader
        au FileType markdown nmap ]u <Plug>Markdown_MoveToParentHeader
    endif
    " markdown toc
    if HasDirectory('vim-markdown-toc')
        let g:vmt_auto_update_on_save = 1
        let g:vmt_cycle_list_item_markers = 1
    endif
    " markdown preview
    if HasDirectory('markdown-preview.vim') || HasDirectory('markdown-preview.nvim')
        nmap <leader>zz <Nop>
        nmap <leader>ZZ <Nop>
        au FileType markdown nmap <leader>zz <Plug>MarkdownPreview
        au FileType markdown nmap <leader>zs <Plug>StopMarkdownPreview
        if has('gui_running')
            au FileType markdown nmap <silent> <C-z> <Plug>MarkdownPreview
            au FileType markdown xmap <silent> <C-z> <Plug>MarkdownPreview
            au FileType markdown imap <silent> <C-z> <Plug>MarkdownPreview
            au FileType markdown nmap <silent> <C-s> <Plug>StopMarkdownPreview
            au FileType markdown xmap <silent> <C-s> <Plug>StopMarkdownPreview
            au FileType markdown imap <silent> <C-s> <Plug>StopMarkdownPreview
        endif
    endif
    " fugitive
    if HasDirectory("vim-fugitive")
        nnoremap gc    :Gcommit -a -v<CR>
        nnoremap g<Cr> :Git<Space>
        if HasDirectory("vim-signify")
        endif
    endif
    " startify
    if HasDirectory("vim-startify")
        let g:startify_custom_header = [
            \ '+---------------------------------------------------------+',
            \ '|  Welcome to use leoatchina vim config forked from spf13 |',
            \ '|                                                         |',
            \ '|  https://github.com/leoatchina/leoatchina-vim           |',
            \ '+---------------------------------------------------------+',
            \ ]
        let g:startify_session_dir = expand("$HOME/.cache/session")
        let g:startify_files_number = 10
        let g:startify_session_number = 10
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
                \ {'h': ['帮助', 'help howto']},
                \ {'v': ['版本', 'version']}
            \ ]
    endif
    " bufferline
    if HasDirectory("vim-bufferline")
        let g:bufferline_show_bufnr = 0
        let g:bufferline_rotate = 1
        let g:bufferline_fixed_index =  0
    endif
    " statusline
    if has('statusline')
        if HasDirectory("lightline.vim")
            function! LightlineReadonly()
                return &readonly && &filetype !=# 'help' ? 'RO' : ''
            endfunction
            let g:lightline = {
                \ 'component': {
                \     'filefullpath': '%F',
                \     'lineinfo': '%l/%L : %c'
                \ },
                \ 'component_function': {
                \     'gitbranch': 'fugitive#head',
                \     'readonly': 'LightlineReadonly'
                \ },
                \ 'active': {
                \     'left': [
                \         ['mode', 'paste'],
                \         ['gitbranch', 'readonly'],
                \         ['filefullpath', 'modified']
                \     ],
                \     'right': [
                \         ['percent'],
                \         ['filetype', 'fileformat', 'fileencoding' , 'lineinfo']
                \     ]
                \ }
            \ }
            if HasDirectory("lightline-ale")
                let g:lightline.component_expand =  {
                    \ 'linter_checking': 'lightline#ale#checking',
                    \ 'linter_warnings': 'lightline#ale#warnings',
                    \ 'linter_errors': 'lightline#ale#errors',
                    \ 'linter_ok': 'lightline#ale#ok'
                \ }
                let g:lightline.component_type = {
                    \ 'linter_checking': 'right',
                    \ 'linter_warnings': 'warning',
                    \ 'linter_errors': 'error',
                    \ 'linter_ok': 'left'
                \ }
                let g:lightline.active.right = [
                    \ ['percent'],
                    \ ['filetype', 'fileformat', 'fileencoding', 'lineinfo'],
                    \ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok']
                \ ]
            endif
        else
            set statusline=%1*%{exists('g:loaded_fugitive')?fugitive#statusline():''}%*
            set statusline+=%2*\ %F\ %*
            set statusline+=%3*\ \ %m%r%y\ %*
            set statusline+=%=%4*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"\ \|\"}\ %-14.(%l\/%L\ %c%)%*
            set statusline+=%5*\ %P\ %<
            hi User1 cterm=bold ctermfg=232 ctermbg=179
            hi User2 cterm=bold ctermfg=255 ctermbg=100
            hi User3 cterm=None ctermfg=208 ctermbg=238
            hi User4 cterm=None ctermfg=246 ctermbg=237
            hi User5 cterm=None ctermfg=250 ctermbg=238
        endif
    endif
    if HasDirectory('vim-dirvish')
        nnoremap <M-D> :Dirvish<CR>
        nnoremap <C-k>d :Dirvish<Space>
        nnoremap <M-S> :Shdo!<Space>
        if HasDirectory('vim-dirvish')
            autocmd FileType dirvish nmap <silent><buffer><C-n> <Plug>(dirvish_git_next_file)
            autocmd FileType dirvish nmap <silent><buffer><C-p> <Plug>(dirvish_git_prev_file)
            let g:dirvish_git_show_ignored = 1
            let g:dirvish_git_indicators = {
                \ 'Modified'  : '✹',
                \ 'Staged'    : '✚',
                \ 'Untracked' : '✭',
                \ 'Renamed'   : '➜',
                \ 'Unmerged'  : '═',
                \ 'Ignored'   : '☒',
                \ 'Unknown'   : '?'
            \ }
        endif
    endif
    " themes
    if HasDirectory("/vim-colorschemes-collections")
        " dark theme
        set background=dark
        " 总是显示状态栏
        set laststatus=2
        if has('gui_running')
            set termguicolors
        endif
        if HasPlug('molokai')
            colorscheme molokai
        elseif HasPlug('badwolf')
            colorscheme badwolf
        elseif HasPlug('atom')
            if has('gui_running')
                colorscheme atom-dark
            else
                colorscheme atom-dark-256
            endif
        elseif HasPlug('seoul256')
            let g:seoul256_background = 233
            colorscheme seoul256
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'seoul256'
            endif
        elseif HasPlug('iceberg')
            colorscheme iceberg
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'iceberg'
            endif
        elseif HasPlug('tomorrow')
            colorscheme Tomorrow-Night
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'Tomorrow-Night'
            endif
        elseif HasPlug('nord')
            colorscheme nord
            let g:nord_italic = 1
            let g:nord_underline = 1
            let g:nord_italic_comments = 1
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'nord'
            endif
        elseif HasPlug('onedark')
            colorscheme onedark
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'onedark'
            endif
        elseif HasPlug('papercolor')
            colorscheme PaperColor
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'PaperColor_dark'
            endif
        elseif HasPlug('papercolor-light')
            set background=light
            colorscheme PaperColor
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'PaperColor_light'
            endif
        elseif HasPlug('neodark')
            colorscheme neodark
            if !has('gui_running')
                let g:neodark#use_256color = 1
            endif
            let g:neodark#terminal_transparent = 1
            let g:neodark#solid_vertsplit = 1
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'neodark'
            endif
        elseif HasPlug('solarized')
            let g:solarized_termcolors=256
            colorscheme solarized
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'solarized'
            endif
        elseif HasPlug('solarized-light')
            set background=light
            let g:solarized_termcolors=256
            colorscheme solarized
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'solarized'
            endif
        elseif HasPlug('wombat256') || v:version < 800 && !has('nvim')
            colorscheme wombat256mod
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'wombat'
            endif
        elseif HasPlug('hybrid') || has('nvim') && WINDOWS()
            colorscheme hybrid
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'seoul256'
            endif
        elseif HasPlug('jellybeans') || has('nvim') && !WINDOWS()
            colorscheme jellybeans
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'jellybeans'
            endif
        elseif HasPlug('material') || has('gui_running') && WINDOWS()
            colorscheme vim-material
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'material'
            endif
        elseif HasPlug('codedark') || has('gui_running') && !WINDOWS()
            colorscheme codedark
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'nord'
            endif
        else
            colorscheme gruvbox
            if HasDirectory('lightline.vim')
                let g:lightline.colorscheme = 'gruvbox'
            endif
        endif
    endif
    " ctags && tagbar
    if HasDirectory("tagbar")
        let g:tagbar_sort = 0
        let g:tagbar_left = 1
        set tags=./.tags;,.tags
        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
        nnoremap <silent><M-t> :TagbarToggle<CR>
        nnoremap <silent><leader>tt :TagbarOpen j<CR>
        " show in split
        nnoremap <C-]> :sp <CR>:exec("tag ".expand("<cword>"))<CR>
        " show in vsplit
        nnoremap <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
        " jump to defineOrDeclare
        nnoremap <C-w><C-]> <C-]>
        " show in tab
        nnoremap <C-w><C-\> <C-w><C-]><C-w>T
    else
        nnoremap <silent><leader>tt <Nop>
    endif
    " gtags
    if HasDirectory("vim-gutentags")
        " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
        let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
        " 所生成的数据文件的名称
        let g:gutentags_ctags_tagfile = '.tags'
        " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
        let s:vim_tags = expand("$HOME/.cache/tags")
        " 检测 ~/.cache/tags 不存在就新建
        if !isdirectory(s:vim_tags)
            silent! call mkdir(s:vim_tags, 'p')
        endif
        let g:gutentags_cache_dir = s:vim_tags
        " 配置 gtags 的参数
        "gtags settings, according to https://zhuanlan.zhihu.com/p/36279445
        if WINDOWS()
            " gtags in WINDOWS is cloned in in 「~/.vim-windows-tools/]
            let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q', '--output-format=e-ctags']
            let $GTAGSCONF = expand("~/.vim-support/tools/gtags/share/gtags.conf")
        elseif !exists('g:gutentags_ctags_extra_args')
            "if use universary-tags, shoud has config like in windows in .local file
            let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        endif
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        let $GTAGSLABEL = 'native-pygments'
    endif
    " preview tools, you have to map meta key in term
    if HasDirectory('vim-preview')
        nnoremap <M-;> :PreviewTag<Cr>
        nnoremap <M-/> :PreviewSignature!<Cr>
        nnoremap <M-:> :PreviewQuickfix<Space>
        nnoremap <M-?> :PreviewClose<Cr>
        au FileType qf nnoremap <silent><buffer> f :PreviewQuickfix<cr>
        au FileType qf nnoremap <silent><buffer> q :PreviewClose<cr>
    endif
    " indent_guides
    if HasDirectory("indentLine")
        let g:indentLine_setColors = 0
        let g:indentLine_concealcursor = 'inc'
        let g:indentLine_conceallevel = 2
        let g:indentLine_enabled = 1
        nnoremap <leader>ti :IndentLinesToggle<Cr>
    endif
    " conflict-marker
    if HasDirectory("conflict-marker.vim")
        let g:conflict_marker_enable_mappings = 1
    endif
    " multiple-cursors
    if HasDirectory("vim-multiple-cursors")
        let g:multi_cursor_use_default_mapping = 0
        let g:multi_cursor_start_word_key      = '<C-n>'
        let g:multi_cursor_select_all_word_key = '<M-n>'
        let g:multi_cursor_start_key           = 'g<C-n>'
        let g:multi_cursor_select_all_key      = 'g<M-n>'
        let g:multi_cursor_next_key            = '<C-n>'
        let g:multi_cursor_prev_key            = '<C-_>'
        let g:multi_cursor_skip_key            = '<C-h>'
        let g:multi_cursor_quit_key            = '<ESC>'
        highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
        highlight link multiple_cursors_visual Visual
        function! Multiple_cursors_before()
            if g:complete_engine == "neocomplete"
                exe 'NeoCompleteLock'
            endif
        endfunction
        function! Multiple_cursors_after()
            if g:complete_engine == "neocomplete"
                exe 'NeoCompleteUnlock'
            endif
        endfunction
    endif
    " autopairs
    if HasDirectory("auto-pairs")
        let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`'}
        let g:AutoPairsShortcutToggle     = "<C-l>o"
        let g:AutoPairsShortcutFastWrap   = "<C-l>f"
        let g:AutoPairsShortcutJump       = "<C-l>j"
        let g:AutoPairsShortcutBackInsert = "<C-l>i"
        inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>
    endif
    " typecast
    if HasDirectory('typecast.vim')
        nmap <leader>tc <Plug>typecast
    endif
    " neoformat
    if HasDirectory('neoformat')
        nnoremap <leader>nf :Neoformat!<Space>
    endif
    " ywvim,vim里的中文输入法
    if HasDirectory("ywvim")
        set showmode
        if HasPlug('pinyun')
            let g:ywvim_ims=[
                    \['py', '拼音', 'pinyin.ywvim'],
                    \['wb', '五笔', 'wubi.ywvim'],
                \]
        elseif HasPlug('wubi')
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
        inoremap <C-\> <Nop>
        cnoremap <C-\> <Nop>
    endif
    " search tools
    if HasDirectory('FlyGrep.vim')
        nnoremap <C-f>g :FlyGrep<Cr>
    endif
    if HasDirectory('ctrlsf.vim')
        let g:ctrlsf_position='right'
        nmap     <C-F>f <Plug>CtrlSFPrompt
        xmap     <C-F>f <Plug>CtrlSFVwordPath
        xmap     <C-F>F <Plug>CtrlSFVwordExec
        nmap     <C-F>n <Plug>CtrlSFCwordPath
        nmap     <C-F>N <Plug>CtrlSFCCwordPath
        nmap     <C-F>p <Plug>CtrlSFPwordPath
    elseif HasDirectory('far.vim')
        nnoremap <C-f>f :Far<Space>
    endif
    " Shell
    if has('terminal') || has('nvim')
        tnoremap <C-w>h <C-\><C-N><C-w>h
        tnoremap <C-w>j <C-\><C-N><C-w>j
        tnoremap <C-w>k <C-\><C-N><C-w>k
        tnoremap <C-w>l <C-\><C-N><C-w>l
        tnoremap <C-w><right> <C-\><C-N><C-w><right>
        tnoremap <C-w><left>  <C-\><C-N><C-w><left>
        tnoremap <C-w><down>  <C-\><C-N><C-w><down>
        tnoremap <C-w><up>    <C-\><C-N><C-w><up>
        tnoremap <C-[> <C-\><C-n>
        tnoremap <ESC> <C-\><C-n>
        if has('nvim')
            tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
            if WINDOWS()
                nmap <C-h>\ :vsplit term://cmd<Cr>i
                nmap <C-h>= :split  term://cmd<Cr>i
                nmap <C-h>t :tabe   term://cmd<Cr>i
            else
                nmap <C-h>\ :vsplit term://bash<Cr>i
                nmap <C-h>= :split  term://bash<Cr>i
                nmap <C-h>t :tabe   term://bash<Cr>i
            endif
            nmap <C-h>V :vsplit term://
            nmap <C-h>S :split  term://
            nmap <C-h>T :tabe   term://
        else
            if WINDOWS()
                nmap <C-h>\ :vertical terminal<cr>cmd<cr>
                nmap <C-h>= :terminal<cr>cmd<cr>
                nmap <C-h>t :tab terminal<Cr>cmd<Cr>
            else
                nmap <C-h>\ :vertical terminal<cr>bash<cr>
                nmap <C-h>= :terminal<cr>bash<cr>
                nmap <C-h>t :tab terminal<Cr>bash<Cr>
            endif
            nmap <C-h>V :vertical terminal
            nmap <C-h>S :terminal
            nmap <C-h>T :tab terminal
        endif
    endif
    " easy-align
    if HasDirectory("vim-easy-align")
        nmap <localleader><Cr> <Plug>(EasyAlign)
        xmap <Cr> <Plug>(EasyAlign)
        if !exists('g:easy_align_delimiters')
            let g:easy_align_delimiters = {}
        endif
        let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
    endif
    " easymotion
    if HasDirectory("vim-easymotion")
        nmap <C-j><C-j> <Plug>(easymotion-w)
        nmap <C-k><C-k> <Plug>(easymotion-b)
    endif
    " UndoTree
    if HasDirectory("undotree")
        nnoremap <M-U> :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle = 0
        if has("persistent_undo")
            set undodir=~/.vim/undodir/
            set undofile
        endif
    endif
    if HasDirectory("LeaderF")
        let g:Lf_ShortcutF = '<C-k>j'
        let g:Lf_ShortcutB = '<C-k>b'
        let g:Lf_ReverseOrder = 1
        let g:Lf_PythonVersion = g:python_version
        let g:Lf_CacheDirectory = expand('$HOME/.cache/leaderf')
        if !isdirectory(g:Lf_CacheDirectory)
            silent! call mkdir(g:Lf_CacheDirectory, 'p')
        endif
        let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}
        nnoremap <C-k>l :LeaderfLine<cr>
        nnoremap <C-k>t :LeaderfBufTag<cr>
        nnoremap <C-k>m :LeaderfMarks<cr>
        nnoremap <C-k>b :LeaderfBuffer<cr>
        nnoremap <C-k>f :LeaderfFunction!<cr>
        nnoremap <C-k>k :Leaderf
        nnoremap <C-k>h :LeaderfHistoryCmd<Cr>
        nnoremap <C-k>H :LeaderfHistory
        nnoremap <C-k>F :LeaderfF
        nnoremap <C-k>M :LeaderfM
        nnoremap <C-k>B :LeaderfB
        nnoremap <C-k>C :LeaderfColorscheme<Cr>
        let g:Lf_NormalMap = {
           \ "File":        [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
           \ "Buffer":      [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
           \ "Mru":         [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
           \ "Tag":         [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
           \ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
           \ "Colorscheme": [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
       \ }
    elseif HasDirectory("fzf.vim")
        nnoremap <C-k>j :Files<CR>
        nnoremap <C-k>l :Lines<CR>
        nnoremap <C-k>b :Buffers<CR>
        nnoremap <C-k>m :Marks<CR>
        nnoremap <C-k>g :GFiles?<CR>
        nnoremap <C-k>c :Commits<CR>
        nnoremap <C-k>h :History/<CR>
        nnoremap <C-k>t :BTags<CR>
        nnoremap <C-k>A :Ag<CR>
        nnoremap <C-k>R :Rg<CR>
        nnoremap <C-k>F :Filetypes<CR>
        nnoremap <C-k>C :Colors<CR>
        nnoremap <C-k>M :Maps<CR>
        nnoremap <C-k>H :History
        " Mapping selecting mkppings
        nmap <C-k><tab> <plug>(fzf-maps-n)
        xmap <C-k><tab> <plug>(fzf-maps-x)
        omap <C-k><tab> <plug>(fzf-maps-o)
        imap <C-k><C-w> <plug>(fzf-complete-word)
        imap <C-k><C-p> <plug>(fzf-complete-path)
        imap <C-k><C-f> <plug>(fzf-complete-file-ag)
        imap <C-k><C-l> <plug>(fzf-complete-line)
        " [Buffers] Jump to the existing window if possible
        let g:fzf_buffers_jump = 1
        " [[B]Commits] Customize the options used by 'git log':
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
        " [Tags] Command to generate tags fil
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
                \ 'ctrl-v': 'vsplit'
            \ }
    endif
    " javascript language
    if HasDirectory('vim-javascript')
        let g:javascript_plugin_jsdoc = 1
        let g:javascript_plugin_ngdoc = 1
        let g:javascript_plugin_flow = 1
        au  FileType Javascript setlocal conceallevel=1
        let g:javascript_conceal_function             = "ƒ"
        let g:javascript_conceal_null                 = "ø"
        let g:javascript_conceal_this                 = "@"
        let g:javascript_conceal_return               = "⇚"
        let g:javascript_conceal_undefined            = "¿"
        let g:javascript_conceal_NaN                  = "ℕ"
        let g:javascript_conceal_prototype            = "¶"
        let g:javascript_conceal_static               = "•"
        let g:javascript_conceal_super                = "Ω"
        let g:javascript_conceal_arrow_function       = "⇒"
        let g:javascript_conceal_noarg_arrow_function = "🞅"
        let g:javascript_conceal_underscore_arrow_function = "🞅"
    endif
    if HasDirectory('vim-jsdoc')
        au FileType javascript nmap <C-p>j <Plug>(jsdoc)
    endif
    " php language
    if HasDirectory('phpcomplete.vim')
        let g:phpcomplete_mappings = {
           \ 'jump_to_def_split':  '<C-]>',
           \ 'jump_to_def_vsplit': '<C-\>',
           \ 'jump_to_def':        '<C-w><C-]>',
           \ 'jump_to_def_tabnew': '<C-w><C-\>',
           \}
    endif
    " html/css language
    if HasDirectory('emmet-vim')
        let g:user_emmet_leader_key='<C-p>'
    endif
    " java
    if HasDirectory("vim-eclim")
        let g:EclimCompletionMethod = 'omnifunc'
        let s:project_tree_is_open = 0
        function! ProjectTreeToggle()
            if s:project_tree_is_open
                call eclim#project#tree#ProjectTreeClose()
                let s:project_tree_is_open = 0
            else
                let s:winpos = winnr() + 1
                call eclim#project#tree#ProjectTree()
                let s:project_tree_is_open = 1
                execute s:winpos . "wincmd w"
            endif
        endfunction
        command! Pjt call ProjectTreeToggle()
        let b:eclim_available = filereadable(WINDOWS() ?
            \ '$HOME/.eclim/.eclimd_instances' :
            \ expand('~/.eclim/.eclimd_instances')
        \)
        if b:eclim_available
            au filetype java nnoremap <C-p>t :Pjt<Cr>
            au filetype java nnoremap <C-p>l :ProjectList<Cr>
            au filetype java nnoremap <C-p>b :ProjectBuild<Cr>
            au filetype java nnoremap <C-p>f :ProjectRefresh<Cr>
            au filetype java nnoremap <C-p>c :ProjectCD<Space>
            au filetype java nnoremap <C-p>d :ProjectLCD<Space>
            au filetype java nnoremap <C-p>n :ProjectCreate<Space>
            au filetype java nnoremap <C-p>m :ProjectMove<Space>
            au filetype java nnoremap <C-p>i :ProjectImport<Space>
            au filetype java nnoremap <C-p>o :ProjectOpen<Space>
            au filetype java nnoremap <C-p>r :ProjectRun
            au filetype java nnoremap <C-p>j :Project
            au filetype java nnoremap <C-p>I :ProjectInfo<Cr>
        else
            au filetype java nmap <C-p> <Nop>
            au filetype java echom("please start eclimd for java")
        endif
    else
        au filetype java nmap <C-p> <Nop>
        au filetype java echom("please please install eclim and config it for eclipse")
    endif
    " complete_engine
    set completeopt-=menu
    set completeopt-=preview
    set completeopt+=menuone
    if v:version == 704  && has('patch774') || v:version >= 800 || has('nvim')
        set shortmess+=c
    endif
    if HasDirectory("YouCompleteMe")
        set completeopt+=noinsert,noselect
        if g:python_version == 2
            let g:ycm_python_binary_path = 'python'
        else
            let g:ycm_python_binary_path = 'python3'
        endif
        let g:ycm_key_invoke_completion = ['<C-Space>', '<C-k>;']
        " add_preview
        let g:ycm_add_preview_to_completeopt = 1
        "  补全后close窗口
        let g:ycm_autoclose_preview_window_after_completion = 0
        "  插入后close窗口
        let g:ycm_autoclose_preview_window_after_insertion = 0
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
            \ 'cs,java,javascript,typescript,python,perl6,scala,vb,elixir,go' : ['.'],
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
        nnoremap <silent>gyd :YcmCompleter GoToDefinitionElseDeclaration<CR>
    elseif HasDirectory('ncm2')
        set completeopt+=noinsert,noselect
        autocmd BufEnter * call ncm2#enable_for_buffer()
        if HasPlug('html')
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
            au User Ncm2Plugin call ncm2#register_source({
                \ 'name' : 'html',
                \ 'enable' : 1,
                \ 'priority': 9,
                \ 'subscope_enable': 1,
                \ 'scope': ['htm','html', 'markdown'],
                \ 'mark': 'html',
                \ 'word_pattern': '[\w\-]+',
                \ 'complete_pattern': ':\s*',
                \ 'on_complete': ['ncm2#on_complete#omni', 'htmlcomplete#CompleteTags']
            \ })
        endif
        if HasPlug('java')
            au User Ncm2Plugin call ncm2#register_source({
                \ 'name' : 'java',
                \ 'enable' : 1,
                \ 'priority': 9,
                \ 'subscope_enable': 1,
                \ 'scope': ['java','class'],
                \ 'mark': 'java',
                \ 'word_pattern': '[\w\-]+',
                \ 'complete_pattern': '.\s*',
                \ 'on_complete': ['ncm2#on_complete#omni', 'javacomplete#Complete']
            \ })
        endif
    elseif HasDirectory("coc.nvim")
        set completeopt+=noinsert,noselect
        nmap <silent>god <Plug>(coc-definition)
        nmap <silent>goy <Plug>(coc-type-definition)
        nmap <silent>gom <Plug>(coc-implementation)
        nmap <silent>gor <Plug>(coc-references)
        let g:coc_snippetknext = '<C-n>'
        let g:coc_snippet_prev = '<C-p>'
        " Show signature help while editing
        au CursorHoldI * silent! call CocAction('showSignatureHelp')
        " Use `:Format` for format current buffer
        command! -nargs=0 Format :call CocAction('format')
        " Use `:Fold` for fold current buffer
        command! -nargs=? Fold :call CocAction('fold', <f-args>)
    elseif HasDirectory("deoplete.nvim")
        set completeopt+=noinsert,noselect
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#enable_camel_case = 1
        " <BS>: close popup and delete backword char.
        inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
        if !has('nvim')
            let g:deoplete#enable_yarp = 1
        endif
        if HasDirectory('deoplete-tabnine')
            call deoplete#custom#source('tabnine', 'rank', 500)
        endif
        if HasDirectory('ultisnips')
            call deoplete#custom#source('ultisnips', 'rank', 1000)
        endif
        if HasDirectory('deoplete-jedi')
            let g:deoplete#sources#jedi#python_path = expand(exepath('python3'))
        endif
        if HasDirectory('deoplete-go')
            let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
        endif
        if HasDirectory('deoplete-rust')
            let g:deoplete#sources#rust#show_duplicates=0
        endif
        " omni completion is vim grep
        call deoplete#custom#option('omni_patterns', {
            \ 'java' :'[^. *\t]\.\w*',
            \ 'php'  :'[^. \t]->\h\w*\|\h\w*::',
            \ 'perl' :'\h\w*->\h\w*\|\h\w*::',
            \ 'c'    :'[^.[:digit:] *\t]\%(\.\|->\)',
            \ 'cpp'  :'[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
        \})
        " keyword_patterns is python grep
        call deoplete#custom#option('keyword_patterns', {
            \ '_'    :'[a-zA-Z_]\k*',
            \ 'tex'  :'\\?[a-zA-Z_]\w*',
            \ 'ruby' :'[a-zA-Z_]\w*[!?]?',
        \})
    elseif HasDirectory("asyncomplete.vim")
        set completeopt+=noinsert,noselect
        let g:asyncomplete_auto_popup = 1
        if v:version >= 800
            if has('nvim') || has('lua')
                let g:asyncomplete_smart_completion = 1
            endif
        endif
        " python first
        if executable('pyls')
            au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
            \ })
        endif
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
        \ }))
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
            \ 'name': 'necosyntax',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
        \ }))
        au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
            \ 'name': 'necovim',
            \ 'whitelist': ['vim'],
            \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))
        if HasDirectory('asyncomplete-tags.vim')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                \ 'name': 'tags',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#tags#completor'),
                \ 'config': {
                \    'max_file_size': 50000000,
                \  },
            \ }))
        endif
        if HasPlug('javascript')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tscompletejob#get_source_options({
                \ 'name': 'tscompletejob',
                \ 'whitelist': ['javascript', 'typescript'],
                \ 'completor': function('asyncomplete#sources#tscompletejob#completor'),
            \ }))
        endif
        if HasPlug('go')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
                \ 'name': 'gocode',
                \ 'whitelist': ['go'],
                \ 'completor': function('asyncomplete#sources#gocode#completor'),
            \ }))
        endif
        if HasDirectory('asyncomplete-racer.vim')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#racer#get_source_options())
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
        " ominifuc
        if g:python_version == 2
            au FileType python setlocal omnifunc=pythoncomplete#Complete
        elseif g:python_version == 3
            au FileType python setlocal omnifunc=python3complete#Complete
        endif
        au FileType css           setlocal omnifunc=csscomplete#CompleteCSS
        au FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        au FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
        au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
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
        let g:neocomplcache_enable_at_startup = 1
        " ominifuc
        if g:python_version == 2
            au FileType python setlocal omnifunc=pythoncomplete#Complete
        elseif g:python_version == 3
            au FileType python setlocal omnifunc=python3complete#Complete
        endif
        au FileType css           setlocal omnifunc=csscomplete#CompleteCSS
        au FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        au FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
        au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
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
    " complete_snippet
    if g:complete_engine == "YCM" || g:complete_engine == "asyncomplete"
        imap <expr><Cr>  pumvisible()? "\<C-[>a":"\<CR>"
    else
        imap <expr><Cr>  pumvisible()? "\<C-y>":"\<CR>"
    endif
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>"                  : "\<Up>"
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>"                  : "\<Down>"
    inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>"   : "\<PageUp>"
    inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-n>\<C-p>" : "\<PageDown>"
    " ultisnips
    if HasDirectory('ultisnips')
        " remap Ultisnips for compatibility
        let g:UltiSnipsNoPythonWarning = 0
        let g:UltiSnipsRemoveSelectModeMappings = 0
        let g:UltiSnipsExpandTrigger = "<Nop>"
        let g:UltiSnipsListSnippets = "<C-l><C-l>"
        let g:UltiSnipsJumpForwardTrigger = "<Tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
        " Ulti python version
        let g:UltiSnipsUsePythonVersion = g:python_version
        " tab for ExpandTrigger
        function! g:UltiSnips_Tab(num)
            if pumvisible()
                call UltiSnips#ExpandSnippet()
                if g:ulti_expand_res
                    return "\<Right>"
                else
                    if exists('v:completed_item') && empty(v:completed_item)
                        return "\<C-n>"
                    else
                        return "\<C-y>"
                    endif
                endif
            else
                call UltiSnips#JumpForwards()
                if g:ulti_jump_forwards_res
                    return "\<Right>"
                else
                    if a:num
                        return "\<Tab>"
                    else
                        return "\<Cr>"
                    endif
                endif
            endif
        endfunction
        au BufEnter * exec "inoremap <silent> <Tab> <C-R>=g:UltiSnips_Tab(1)<cr>"
        au BufEnter * exec "inoremap <silent> <C-j> <C-R>=g:UltiSnips_Tab(0)<cr>"
        smap <C-j> <Tab>
        smap <C-k> <S-Tab>
        " Ulti的代码片段的文件夹
        let g:UltiSnipsSnippetsDir = $PLUG_PATH."/leoatchina-snippets/UltiSnips"
        let g:UltiSnipsSnippetDirectories=["UltiSnips"]
    " neosnippet
    elseif HasDirectory('neosnippet')
        let g:neosnippet#enable_completed_snippet = 1
        smap <Tab> <Plug>(neosnippet_jump_or_expand)
        smap <C-j> <Plug>(neosnippet_jump_or_expand)
        function! g:NeoSnippet_Tab(num)
            if pumvisible()
                if neosnippet#expandable()
                    return neosnippet#mappings#expand_impl()
                elseif exists("v:completed_item") && empty(v:completed_item)
                    return "\<C-n>"
                else
                    return "\<C-y>"
                endif
            else
                if neosnippet#jumpable()
                    return neosnippet#mappings#jump_impl()
                else
                    if a:num
                        return "\<Tab>"
                    else
                        return "\<Cr>"
                    endif
                endif
            endif
        endfunction
        au BufEnter * exec "inoremap <silent> <Tab> <C-R>=g:NeoSnippet_Tab(1)<cr>"
        au BufEnter * exec "inoremap <silent> <C-j> <C-R>=g:NeoSnippet_Tab(0)<cr>"
        " Use honza's snippets.
        let g:neosnippet#snippets_directory=$PLUG_PATH.'/vim-snippets/snippets'
    endif
    " complete_parameter
    if HasDirectory("CompleteParameter.vim")
        inoremap <silent><expr> ; pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?complete_parameter#pre_complete("()"):";"
        inoremap <silent><expr> ( pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?complete_parameter#pre_complete("()"):"()\<left>"
        let g:complete_parameter_use_ultisnips_mapping = 1
    else
        inoremap <silent><expr> ; pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?"()\<left>":";"
    endif
    " run_tools
    if HasDirectory("vim-quickrun")
        nnoremap <M-r> :QuickRun<Cr>
        let g:quickrun_config={"_":{"outputter":"message"}}
        let s:quickfix_is_open = 0
        function! ToggleQuickfix()
            if s:quickfix_is_open
                cclose
                cclose
                let s:quickfix_is_open = 0
                execute s:quickfix_return_to_window . "wincmd w"
            else
                let s:quickfix_return_to_window = winnr()
                copen
                let s:quickfix_is_open = 1
            endif
        endfunction
        command! ToggleQuickfix call ToggleQuickfix()
        nnoremap <M-R> :ToggleQuickfix<cr>
    endif
    " syntax check
    if HasDirectory("ale")
        let g:ale_completion_enabled   = 0
        let g:ale_lint_on_enter        = 1
        let g:ale_lint_on_text_changed = 'always'
        " signs
        let g:ale_sign_column_always   = 1
        let g:ale_set_signs            = 1
        let g:ale_set_highlights       = 0
        let g:ale_sign_error           = 'E'
        let g:ale_sign_warning         = 'W'
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
        nnoremap <silent> <C-l><C-l> :ALELint<CR>
        nmap     <silent> <C-l><C-p> <Plug>(ale_previous_wrap)
        nmap     <silent> <C-l><C-n> <Plug>(ale_next_wrap)
        nnoremap <silent> gad        :ALEGoToDefinition<CR>
        nnoremap <silent> gat        :ALEGoToDefinitionInTab<CR>
        nnoremap <silent> gar        :ALEFindReferences<CR>
    elseif HasDirectory("syntastic")
        let g:syntastic_error_symbol             = 'E'
        let g:syntastic_warning_symbol           = 'W'
        let g:syntastic_check_on_open            = 0
        let g:syntastic_check_on_wq              = -1
        let g:syntastic_python_checkers          = ['flake8']
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
        nnoremap <silent> <C-l><C-l> :call ToggleErrors()<cr>
        nnoremap <silent> <C-l><C-p> :lprevious<cr>
        nnoremap <silent> <C-l><C-n> :lnext<cr>
    endif
    " asyncrun
    if HasDirectory("asyncrun.vim")
        let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
        function! s:ASYNC_RUN()
            exec "w"
            call asyncrun#quickfix_toggle(8,1)
            if &filetype == 'c'
                exec ":AsyncRun g++ % -o %<"
                exec ":AsyncRun -raw=1 ./%<"
            elseif &filetype == 'cpp'
                exec ":AsyncRun g++ % -o %<"
                exec ":AsyncRun -raw=1 ./%<"
            elseif &filetype == 'java'
                exec ":AsyncRun -raw=1 javac %"
                exec ":AsyncRun -raw=1 java %<"
            elseif &filetype == 'sh'
                exec ":AsyncRun -raw=1 bash %"
            elseif &filetype == 'python'
                if g:python_version == 3
                    exec ":AsyncRun -raw=1 python3 %"
                if g:python_version == 2
                    exec ":AsyncRun -raw=1 python %"
                else
                    echo "Cannot run without python support"
                endif
            elseif &filetype == 'perl'
                exec ":AsyncRun -raw=1 perl %"
            elseif &filetype == 'go'
                exec ":AsyncRun -raw=1 go run %"
            endif
        endfunction
        command! AsyncRunNow call s:ASYNC_RUN()
        nnoremap <C-a>r :AsyncRunNow<CR>
        nnoremap <C-a>s :AsyncStop<CR>
        nnoremap <C-a>a :AsyncRun
        au bufenter * if (winnr("$") == 1 && exists("AsyncRun!")) | q | endif
    endif
    " vim-repl
    if HasDirectory('vim-repl')
        nnoremap <C-b>o :REPLToggle<Cr>
        let g:sendtorepl_invoke_key = "<C-b>w"
        let g:repl_program = {
            \	"default": "bash",
        \ }
        if g:python_version == 2
            let g:repl_program.python = "python"
        elseif g:python_version == 3
            let g:repl_program.python = "python3"
        endif
        let g:repl_exit_commands = {
            \	"python": "quit()",
            \	"bash": "exit",
            \	"zsh": "exit",
            \	"default": "exit",
        \ }
    endif
endif
if filereadable(expand("~/.vimrc.after"))
    source ~/.vimrc.after
endif
