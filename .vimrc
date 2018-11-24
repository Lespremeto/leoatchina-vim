" This is leoatchina's vim config forked from https://github.com/spf13/spf13-vim
" Sincerely thank him for his great job, and I have made some change according to own requires.
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
    if has('nvim') || has('gui_running') && !OSX()
        return
    endif
    function! s:metacode(key)
        exec "set <M-".a:key.">=\e".a:key
    endfunc
    for i in range(26)
        call s:metacode(nr2char(char2nr('a') + i))
        call s:metacode(nr2char(char2nr('A') + i))
    endfor
    for i in range(10)
        call s:metacode(nr2char(char2nr('0') + i))
    endfor
    let s:list = ['-', ';', '/', ',', '.', '_', ':', '?']
    for c in s:list
        call s:metacode(c)
    endfor
    if has('gui_macvim')
        let a:letters_dict={
            \ '\':'«',
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
            \ '-':'–',
            \ ';':'…',
            \ '/':'÷',
            \ ',':'≤',
            \ '.':'≥',
            \ '_':'—',
            \ ':':'Ú',
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
            for m in ['nmap', 'vmap', 'smap', 'tmap']
                exec m." ".a:letters_dict[c]." <M-".c.">"
            endfor
        endfor
    endif
endfunc
command! -nargs=0 -bang ALTMetaMap call Alt_meta_map()
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
" Arrow Key Fix
" https://github.com/spf13/spf13-vim/issues/780
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif
" Use plugs config
if filereadable(expand("~/.vimrc.plugs"))
    source ~/.vimrc.plugs
endif
" leader key
let g:mapleader=' '
let g:maplocalleader = '\'
" 定义快捷键使用
nnoremap <leader><Cr> :source ~/.vimrc<CR>
cnoremap w!! w !sudo tee % >/dev/null
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
" Key reMappings
nnoremap <Cr> %
nnoremap * *``
nnoremap ! :!
vnoremap / y/<C-r>0
vnoremap ; y:%s/<C-r>0
vnoremap . :normal .<CR>
" gt to nop
nnoremap gt <Nop>
nnoremap gT <Nop>
vnoremap gt <Nop>
vnoremap gT <Nop>
snoremap gt <Nop>
snoremap gT <Nop>
" some ctrl+ key remap
nnoremap <C-s> <Nop>
nnoremap <C-q> <Nop>
nnoremap <C-z> <Nop>
nnoremap <C-g> <Nop>
nnoremap <C-f> <Nop>
vnoremap <C-f> <Nop>
snoremap <C-f> <Nop>
inoremap <C-f> <right>
cnoremap <C-f> <right>
inoremap <C-b> <Left>
cnoremap <C-b> <Left>
inoremap <C-k>; <C-x><C-u>
inoremap <C-k>, <C-x><C-o>
inoremap <C-k>. <C-x><C-v>
inoremap <C-l> <Nop>
" a,e for home/end
nnoremap gb ^
nnoremap gf $
vnoremap gb ^
vnoremap gf $<left>
inoremap <C-a> <Esc>I
inoremap <expr><silent><C-e> pumvisible()? "\<C-e>":"\<ESC>A"
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" use full double ctrl+ click
nnoremap <C-h><C-h> :set nohlsearch! nohlsearch?<CR>
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
nnoremap <leader><Tab>   :tabm +1<CR>
nnoremap <leader><S-Tab> :tabm -1<CR>
nnoremap <Leader>te      :tabe<Space>
nnoremap <Leader>tm      :tabm<Space>
nnoremap <Leader>ts      :tab  split<CR>
nnoremap <Leader>tS      :tabs<CR>
nnoremap gq              :tabclose<CR>
if has('gui_macvim')
    nnoremap <D-1> :tabn1<CR>
    nnoremap <D-2> :tabn2<CR>
    nnoremap <D-3> :tabn3<CR>
    nnoremap <D-4> :tabn4<CR>
    nnoremap <D-5> :tabn5<CR>
    nnoremap <D-6> :tabn6<CR>
    nnoremap <D-7> :tabn7<CR>
    nnoremap <D-8> :tabn8<CR>
    nnoremap <D-9> :tabn9<CR>
    nnoremap <D-0> :tablast<CR>
else
    nnoremap <M-1> :tabn1<CR>
    nnoremap <M-2> :tabn2<CR>
    nnoremap <M-3> :tabn3<CR>
    nnoremap <M-4> :tabn4<CR>
    nnoremap <M-5> :tabn5<CR>
    nnoremap <M-6> :tabn6<CR>
    nnoremap <M-7> :tabn7<CR>
    nnoremap <M-8> :tabn8<CR>
    nnoremap <M-9> :tabn9<CR>
    nnoremap <M-0> :tablast<CR>
endif
" buffer switch
nnoremap <localleader><BS> :buffers<CR>
nnoremap <localleader>[ :bp<CR>
nnoremap <localleader>] :bn<CR>
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
inoremap <S-Insert> <C-R>*
cnoremap <S-Insert> <C-R>*
" Easier horizontal scrolling
noremap zl zL
noremap zh zH
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <silent>j gj
noremap <silent>k gk
" for toggle highlight
nnoremap <leader>th :set nohlsearch! nohlsearch?<CR>
nnoremap <F6> :set nohlsearch! nohlsearch?<CR>
vnoremap <F6> :set nohlsearch! nohlsearch?<CR>
inoremap <F6> :set nohlsearch! nohlsearch?<CR>
cnoremap <F6> :set nohlsearch! nohlsearch?<CR>
snoremap <F6> :set nohlsearch! nohlsearch?<CR>
" show clipboard
nnoremap <leader>tr :reg<Cr>
nnoremap <S-F6> <ESC>:reg<Cr>
vnoremap <S-F6> <ESC>:reg<Cr>
inoremap <S-F6> <ESC>:reg<Cr>
cnoremap <S-F6> <ESC>:reg<Cr>
snoremap <S-F6> <ESC>:reg<Cr>
" pastetoggle (sane indentation on pastes)
nnoremap <leader>tp <ESC>:set nopaste! nopaste?<CR>
nnoremap <S-F12> <ESC>:set nopaste! nopaste?<CR>
vnoremap <S-F12> <ESC>:set nopaste! nopaste?<CR>
inoremap <S-F12> <ESC>:set nopaste! nopaste?<CR>
cnoremap <S-F12> <ESC>:set nopaste! nopaste?<CR>
snoremap <S-F12> <ESC>:set nopaste! nopaste?<CR>
" toggleFold
nnoremap <leader>tf :set nofoldenable! nofoldenable?<CR>
" toggleWrap
nnoremap <leader>tw :set nowrap! nowrap?<CR>
" for help
nnoremap <leader>TT :tab help<Space>
" 定义快捷键保存
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :wq!<CR>
nnoremap <Leader>WQ :wa<CR>:q<CR>
" quit
nnoremap ~ Q
nnoremap Q :bd!<Cr>
nnoremap <leader>q :q!<Cr>
nnoremap <Leader>Q :qa!
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
vnoremap << <gv
vnoremap >> >gv
"离开插入模式后关闭预览窗口
au InsertLeave * if pumvisible() == 0|pclose|endif
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
au BufNewFile,BufRead *.html.twig set filetype=html.twig
au BufNewFile,BufRead init.vim,.vimrc,.vimrc.local,.vimrc.plugs set filetype=vim
au BufNewFile,BufRead *.md,*.markdown,README set filetype=markdown
au BufNewFile,BufRead *.pandoc set filetype=pandoc
au BufNewFile,BufRead *.coffee set filetype=coffee
au BufNewFile,BufRead *.ts,*.vue set filetype=typescript
" sepcial setting for different type of files
au FileType python au BufWritePost <buffer> :%retab
au FileType python,vim setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
" Workaround vim-commentary for Haskell
au FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
au FileType haskell,rust setlocal nospell
" Remove trailing whiteSpaces and ^M chars
au FileType markdown,vim,c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,eperl,sql au BufWritePre <buffer>  call StripTrailingWhiteSpace()
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
        exec "normal! \<c-y>"
    elseif a:mode == 3
        exec "normal! \<c-e>"
    elseif a:mode == 4
        exec "normal! ".winheight('.')."\<c-y>"
    elseif a:mode == 5
        exec "normal! ".winheight('.')."\<c-e>"
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
endfunc
nnoremap <silent> <M-u> :call Tools_PreviousCursor(0)<cr>
nnoremap <silent> <M-d> :call Tools_PreviousCursor(1)<Cr>
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
    function! HasDirectory(dir)
        return isdirectory(expand($PLUG_PATH."/".a:dir))
    endfunction
    " full-screen
    if WINDOWS()
        if has('nvim')
            if HasDirectory('vim-fullscreen')
                let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
                let g:fullscreen#stop_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"
            endif
            let g:fullscreen#enable_default_keymap = 0
	        nmap <F11> <Plug>(fullscreen-toggle)
        else
            if has('libcall')
                let g:MyVimLib = $HOME."\\.vim-windows-tools\\gvimfullscreen.dll"
                function! ToggleFullScreen()
                    call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
                endfunction
                map <F11> <Esc>:call ToggleFullScreen()<CR>
                let g:VimAlpha = 240
                function! SetAlpha(alpha)
                    let g:VimAlpha = g:VimAlpha + a:alpha
                    if g:VimAlpha < 180
                        let g:VimAlpha = 180
                    endif
                    if g:VimAlpha > 255
                        let g:VimAlpha = 255
                    endif
                    call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
                endfunction
                nmap <silent><M-F12> <Esc>:call SetAlpha(+3)<CR>
                nmap <silent><M-F11> <Esc>:call SetAlpha(-3)<CR>
            endif
        endif
    endif
    " voom
    if HasDirectory('VOom')
        let g:voom_python_versions = [3,2]
        if has('gui_running')
            au FileType markdown nmap <silent> <C-q> :Voom markdown<Cr>
            au FileType markdown vmap <silent> <C-q> <ESC>:Voom markdown<Cr>
            au FileType markdown imap <silent> <C-q> <ESC>:Voom markdown<Cr>
        endif
        nmap <leader>tv :VoomToggle<CR>
        nmap <leader>tg :VoomQuit<CR>:Voom<CR><C-w>w
        let g:voom_tab_key = "<C-tab>"
        let g:voom_ft_modes = {
            \ 'markdown': 'markdown',
            \ 'pandoc': 'pandoc',
            \ 'c': 'fmr2',
            \ 'cpp': 'fmr2',
            \ 'python':'python',
            \ 'tex': 'latex'
        \ }
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
    " fugitive
    if HasDirectory("vim-fugitive")
        nnoremap gc    :Gcommit -a -v<CR>
        nnoremap g<Cr> :Git<Space>
        if HasDirectory("vim-signify")
            nnoremap gs :SignifyDiff<CR>
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
        if !isdirectory(g:startify_session_dir)
            silent! call mkdir(g:startify_session_dir, 'p')
        endif
        let g:startify_files_number = 8
        let g:startify_session_number = 8
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
        if has('gui_running') && has("termguicolors")
            " fix bug for vim
            set t_8f=^[[38;2;%lu;%lu;%lum
            set t_8b=^[[48;2;%lu;%lu;%lum
            " enable true color
            set termguicolors
            colorscheme tender
        elseif has('nvim')
            colorscheme hybrid
        else
            colorscheme deus
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
        " syntastic
        let g:airline#extensions#syntastic#enabled = 1
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
                let g:lightline.active.right = [
                    \ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
                    \ [ 'percent' ],
                \ [ 'filetype', 'fileformat', 'fileencoding', 'lineinfo']]
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
            endif
            if HasDirectory('coc.nvim')
                let g:lightline.component_function = {
                    \  'gitbranch': 'fugitive#head',
                    \  'readonly': 'LightlineReadonly',
                    \  'cocstatus': 'coc#status',
                \ }
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
    " ctags
    if HasDirectory("tagbar")
        let g:tagbar_sort = 0
        set tags=./.tags;,.tags
        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
        nnoremap <silent><leader>tt :TagbarToggle<CR>
        nnoremap <silent><leader>tj :TagbarOpen j<CR>
        nnoremap <C-]> <C-w><C-]>
        nnoremap <C-w><C-]> <C-]>
        nnoremap <C-\> <C-w><C-]><C-w>T
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
        " 配置 ctags 的参数
        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
        let $GTAGSLABEL = 'native-pygments'
    endif
    " indent_guides
    if HasDirectory("vim-indent-guides")
        nnoremap <leader>ti :IndentGuidesToggle<Cr>
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
        let g:AutoPairsShortcutToggle     = "<C-l>g"
        let g:AutoPairsShortcutFastWrap   = "<C-l>f"
        let g:AutoPairsShortcutJump       = "<C-l>j"
        let g:AutoPairsShortcutBackInsert = "<C-l>i"
        inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>
    endif
    " typecast
    if HasDirectory('typecast.vim')
        nmap <leader>tc <Plug>typecast
        xmap <leader>tc <Plug>typecast
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
        au BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
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
        vmap     <C-F>f <Plug>CtrlSFVwordPath
        vmap     <C-F>F <Plug>CtrlSFVwordExec
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
            nmap <C-h>\ :vsplit term://bash<Cr>i
            nmap <C-h>= :split  term://bash<Cr>i
            nmap <C-h>t :tabe   term://bash<Cr>i
            nmap <C-h>V :vsplit term://
            nmap <C-h>S :split  term://
            nmap <C-h>T :tabe   term://
        else
            nmap <C-h>\ :vertical terminal<cr>bash<cr>
            nmap <C-h>= :terminal<cr>bash<cr>
            nmap <C-h>t :tab terminal<Cr>bash<Cr>
            nmap <C-h>V :vertical terminal
            nmap <C-h>S :terminal
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
    " easymotion
    if HasDirectory("vim-easymotion")
        nmap <C-j><C-j> <Plug>(easymotion-w)
        nmap <C-k><C-k> <Plug>(easymotion-b)
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
    " browser tools
    if g:browser_tool == "LeaderF" && HasDirectory("LeaderF")
        let g:Lf_ShortcutF = '<C-k>j'
        let g:Lf_ReverseOrder = 1
        let g:Lf_PythonVersion = g:python_version
        let g:Lf_CacheDirectory = expand('$HOME/.cache/leaderf')
        if !isdirectory(g:Lf_CacheDirectory)
            silent! call mkdir(g:Lf_CacheDirectory, 'p')
        endif
        let g:Lf_ShortcutB = '<C-k>b'
        nnoremap <C-k>l :Leaderf
        nnoremap <C-k>f :LeaderfF
        nnoremap <C-k>b :LeaderfB
        nnoremap <C-k>m :LeaderfM
        let g:Lf_NormalMap = {
           \ "File":        [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
           \ "Buffer":      [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
           \ "Mru":         [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
           \ "Tag":         [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
           \ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
           \ "Colorscheme": [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
       \ }
    elseif g:browser_tool == 'fzf' && HasDirectory("fzf.vim")
        nnoremap <silent> <C-k>j :Files<CR>
        nnoremap <silent> <C-k>b :Buffers<CR>
        nnoremap <silent> <C-k>f :Filetypes<CR>
        nnoremap <silent> <C-k>g :GFiles?<CR>
        nnoremap <silent> <C-k>m :Maps<CR>
        nnoremap <silent> <C-k>c :Commits<CR>
        nnoremap <silent> <C-k>C :Colors<CR>
        nnoremap <silent> <C-k>h :History/<CR>
        " Mapping selecting mkppings
        nmap <C-k><tab> <plug>(fzf-maps-n)
        xmap <C-k><tab> <plug>(fzf-maps-x)
        omap <C-k><tab> <plug>(fzf-maps-o)
        imap <c-k><c-f> <plug>(fzf-complete-word)
        imap <c-k><c-p> <plug>(fzf-complete-path)
        imap <c-k><c-g> <plug>(fzf-complete-file-ag)
        imap <c-k><c-l> <plug>(fzf-complete-line)
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
    elseif HasDirectory("ctrlp.vim")
        let g:ctrlp_map = '<C-k>j'
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
        elseif executable('rg')
            set grepprg=rg\ --color=never
            let s:ctrlp_fallback = 'rg %s --color=never --glob ""'
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
            nnoremap <C-k>f :CtrlPFunky<Cr>
        endif
        nnoremap <C-k>m :CtrlPMRU<CR>
    endif
    " complete_engine
    set completeopt-=menu
    set completeopt-=preview
    set completeopt+=menuone
    if v:version >= 704 || has('nvim')
        set shortmess+=c
    endif
    if HasDirectory("YouCompleteMe") && g:complete_engine == "YCM"
        set completeopt+=noinsert,noselect
        if g:python_version == 2
            let g:ycm_python_binary_path = 'python'
        else
            let g:ycm_python_binary_path = 'python3'
        endif
        let g:ycm_key_invoke_completion = ['<C-Space>', '<C-k>;']
        " add_preview
        let g:ycm_add_preview_to_completeopt = 0
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
        nnoremap <silent>g<C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
    elseif HasDirectory("coc.nvim") && g:complete_engine == "coc"
        nnoremap <silent> gd <Plug>(coc-definition)
        nnoremap <silent> gy <Plug>(coc-type-definition)
        nnoremap <silent> gi <Plug>(coc-implementation)
        nnoremap <silent> gr <Plug>(coc-references)
        let g:coc_snippet_next = '<C-n>'
	    let g:coc_snippet_prev = '<C-p>'
        function! CocSetup()
            execute 'CocInstall coc-pyls coc-tsserver coc-html coc-json coc-css coc-wxml coc-vetur coc-java coc-rls'
            execute 'CocInstall coc-stylelint coc-eslint coc-tslint'
        endfunction
        command! -nargs=0 -bang CocSetup call CocSetup()
        " Show signature help while editing
        autocmd CursorHoldI * silent! call CocAction('showSignatureHelp')
        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')
        " Use `:Format` for format current buffer
        command! -nargs=0 Format :call CocAction('format')
        " Use `:Fold` for fold current buffer
        command! -nargs=? Fold :call CocAction('fold', <f-args>)
    elseif HasDirectory("deoplete.nvim") && g:complete_engine == "deoplete"
        set completeopt+=noinsert,noselect
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#enable_camel_case = 1
        " <BS>: close popup and delete backword char.
        inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
        if !has('nvim')
            let g:deoplete#enable_yarp = 1
        endif
        if HasDirectory('deoplete-jedi')
            let g:deoplete#sources#jedi#python_path = exepath('python3')
        endif
        if HasDirectory("LanguageClient-neovim")
            call deoplete#custom#source('LanguageClient',
                \ 'min_pattern_length',
                \ 2)
        else
            " omni completion is vim grep
            call deoplete#custom#option('omni_patterns', {
                \ 'java' :'[^. *\t]\.\w*',
                \ 'php'  :'[^. \t]->\h\w*\|\h\w*::',
                \ 'perl' :'\h\w*->\h\w*\|\h\w*::',
                \ 'c'    :'[^.[:digit:] *\t]\%(\.\|->\)',
                \ 'cpp'  :'[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
                \ 'go'   :'\h\w*\.\?',
                \})
            " keyword_patterns is python grep
            call deoplete#custom#option('keyword_patterns', {
                \ '_'    :'[a-zA-Z_]\k*',
                \ 'tex'  :'\\?[a-zA-Z_]\w*',
                \ 'ruby' :'[a-zA-Z_]\w*[!?]?',
                \})
        endif
        if HasDirectory('ultisnips')
            call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
        endif
    elseif HasDirectory("asyncomplete.vim") && g:complete_engine == "asyncomplete"
        set completeopt+=noinsert,noselect
        let g:asyncomplete_auto_popup = 1
        if v:version >= 800
            if has('nvim') || has('lua')
                let g:asyncomplete_smart_completion = 1
            endif
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
        \  }))
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
        if executable('pyls')
            au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
            \ })
        endif
        if HasDirectory('asyncomplete-tags.vim')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                \ 'name': 'tags',
                \ 'whitelist': ['c'],
                \ 'completor': function('asyncomplete#sources#tags#completor'),
                \ 'config': {
                \    'max_file_size': 50000000,
                \  },
            \ }))
        endif
        if HasPlug('typejavascript')
            au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tscompletejob#get_source_options({
                \ 'name': 'tscompletejob',
                \ 'whitelist': ['typescript'],
                \ 'completor': function('asyncomplete#sources#tscompletejob#completor'),
            \ }))
        endif
        if HasPlug('go')
            au User asyncomplete_setup  call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
                \ 'name': 'gocode',
                \ 'whitelist': ['go'],
                \ 'completor': function('asyncomplete#sources#gocode#completor'),
            \ }))
        endif
        if HasPlug('rust')
            au User asyncomplete_setup call asyncomplete#register_source(
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
    elseif HasDirectory("neocomplete.vim") && g:complete_engine == "neocomplete"
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
    elseif HasDirectory("neocomplcache.vim") && g:complete_engine == "neocomplcache"
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
        if OSX() && has('gui_running')
            smap <D-j> <Plug>(complete_parameter#goto_next_parameter)
            imap <D-j> <Plug>(complete_parameter#goto_next_parameter)
            smap <D-k> <Plug>(complete_parameter#goto_previous_parameter)
            imap <D-k> <Plug>(complete_parameter#goto_previous_parameter)
        else
            smap <M-j> <Plug>(complete_parameter#goto_next_parameter)
            imap <M-j> <Plug>(complete_parameter#goto_next_parameter)
            smap <M-k> <Plug>(complete_parameter#goto_previous_parameter)
            imap <M-k> <Plug>(complete_parameter#goto_previous_parameter)
        endif
    else
        inoremap <silent><expr> ; pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?"()\<left>":";"
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
        au FileType javascript nmap <C-g>j <Plug>(jsdoc)
    endif
    " php language
    if HasDirectory('phpcomplete.vim')
        let g:phpcomplete_mappings = {
           \ 'jump_to_def':        '<C-\><C-]>',
           \ 'jump_to_def_split':  '<C-]>',
           \ 'jump_to_def_vsplit': '<C-W><C-\>',
           \ 'jump_to_def_tabnew': '<C-\>',
           \}
    endif
    " html language
    if HasDirectory('emmet-vim')
        let g:user_emmet_leader_key='<C-g>'
    endif
    " Go language
    if HasDirectory("vim-go")
        let g:go_highlight_functions          = 1
        let g:go_highlight_methods            = 1
        let g:go_highlight_structs            = 1

        let g:go_highlight_build_constraints  = 1
        let g:go_gocode_propose_builtins      = 1
        let g:go_list_type                    = "quickfix"
        let g:go_fmt_command                  = "gofmt"
        let g:syntastic_go_checkers           = ['golint', 'govet']
        let g:syntastic_mode_map              = { 'mode': 'active', 'passive_filetypes': ['go'] }
        " Enable neosnippets when using go
        if g:complete_snippet == "neosnippet"
            let g:go_snippet_engine = "neosnippet"
        endif
        au FileType go nmap <C-g>i <Plug>(go-implements)
        au FileType go nmap <C-g>I <Plug>(go-info)
        au FileType go nmap <C-g>u <Plug>(go-rename)
        au FileType go nmap <C-g>r <Plug>(go-run)
        au FileType go nmap <C-g>b <Plug>(go-build)
        au FileType go nmap <C-g>t <Plug>(go-test)
        au FileType go nmap <C-g>d <Plug>(go-doc)
        au FileType go nmap <C-g>D <Plug>(go-doc-vertical)
        au FileType go nmap <C-g>c <Plug>(go-coverage)
    endif
    " java
    if HasDirectory("vim-javacomplete2")
        au FileType java setlocal omnifunc=javacomplete#Complete

        au FileType java nmap <C-g>i <Plug>(JavaComplete-Imports-AddSmart)
        au FileType java nmap <C-g>I <Plug>(JavaComplete-Imports-Add)
        au FileType java nmap <C-g>M <Plug>(JavaComplete-Imports-AddMissing)
        au FileType java nmap <C-g>U <Plug>(JavaComplete-Imports-RemoveUnused)

        au FileType java imap <C-g>i <Plug>(JavaComplete-Imports-AddSmart)
        au FileType java imap <C-g>I <Plug>(JavaComplete-Imports-Add)
        au FileType java imap <C-g>M <Plug>(JavaComplete-Imports-AddMissing)
        au FileType java imap <C-g>U <Plug>(JavaComplete-Imports-RemoveUnused)

        au FileType java nmap <C-g>m <Plug>(JavaComplete-Generate-Accessors)
        au FileType java nmap <C-g>c <Plug>(JavaComplete-Generate-Constructor)
        au FileType java nmap <C-g>t <Plug>(JavaComplete-Generate-ToString)
        au FileType java nmap <C-g>e <Plug>(JavaComplete-Generate-EqualsAndHashCode)
        au FileType java nmap <C-g>d <Plug>(JavaComplete-Generate-DefaultConstructor)

        au FileType java nmap <C-g>s <Plug>(JavaComplete-Generate-AccessorSetter)
        au FileType java nmap <C-g>g <Plug>(JavaComplete-Generate-AccessorGetter)
        au FileType java nmap <C-g>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
        au FileType java nmap <C-g>A <Plug>(JavaComplete-Generate-AbstractMethods)

        au FileType java imap <C-g>s <Plug>(JavaComplete-Generate-AccessorSetter)
        au FileType java imap <C-g>g <Plug>(JavaComplete-Generate-AccessorGetter)
        au FileType java imap <C-g>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
        au FileType java imap <C-g>A <Plug>(JavaComplete-Generate-AbstractMethods)

        au FileType java vmap <C-g>s <Plug>(JavaComplete-Generate-AccessorSetter)
        au FileType java vmap <C-g>g <Plug>(JavaComplete-Generate-AccessorGetter)
        au FileType java vmap <C-g>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

        au FileType java nmap <silent> <buffer> <C-g>n <Plug>(JavaComplete-Generate-NewClass)
        au FileType java nmap <silent> <buffer> <C-g>N <Plug>(JavaComplete-Generate-ClassInFile)
    endif
    if HasDirectory('vim-eclim')
        let g:EclimCompletionMethod = 'omnifunc'
        let s:project_tree_is_open = 0
        function! ToggleProjectTree()
            if s:project_tree_is_open
                call eclim#project#tree#ProjectTreeClose()
                let s:project_tree_is_open = 0
            else
                let s:winpos = winnr() + 1
                call eclim#project#tree#ProjectTree()
                let s:project_tree_is_open = 1
                execute s:winpos . "wincmd w"
            endif
        endfunctio
        command! ToggleProjectTree call ToggleProjectTree()
        nnoremap <leader>nt :ToggleProjectTree<Cr>
        nnoremap <leader>nl :ProjectList<Cr>
        nnoremap <leader>na :ProjectsTree<Cr>
        au FileType java nnoremap <C-g>pb :ProjectBuild<Cr>
        nnoremap <C-g>pp :Project
        nnoremap <C-g>pr :ProjectRefresh<Cr>
        nnoremap <C-g>pI :ProjectInfo<Cr>
        nnoremap <C-g>pd :ProjectCD<Cr>
        nnoremap <C-g>pc :ProjectLCD<Cr>
        nnoremap <C-g>pn :ProjectCreate<Space>
        nnoremap <C-g>pm :ProjectMove<Space>
        nnoremap <C-g>pi :ProjectImport<Space>
        nnoremap <C-g>po :ProjectOpen<Space>
    endif
    " preview tools, you have to map meta key in term
    if HasDirectory('vim-preview')
        nnoremap <C-p> :PreviewTag<Cr>
        nnoremap <M-p> :PreviewScroll -1<cr>
        nnoremap <M-n> :PreviewScroll +1<cr>
        nnoremap <M-s> :PreviewSignature!<Cr>
        nnoremap <M-q> :PreviewQuickfix<Space>
        nnoremap <M-G> :PreviewGoto<Space>
        nnoremap <M-F> :PreviewFile<Space>
        autocmd FileType qf nnoremap <silent><buffer> q :PreviewQuickfix<cr>
        autocmd FileType qf nnoremap <silent><buffer> Q :PreviewClose<cr>
    else
        nnoremap <C-p> :echo "<C-p> is mapped for vim-preview with gtags"<Cr>
    endif
    " run_tools
    if HasDirectory("vim-quickrun")
        nnoremap <C-b>r :QuickRun<Cr>
        nnoremap <F5> :QuickRun<Cr>
        cnoremap <F5> <Esc>:QuickRun<Cr>
        vnoremap <F5> <Esc>:QuickRun<Cr>
        snoremap <F5> <Esc>:QuickRun<Cr>
        inoremap <F5> <Esc>:QuickRun<Cr>
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
        nnoremap <C-b>q :ToggleQuickfix<cr>
        nnoremap <S-F5> :ToggleQuickfix<cr>
        vnoremap <S-F5> <Esc>:ToggleQuickfix<cr>
        snoremap <S-F5> <Esc>:ToggleQuickfix<cr>
        cnoremap <S-F5> <Esc>:ToggleQuickfix<cr>
        inoremap <S-F5> <Esc>:ToggleQuickfix<cr>
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
        nnoremap <silent> <C-l>p <Plug>(ale_previous_wrap)
        nnoremap <silent> <C-l>n <Plug>(ale_next_wrap)
        nnoremap <silent> gad :ALEGoToDefinition<CR>
        nnoremap <silent> gat :ALEGoToDefinitionInTab<CR>
        nnoremap <silent> gar :ALEFindReferences<CR>
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
        nnoremap <silent> <C-l>p :lprevious<cr>
        nnoremap <silent> <C-l>p :lnext<cr>
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
        nmap <C-b>a :AsyncRunNow<CR>
        nmap <C-b>s :AsyncStop<CR>
        nmap <C-b>g :AsyncRun
        au bufenter * if (winnr("$") == 1 && exists("AsyncRun!")) | q | endif
    endif
    " vim-repl
    if HasDirectory('vim-repl')
        nnoremap <C-b>t :REPLToggle<Cr>
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
