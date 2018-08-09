<!-- vim-markdown-toc GitLab -->

+ [中文介绍](#中文介绍)
+ [Introduction](#introduction)
+ [Requirements](#requirements)
+ [Install](#install)
    * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx)
    * [windows](#windows)
+ [Update](#update)
    * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-1)
    * [windows](#windows-1)
+ [Upgrade plugins](#upgrade-plugins)
    * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-2)
    * [windows](#windows-2)
+ [Delete](#delete)
    * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-3)
    * [Windows](#windows-3)
+ [How it works](#how-it-works)
+ [Main changes from spf13](#main-changes-from-spf13)
+ [Some features](#some-features)
+ [Main shortcuts](#main-shortcuts)
+ [Plugins and their shortcuts](#plugins-and-their-shortcuts)
    * [vim-plug](#vim-plug)
    * [ywvim中文输入法](#ywvim中文输入法)
    * [Markdown](#markdown)
    * [Themes Collentions](#themes-collentions)
    * [vim-easy-align](#vim-easy-align)
    * [auto-pairs](#auto-pairs)
    * [Complete Engines, vim 7.4+ is required](#complete-engines-vim-74-is-required)
        - [Smart Engines Selection](#smart-engines-selection)
        - [YouCompleteMe](#youcompleteme)
        - [deoplete](#deoplete)
        - [completor](#completor)
        - [ncm2](#ncm2)
        - [asyncomplete](#asyncomplete)
        - [neocomplete](#neocomplete)
        - [neocomplcache](#neocomplcache)
    * [Complete Snippets, vim 7.4+ is also required](#complete-snippets-vim-74-is-also-required)
        - [ultisnips](#ultisnips)
        - [neosnippet](#neosnippet)
    * [Syntax Check](#syntax-check)
        - [ale](#ale)
        - [styntastic](#styntastic)
    * [Search/Replace tools](#searchreplace-tools)
        - [FlyGrep](#flygrep)
        - [Ctrlsf](#ctrlsf)
        - [vim-multiple-cursors](#vim-multiple-cursors)
    * [RunTools](#runtools)
        - [vim-quickrun](#vim-quickrun)
        - [asyncrun](#asyncrun)
    * [language support](#language-support)
        - [Pymode for python](#pymode-for-python)
        - [vim-go for go](#vim-go-for-go)
        - [vim-perl](#vim-perl)
        - [php](#php)
        - [html](#html)
        - [javascript](#javascript)
        - [rust](#rust)
    * [nerdtree](#nerdtree)
    * [tagbar and vim-gutentags](#tagbar-and-vim-gutentags)
    * [undotree](#undotree)
    * [airline and lightline](#airline-and-lightline)
    * [fugitive](#fugitive)
    * [bioSyntax-vim](#biosyntax-vim)
    * [nerdcommenter](#nerdcommenter)
    * [Browser tools](#browser-tools)
        - [fzf.vim](#fzfvim)
        - [LeaderF](#leaderf)
        - [denite](#denite)
        - [ctrlp](#ctrlp)
    * [surround](#surround)
    * [repeat](#repeat)
    * [vim-easy-align](#vim-easy-align-1)
    * [EasyMotion](#easymotion)

<!-- vim-markdown-toc -->
# 中文介绍
原来的repo放在 [spf13-vim-leoatchina](https://github.com/leoatchina/spf13-vim-leoatchina)，因为原来一时脑抽，把中文字体放进去后导致体积较大，影响速度，所以重开一个repo并把windows下的工具分开，以增加clone速度。

这里是我本人的vim配置，从spf13的[spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim) fork面来，作为几年前的作品，原配置已经不大适合这个vim8/neovim当道的时代。因此在近两年的使用时间里, 我不断调整，从其他人的配置中吸取经验，对参数进行微调，以适应在不同的系统环境条件下达到较好的使用体验。

长期以来，这个README一直处于远远落后于配置改变的进度，细碎调整特别是快捷键的改动，实在是提不劲来修改。近日来随着最后几个补全插件的加入和配置调整，这个配置文件已经比较完整，因此可以好好坐下来，对使用方法和注意点作一介绍。(其实,在这写这个文档的时候还在不停地改快捷键)

**PLEASE FORGIVE ME FOR MY POOR ENGLISH!!**

# Introduction
This is **leoatchina** vim config forked from [spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim). I sincerely thank him for great job. But in order to meet my furthers needs,I have changed lots of settings. And now it is suitable for vim/gvim/nvim for linux/max/windows

You can find spf13's origin config at http://vim.spf13.com or https://github.com/spf13/spf13-vim.

Hereafter is spf13's introduction to his vim config
> spf13-vim is a distribution of vim plugins and resources for Vim, Gvim and MacVim.It is a good starting point for anyone intending to use VIM for development running equally well on Windows, Linux, \*nix and Mac.


# Requirements
`Git 1.7` and `Vim7.0` with any of `+job`,`+python`,`+python3`,`+lua` is at least required， `Vim8` or `neovim` and `Git 2.0+` is prefered for advanced fearutures

And I wish you have a basic understanding for vim, know how to read the config files to find what I not mention here.

# Install
## Linux, \*nix, Mac OSX
```bash
  git clone https://github.com/leoatchina/leoatchina-vim.git
  cd leoatchina-vim
  ./install.sh
```
## windows
```bash
  git clone https://github.com/leoatchina/tools-leoatchina-vim.git
  cd leoatchina-vim
  click setup.cmd with administrator rights
  open vim, do :PlugInstall
```

# Update
## Linux, \*nix, Mac OSX
```bash
  ./install.sh ,chosse y|Y, the scipt will do git pull and do reinstall plugins
```
## windows
```bash
  cd leoatchina-vi#m
  git pull
  open vim, do :PlugReinstall
```

# Upgrade plugins
## Linux, \*nix, Mac OSX
```bash
  cd leoatchina-vim
  ./updata.sh
```
OR
```bash
  ~/.vimrc.update
```
OR
```bash
  open vim; do :PlugNew
```
## windows
```bash
  open vim; do :PlugNew
```
# Delete
## Linux, \*nix, Mac OSX
```bash
  cd leoatchina-vim
  ./uninstall.sh
```
## Windows
```bash
  click delete.cmd with administrator rights
```

# How it works
After the installation, a `.vimrc`symbol link in the `~` folder (for neovim, to its config file `~/.config/nvim/init.vim` in Linux ) which links to the `.vimrc` file in the `leoatchina-vim` folder.

The `.vimrc` or `init.vim` sources `~/.vimrc.plug` for plugins definition, and `~/.vimrc.plug` sources `~/.vimrc.local` when the file exists, the `local` file contains an import variable called `g:plug_groups` for the supporting features for vim, and you do `:PlugClean`, `:PlugInstall`, the plugsin will change. The default contents of `.vimrc.local` is
> let g:plug_groups=['smartcomplete', 'php', 'javascript', 'html', 'snippet']

And you can also create `~/.gvimrc.local` for `gvim`, `~/.nvimrc.local` for `nvim` to intall diffent plugins for gvim and nvim. If these two local file not exist, `.vimrc.local` works.

The typical variables that could be add to `g:plug_groups` are `pymode`,`go`,`airline`, `youcompleteme`, etc.

Here is a trick that I set diffent `PLUG_PATH` for `vim/gvim/neovim` , `~/.vim/plug` for `vim` , `~/.gvim/plug` for `gvim`, `~/.nvim/plug` for `neovim`.

`.vimrc.clean` it is an bash file which is set to delete `~/.vimswap` & `~/.vimviews` folders. Also be linked as `~/.vimrc.clean`

# Main changes from spf13
* use `vim-plug` instead of `vundle`, more quick and more smart
* totally simplify, delete `fork`,`before` files , which are redundent for most users
* delete lots of variables for feature settings
* just have mentioned before, the link is from the cloned folder
* not support **XP**

# Some features
* no backup file
* no backup
* no sound
* no scroll bars
* no menu, no tools when gui-running
* line number
* highlight search results
* smart indent
* In Visual, keep selection after indention change with `>`,`<`

# Main shortcuts
* `<Leader>` to `<Space>`, so the biggest key on keyboard is more usefull
* `<LocalLeader>` to **`\`**
* `<Leader>.` for number + 1, `<Leader>,` for number -1
* `<Leader><cr>`: source `~/.vimrc`. It is for config develop & debug myself
* `<LocalLeader><LocalLeader` for bracket jump
* `c-a` to the head of a line, `c-e` to end in normal/visual/inesert mode, compatible with linux
* `c-f`, `c-b`, `c-k`, `c-l`, `g` work like `Leader` key in normal mode
* `c-f` to right `c-b` to left in insert mode
* `c-x` instead of 'c-e' for fullscreen jump, pairs with `c-y`
* `c-p` invoke browser tools `fzf` or `LeaderF` or `denite` or `Ctrlp`
* `gc` for gcommit, `+` for `:Git`
* `~` instead of `Q`, and `Q` for quit current buffer at once
* `.` for exit visual mode
* `!` for `:!`
* `F1`: tab help
* `F2`: toggle search results highlight
* `F3`: show register strings
* `F4`: toggle quickrun windows
* `F5`: run script (with plugin [vim-quickrun](https://github.com/thinca/vim-quickrun))
* `F11`: full screen toggle, but sometimes not work
* `F12`: paste toggle
* tab/buffer control
    - set tabpagemax=10
    - cmap Tabe tabe
    - nnoremap <silent>-          :tabprevious<CR>
    - nnoremap <silent><Tab>      :tabnext<CR>
    - nnoremap <Leader>tp         :tabprevious<CR>
    - nnoremap <Leader>tn         :tabnext<CR>
    - nnoremap <Leader>-          :tabm -1<CR>
    - nnoremap <Leader><Tab>      :tabm +1<CR>
    - nnoremap <LocalLeader>-     :tabfirst<CR>
    - nnoremap <LocalLeader><Tab> :tablast<CR>
    - nnoremap <Leader>te         :tabe<Space>
    - nnoremap <Leader>ts         :tab  split<CR>
    - nnoremap <Leader>tw         :tabs<CR>
    - nnoremap <Leader>tm         :tabm<Space>
    - nnoremap <LocalLeader><Backspace> :buffers<CR>
    - nnoremap <LocalLeader>]           :bn<CR>
    - nnoremap <LocalLeader>[           :bp<CR>
* copy & paste
    - vnoremap <Leader>y  "+y
    - nnoremap <Leader>y  "+y
    - nnoremap <Leader>yy "+yy
    - nnoremap <Leader>Y  "*y
    - vnoremap <Leader>Y  "*y
    - nnoremap Y y$
    - vnoremap Y *y$
    - nnoremap <Leader>p "+p
    - nnoremap <Leader>P "*P
    - vnoremap <Leader>p "+p
    - vnoremap <Leader>P "*P
* Some other shortcuts
    - nmap <C-f>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    - nnoremap <Leader>fd :set nofoldenable! nofoldenable?<CR>
    - nnoremap <Leader>fw :set nowrap! nowrap?<CR>
    - nmap <Leader>w :w<CR>
    - nmap <Leader>W :wq!<CR>
    - nmap <Leader>WQ :wa<CR>:q<CR>
    - nmap <Leader>q :q!
    - nmap <Leader>Q :qa!
    - nmap <Leader>\ :vsplit<Space>
    - nmap <Leader><Leader>\ :split<Space>
    - nmap <Leader>= <C-W>=
    - nmap <Leader><Down> :resize -3<CR>
    - nmap <Leader><Up>   :resize +3<CR>
    - nmap <Leader><Left> :vertical resize -3<CR>
    - nmap <Leader><Right>:vertical resize +3<CR>
    - vnoremap < <gv
    - vnoremap > >gv
    - nnoremap < <<
    - nnoremap > >>

# Plugins and their shortcuts
Hereafter are the plugins that I collected, theirs links looks blue, if you want details for them, click it.

Just as I have mentioned, the `~/.vimrc.local` contains the fearutures that you need.For example, if you want syntax check, you can open it and add ``syntax`` in the list `g:plug_groups`, then rerun `install.sh` or `:PlugReinstall`, the plugins `ale` for `vim8`/`neovim` , or `syntastic` for `vim7.3+` will be installed.

You can open `.vimrc.plugs` for these features

## [vim-plug](https://github.com/junegunn/vim-plug)
A smart and parallel plug manage plugin, instead of [vundle](https://github.com/VundleVim/Vundle.vim) which spf13 use.
You can check how it is installed via `install.sh` or `setup.cmd`

## [ywvim中文输入法](https://github.com/leoatchina/ywvim)
这个介绍我用中文写因为老外用不到。`ywvim`中文输入法,在`insert`模式下t过**CTRL+\**开启,**CTRL+^**进行配置。`;`临时英文输入法;注意,默认只输入**英文状态**的标点;`z`临时拼音;`,.-=`上下翻页。开启办法: 要在 `~/.vimrc.local`里的`g:plug_groups`加入`wubi`(五笔)或者`pinyin`(拼音).

## Markdown
Markdown styntastic hightlight by default, and if has gui with python support, [markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim) and relative plugins will be installed, then `C-z` for preview in browser, `C-s` for stop preview, `C-q` for `:Voom markdown`(with [voom](https://github.com/vim-voom/VOoM))

This `README` is written mostly macvim, and Atom.

## [Themes Collentions](https://github.com/leoatchina/vim-colorschemes-collections)
Forked from [rafi's colorschemes collections](rafi/awesome-vim-colorschemes), keeped some xterm-256 compatible themes which I prefer. Run `:colorschemes` followed by `Tab` will show  these themes.
Default themes:
- [gruvbox](https://github.com/morhetz/gruvbox) for vim
- [hybrid_material](https://github.com/kristijanhusak/vim-hybrid-material) for gvim
- [wombat256](https://github.com/vim-scripts/wombat256.vim) for neovim
- [onedark](https://github.com/joshdick/onedark.vim) for neovim with gui

## [vim-easy-align](https://github.com/junegunn/vim-easy-align)
```
    nmap <localleader><Cr> <Plug>(EasyAlign)
    vmap <Cr> <Plug>(EasyAlign)
```

## [auto-pairs](https://github.com/jiangmiao/auto-pairs)
```
    let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`'}
    let g:AutoPairsShortcutFastWrap   = "<C-b>f"
    let g:AutoPairsShortcutJump       = "<C-b>j"
    let g:AutoPairsShortcutBackInsert = "<C-b>i"
    inoremap <buffer> <silent> <C-h> <C-R>=AutoPairsDelete()<CR>
```

## Complete Engines, vim 7.4+ is required
**7** code-completion engines:`deoplete`, `ncm2`, `asyncomplete`, `completor`, `neocomplete`, `neocomplcache` and `YouCompleteMe`.

### Smart Engines Selection
There is variable `"smartcomplete"` in `"g:plug_groups"` contained in `.vimrc.local`, it means .vimrc will choose the completion engine according to the vim enviroment if `vim8/neovim` or `old version`, `python2/3` or `no python`, `windows` or `linux` or `mac`.
I strongly advice you updete to vim8.0+ or neovim for advanced engine with better performance.

By default, when `neovim` and `python3` support, `deoplete` for windows, `ncm2` for linux and mac, if nevovim without python, `asyncomplete`. If vim8 , with python2/3 support in windows , `completor`, and `asyncomplete` other situation. These engines have their semantic complete fuction with the help from other plugins relatively, which will be also installed, and will change with `g:plug_groups`. For example, if `python` added to `g:plug_groups`, `deoplete-jedi` will also be installed with `deoplete`

If you are install older vim7.4- (default installed by ubuntu , centos), `has("lua")` will yank `neocomplete`, and `not` will be `neocomplcache`. The two `neo` engines has barely semantic completion funtions, their finishments are completed with snippets support

You can also force to install the completion engine in `g:plug_groups`, just replace `smartcomplete` with it, but if the vim feature and enviroment not support the plug you choose, the engine will fall to `neocomplcache`.

`youcompleteme` is the only complete engine that you must sepecially write into `g:plug_groups` while not be installed with `smartcomplete`, and is the one with the best performance. Since it is hard to install, I advice you not to write it in `.vimrc.local` only when you have a deep understanding to you system

It is such a complex to make all the completion shortcuts compatible, finally I used a series of unroute shortcuts when completion menu popup: `Tab` or `C-k` for trigger, if not triggered , switch to the next. `CR` or `C-j` for end completion(`C-e`, `C-y` still work ). `C-p`/`C-n` or `Up`/`Down` for previous/next selection.

### [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
YouCompleteMe is a fast, as-you-type, fuzzy-search code completion engine for Vim. It has several completion engines

Needs `python` or `python3`
> `nnoremap go :YcmCompleter GoToDefinitionElseDeclaration`

### [deoplete](https://github.com/Shougo/deoplete.nvim)
Deoplete is the abbreviation of "dark powered neo-completion". It provides an extensible and asynchronous completion framework for neovim/Vim8.Need `+python3`

### [completor](https://github.com/maralla/completor.vim)
Completor is an asynchronous code completion framework for vim8. New features of vim8 are used to implement the fast completion engine with low overhead. Need `+python3`

### [ncm2](https://github.com/ncm2/ncm2)
NCM2, formerly known as nvim-completion-manager, is a slim, fast and hackable completion framework for neovim. Require `+python3`

### [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim)
Provide async autocompletion for vim8 and neovim with timers. This repository is fork of https://github.com/roxma/nvim-complete-manager in pure vim script with python dependency removed. But if you want `python` support(actrually python3), you should `pip3 install python-language-server`

### [neocomplete](https://github.com/Shougo/neocomplete.vim)
neocomplete is the abbreviation of "neo-completion with cache". It provides keyword completion system by maintaining a cache of keywords in the current buffer.Use snippets for completion, faster than `neocomplcache`


### [neocomplcache](https://github.com/Shougo/neocomplcache.vim)
neocomplcache is the abbreviation of "neo-completion with cache". It provides keyword completion system by maintaining a cache of keywords in the current buffer. neocomplcache could be customized easily and has a lot more features than the Vim's standard completion feature.
**It is the last complete engine in this config , since it has the newst requirements choose**


## Complete Snippets, vim 7.4+ is also required
If complete_engine is `neocomplete` or `neocomplcache`,  snippets `ultisnips` or  `neosnippet` will be intalled. Otherwise need `snippet` in `~/.vimrc.local`
`C-l` will list the snips when use `ultisnips`, `C-f` for snips jump forward in snippets, and only `ultisnips` use `c-b` for jump back

### [ultisnips](https://github.com/SirVer/ultisnips)
Works if with python support.

### [neosnippet](https://github.com/Shougo/neosnippet.vim)
Works if without python support.

## Syntax Check
### [ale](https://github.com/w0rp/ale.git)
```
    nmap <C-l><C-l> :ALELint<CR>
    nmap <silent> <C-l>p <Plug>(ale_previous_wrap)
    nmap <silent> <C-l>n <Plug>(ale_next_wrap)
    nnoremap gt :ALEGoToDefinitionInTab<CR>
    nnoremap gd :ALEGoToDefinition<CR>
```

### [styntastic](https://github.com/vim-syntastic/syntastic.git)
Works is not fits the need of `ale`,

## Search/Replace tools
The main leader key is `C-f`,
### [FlyGrep](https://github.com/wsdjeg/FlyGrep.vim)
`<C-f><C-f>` to call the window

### [Ctrlsf](#)
```
    nmap <C-F>s <Plug>CtrlSFPrompt
    nmap <C-F>c <Plug>CtrlSFCwordPath
    nmap <C-F>p <Plug>CtrlSFPwordPath
    nmap <C-F>o :CtrlSFOpen<CR>
    nmap <C-F>t :CtrlSFToggle<CR>
    " vmap
    vmap <C-F>s <Plug>CtrlSFVwordExec
    vmap <C-F>f <Plug>CtrlSFVwordPath
```
### [vim-multiple-cursors](#)
```
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_start_word_key      = '<C-n>'
    let g:multi_cursor_select_all_word_key = '<leader><C-n>'
    let g:multi_cursor_start_key           = 'g<C-n>'
    let g:multi_cursor_select_all_key      = '<localleader><C-n>'
    let g:multi_cursor_next_key            = '<C-n>'
    let g:multi_cursor_prev_key            = '<C-\>'
    let g:multi_cursor_skip_key            = '<C-h>'
    let g:multi_cursor_quit_key            = '<ESC>'
```

## RunTools
### [vim-quickrun](https://github.com/thinca/vim-quickrun)
Use `F5` to run scripts. `F4` to toggle quickrun window

### [asyncrun](https://github.com/skywind3000/asyncrun.vim)
A async run plugin for vim8/nvim
```
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
```

## language support
### [Pymode for python](https://github.com/python-mode/python-mode)
If your major work is with python, it is the only plugin you need. However, its so huge that I prefer not using it.
`<Leader>R`:run scripts;`<BS>`:track_point toggle; need `pymode` in `g:plug_groups`
### [vim-go for go](https://github.com/fatih/vim-go)
vim-go requires at least Vim 7.4.1689 or Neovim 0.2.2. need `go` in `g:plug_groups`
### [vim-perl](https://github.com/vim-perl/vim-perl)
### php
### html
### javascript
### rust

## [nerdtree](https://github.com/scrooloose/nerdtree)
Togglekey:`<Leader>nn`, and key `<Leader>nt`

## [tagbar](https://github.com/majutsushi/tagbar) and [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
need `has("ctags")`. Togglekey:`<Leader>tt`

## [undotree](https://github.com/mbbill/undotree)
Just as it name. Togglekey:`<Leader>u`

## [airline](https://github.com/vim-airline-themes) and [lightline](https://github.com/itchyny/lightline.vim)
Beautifull statusline for advanced information of workspace, `airline` show more context than other statusline plugins, and more pleasing to eye. But it is heavy, so if **no** `"airline"` in `~/.vimrc.local`, `lightline` will work.

## [fugitive](https://github.com/tpope/vim-fugitive)
Git plugin. `gc` for `Gcommit`, and `+` for `:Git `

## [bioSyntax-vim](https://github.com/bioSyntax/bioSyntax-vim.git)
As a bionformtion worker, this plug is use in view bam/sam/vcf. need add `bio` in `~/.vimrc.local`

## [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
Hackable plugin, the most import key is ** `<Leader>c<Space>` **|NERDComToggleComment|**
You can get other shortcuts via the link.

## Browser tools
`C-p` to invoke one of the following plugs, major keys are `<Leader>lf`, `<Leader>lm`, please see `.vimrc` for details
You can install only one of them , by write the plugins name in `~/.vimrc.local`. `CtrlP` is the default one.

### [fzf.vim](https://github.com/junegunn/fzf.vim)
fzf runs asynchronously and can be orders of magnitude faster than similar Vim plugins.
### [LeaderF](https://github.com/Yggdroot/LeaderF)
This plugin is mainly used for locating files, buffers, mrus, tags in large project.
### [denite](https://github.com/Shougo/denite.nvim)
Denite is a dark powered plugin for Neovim/Vim to unite all interfaces. It can replace many features or plugins with its interface. It is like a fuzzy finder, but is more generic. You can extend the interface and create the sources.
### [ctrlp](https://github.com/ctrlpvim/ctrlp.vim)
Full path fuzzy file, buffer, mru, tag, ... finder for Vim. No need of python


## [surround](https://github.com/tpope/vim-surround)
plugin to add bracket for string，here after is from [<vim中的杀手级别的插件：surround>](http://zuyunfei.com/2013/04/17/killer-plugin-of-vim-surround/), **\*** is for the cursor position
```
   Old text                  Command     New text
   "Hello *world!"           ds"         Hello world!
   [123+4*56]/2              cs])        (123+456)/2
   "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
   if *x>3 {                 ysW(        if ( x>3 ) {
   my $str = *whee!;         vlllls'     my $str = 'whee!';
   <div>Yo!*</div>           dst         Yo!
   <div>Yo!*</div>           cst<p>      <p>Yo!</p>
```
command list
```
    Normal mode
    -----------

    ds  - delete a surrounding
    cs  - change a surrounding
    ys  - add a surrounding
    yS  - add a surrounding and place the surrounded text on a new line + indent it
    yss - add a surrounding to the whole line
    ySs - add a surrounding to the whole line, place it on a new line + indent it
    ySS - same as ySs
    Visual mode
    -----------
    s   - in visual mode, add a surrounding
    S   - in visual mode, add a surrounding but place text on new line + indent it
    Insert mode
    -----------
    <CTRL-g>s - in insert mode, add a surrounding
    <CTRL-g>S - in insert mode, add a new line + surrounding + indent
```

## [repeat](https://github.com/tpope/vim-repeat)
if has `surround`, use `.` to `repead`

## [vim-easy-align](https://github.com/junegunn/vim-easy-align)

## [EasyMotion](https://github.com/easymotion/vim-easymotion)
```
    nmap <C-j><C-j> <Plug>(easymotion-w)
    nmap <C-k><C-k> <Plug>(easymotion-b)
```
