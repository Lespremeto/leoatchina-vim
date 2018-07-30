
<!-- vim-markdown-toc GitLab -->

+ [中文介绍](#中文介绍)
+ [PLEASE FORGIVE  MY POOL ENGLISH！](#please-forgive-my-pool-english)
+ [Introduction](#introduction)
+ [Main files](#main-files)
+ [Install](#install)
    * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx)
    * [windows](#windows)
+ [Upgrade to the latest version](#upgrade-to-the-latest-version)
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
    * [Themes Collentions](#themes-collentions)
    * [Completion method](#completion-method)
        - [Completion shortcuts](#completion-shortcuts)
    * [SmartComplete Engines](#smartcomplete-engines)
    * [Snippets](#snippets)
        - [YouCompleteMe](#youcompleteme)
        - [deoplete](#deoplete)
        - [completor](#completor)
        - [ncm2](#ncm2)
        - [asyncomplete](#asyncomplete)
        - [neocomplete](#neocomplete)
        - [neocomplcache](#neocomplcache)
    * [nerdtree](#nerdtree)
    * [tagbar and vim-gutentags](#tagbar-and-vim-gutentags)
    * [VOoM](#voom)
    * [undotree](#undotree)
        - [airline and lightline](#airline-and-lightline)
    * [ywvim中文输入法](#ywvim中文输入法)
    * [fugitive](#fugitive)
    * [scrooloose/nerdcommenter](#scrooloosenerdcommenter)
    * [Browser tools](#browser-tools)
        - [fzf.vim](#fzfvim)
        - [LeaderF](#leaderf)
        - [denite](#denite)
        - [ctrlp](#ctrlp)
    * [Pymode](#pymode)
    * [surround](#surround)

<!-- vim-markdown-toc -->
# 中文介绍
原来的repo放在 [spf13-vim-leoatchina](https://github.com/leoatchina/spf13-vim-leoatchina)，因为原来一时脑抽，把中文字体放进去后导致体积较大，影响速度，所以重开一个repo并把windows下的工具分开，以增加clone速度。

这里是我本人的vim配置，从spf13的[spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim) fork面来，作为几年前的集大成者，原配置已经不大适合这个vim8/neovim当道的时代。因此我作了非常大的调整，commit了1千多次(两个repo加起来)，不断地从其他人的配置中吸取经验，对参数进行微调，以适应在不同的系统环境条件下达到较好的使用体验。

长期以来，这个README一直处于远远落后于配置改变的进度，细碎调整特别是快捷键的改动，实在是提不劲来修改。近日来随着最后几个补全插件的加入和配置调整，这个配置文件基本上没有大的漏洞，可以好好坐下来，写下这个文档。

# PLEASE FORGIVE  MY POOL ENGLISH！

# Introduction
This is **leoatchina** vim config forked from [spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim). I sincerely thank him for great job. But meet my needs,I have changed lots of settings. And now it is suitable for vim/gvim/nvim for linux/max/windows

You can find spf13's origin config at http://vim.spf13.com or https://github.com/spf13/spf13-vim.

Hereafter is spf13's introduction to his vim config
> spf13-vim is a distribution of vim plugins and resources for Vim, Gvim and MacVim.
 It is a good starting point for anyone intending to use VIM for development running equally well on Windows, Linux, \*nix and Mac.

# Main files
* `.vimrc` main configuration file. Settings of shortcuts, settings, themes, fuctions.
* `.vimrc.plug` plugins install file.
* `.vimrc.clean` it is an bash file which is set to delete .vimswap & .vimviews folders.
* `.vimrc.local` basic features, will be copied to %HOME%, it contains an important variable `g:plug_groups` which is the features of the config, if you want add/del some features, change it.
`let g:plug_groups=['smartcomplete', 'python', 'php', 'javascript', 'html']`

# Install
*`Git 1.7` and `Vim7.3` is at least required， `Vim8` or `neovim` and Git 2.0+ is prefered for advanced fearutures*

## Linux, \*nix, Mac OSX
need `curl`
```bash
  git clone https://github.com/leoatchina/leoatchina-vim.git
  cd leoatchina-vim
  ./install.sh
```
## windows
```bash
  git clone https://github.com/leoatchina/tools-leoatchina-vim.git
  cd leoatchina-vim
  click setup.cmd with admin rights
  open vim, do :PlugInstall
```
# Upgrade to the latest version
## Linux, \*nix, Mac OSX
```bash
  ./install.sh ,chosse y|Y, the scipt will do git pull and do reinstall plugins
```
## windows
```bash
  cd leoatchina-vim
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
  open gvim; do :PlugNew
```
# Delete
## Linux, \*nix, Mac OSX
```bash
  cd leoatchina-vim
  ./uninstall.sh
```
## Windows
```bash
  click delete.cmd with admin rights
```
# How it works
After the installation, a `.vimrc`symbol link in the `~` folder (for neovim, in its config file, such as `~/.config/nvim/init.vim` for Linux ) which links to the `.vimrc` file in the `leoatchina-vim` folder.

The `.vimrc`/`init.vim` sources `~/.vimrc.plug` for plugins, and `~/.vimrc.plug` sources `~/.vimrc.local` when the file exists, the `local` file contains some features for vim and `:PlugInstall` will change according to it.

Here is a trick that I set diffent `PLUG_PATH` for `vim/gvim/neovim` , `~/.vim/plug` for `vim` , `~/.gvim/plug` for `gvim`, `~/.nvim/plug` for `neovim`.

And also `~/.gvimrc.local` for `gvim`, `~/.nvimrc.local` for `nvim`, it former two not exist, `.vimrc.local` works if exists

# Main changes from spf13
- use `vim-plug` instead of `vundle`, more quick and more smart
- simplify, delete `fork`,`before` files , which are redundent for most users
- delete lots of variables for feature settings
- just have mentioned before, the link is from the cloned folder
- not support **XP**

# Some features
* no backup file
* no backup
* no sound
* no scroll bars
* no menu, no tools when gui-runnin
* line number
* highlight search
* smart indent
* In Visual, keep selection after indention change with `>`,`<`

# Main shortcuts
* `<Leader>` to `<Space>`, so the biggest key on keyboard is more usefull
* `<LocalLeader>` to `\`
* `<Leader>.` for number + 1, `<Leader>,` for number -1
* `<Leader><cr>`: source `~/.vimrc`. It is for config develop & debug myself
* `<LocalLeader><LocalLeader` for bracket jump
* `c-a` to the head of a line, `c-e` to end in normal/visual/inesert mode, compatible with linux
* `c-f`,`c-k`, `c-l`,`g` work like `Leader` key in normal mode
* `c-f` to right `c-b` to left in insert mode
* `c-x` instead of 'c-e' for fullscreen jump, pairs with `c-y`
* `c-b` for plugins `ctrlp` or `fzf` or `LeaderF` or `denite` in normal mode
* `~` instead of `Q`, and `Q` for quit current buffer at once
* `.` for exit visual mode
* `!` for `:!`
* `F1`: tab help
* `F2`: toggle search results highlight
* `F3`: show register srings
* `F4`: toggle quickrun windows
* `F5`: run script (with plugin [vim-quickrun](https://github.com/thinca/vim-quickrun))
* `F11`: full screen toggle, but sometimes not work
* `F12`: paste toggle
* `gc` for gcommit, `+` for `:Git`
* tab/buffer control
```
    set tabpagemax=10 " Only show 10 tabs
    cmap Tabe tabe
    " s-tab not work in Xshell
    nnoremap <silent>-          :tabprevious<CR>
    nnoremap <silent><Tab>      :tabnext<CR>
    nnoremap <Leader>tp         :tabprevious<CR>
    nnoremap <Leader>tn         :tabnext<CR>
    nnoremap <Leader>-          :tabm -1<CR>
    nnoremap <Leader><Tab>      :tabm +1<CR>
    nnoremap <LocalLeader>-     :tabfirst<CR>
    nnoremap <LocalLeader><Tab> :tablast<CR>
    nnoremap <Leader>te         :tabe<Space>
    nnoremap <Leader>ts         :tab  split<CR>
    nnoremap <Leader>tw         :tabs<CR>
    nnoremap <Leader>tm         :tabm<Space>
    " buffer switch
    nnoremap <LocalLeader><Backspace> :buffers<CR>
    nnoremap <LocalLeader>]           :bn<CR>
    nnoremap <LocalLeader>[           :bp<CR>
```
* copy & paste
```
    vnoremap <Leader>y  "+y
    nnoremap <Leader>y  "+y
    nnoremap <Leader>yy "+yy
    nnoremap <Leader>Y  "*y
    vnoremap <Leader>Y  "*y
    nnoremap Y y$
    vnoremap Y *y$
    nnoremap <Leader>p "+p
    nnoremap <Leader>P "*P
    vnoremap <Leader>p "+p
    vnoremap <Leader>P "*P
```
* Some other shortcuts
```
    " Find merge conflict markers
    nmap <C-f>c /\v^[<\|=>]{7}( .*\|$)<CR>
    " and ask which one to jump to
    nmap <C-f>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " toggleFold
    nnoremap <Leader>fd :set nofoldenable! nofoldenable?<CR>
    " toggleWrap
    nnoremap <Leader>fw :set nowrap! nowrap?<CR>
    nmap <Leader>w :w<CR>
    nmap <Leader>W :wq!<CR>
    nmap <Leader>WQ :wa<CR>:q<CR>
    nmap <Leader>q :q!
    nmap <Leader>Q :qa!
    " split windows
    nmap <Leader>\ :vsplit<Space>
    nmap <Leader><Leader>\ :split<Space>
    nmap <Leader>= <C-W>=
    " resize spilted windows
    nmap <Leader><Down> :resize -3<CR>
    nmap <Leader><Up>   :resize +3<CR>
    nmap <Leader><Left> :vertical resize -3<CR>
    nmap <Leader><Right>:vertical resize +3<CR>
    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv
    nnoremap < <<
    nnoremap > >>
```

# Plugins and their shortcuts
hereafter are the plugins that I collected, theirs links looks blue, if you want details for them, click it.

Just as I have told, the `~/.vimrc.local` contains the fearutures that you need.For example, if you want syntax check, you can open it and add ``syntax`` in the list `g:plug_groups`, then rerun `install.sh` or `:PlugReinstall`, the plugins `ale` for `vim8`/`neovim` , or `syntastic` for `vim7.3+` will be installed.

You can open `.vimrc.plugs` for these features

## [vim-plug](https://github.com/junegunn/vim-plug)
A smart and parallel plug manage plugin, instead of [vundle](https://github.com/VundleVim/Vundle.vim) which spf13 use.
You can check how it is installed via install.sh or setup.cmd


## [Themes Collentions](https://github.com/leoatchina/vim-colorschemes-collections)
Forked from [rafi's colorschemes collections](rafi/awesome-vim-colorschemes), keeps some xterm-256 compatible themes which I prefer. Run `:colorschemes` followed by `Tab` will show  the themes.Default themes
  - [gruvbox](https://github.com/morhetz/gruvbox) for vim
  - [hybrid_material](https://github.com/kristijanhusak/vim-hybrid-material) for gvim
  - [wombat256](https://github.com/vim-scripts/wombat256.vim) for neovim
  - [onedark](https://github.com/joshdick/onedark.vim) for neovim with gui

## Completion method
**7** code-completion engines:`deoplete`, `ncm2`, `asyncomplete`, `completor`, `neocomplete`, `neocomplcache` and `YouCompleteMe`.

**2** complete snippets: `ultisnips`, `neosnippet`

### Completion shortcuts
It is such a complex to make the completion shorcuts compatible, finally I used a series of unroute shorcuts when completion menu popup: `Tab` or `C-k` for trigger, if not triggered , switch to the next. `CR` or `C-j` for end completion(`C-e`, `C-y` still work ). `C-p`/`C-n` or `Up`/`Down` for previous/next selection.

## SmartComplete Engines
There is a `smartcomplete` in `g:plug_groups` in `.vimrc.local`, it means the .vimrc will choose the completion engine according to the vim enviroment if `vim8/neovim` or `version <800`, `python3/2` or `no python`, `windows` or not. I strongly advice you updete to vim8.0+ or neovim for advanced engine with better performance.

By default, when neovim and python3 support, `deoplete` for windows, `ncm2` for linux and mac, if nevovim without python, `asyncomplete`. If vim8 , with python2/3 support in windows , `completor`, and `asyncomplete` other situation. These engines have their semantic complete fuction with the help from other plugins relatively, which will be also installed, and will change with `g:plug_groups`. For example, if `python` added to `g:plug_groups`, `deoplete-jedi` will also be installed with `deoplete`

If you are install older vim7.3 (default installed by ubuntu apt-get, centos yum), if `has("lua")` will yank `neocomplete`, and `not` will be `neocomplcache`. The two `neo` engines has semantic completion funtion, theirs finishment is completed with snippets support

You can also force to install the completion engine in `g:plug_groups`, just replace `smartcomplete` with it, but if the vim feature and enviroment not support the plug you choose, the engine will fall to `neocomplcache`.

`youcompleteme` is the only complete engine that you must sepecially write into `g:plug_groups`, and is the one with the best performance. Since it is hard to install, I advice you not write it to `.vimrc.local` only you have a deep understanding to you system

## Snippets
If engine is setted, by default, with vim7.4+ and python support, `ultisnips` is used, otherwise `neosnippet`
`C-l` will list the snips when use `ultisnips`, `c-f` for snips jump forword in both snippets, and only `ultisnips` has `c-b` for jump back

### [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
YouCompleteMe is a fast, as-you-type, fuzzy-search code completion engine for Vim. It has several completion engines
`nnoremap gt :YcmCompleter GoToDefinitionElseDeclaration`


### [deoplete](https://github.com/Shougo/deoplete.nvim)
Deoplete is the abbreviation of "dark powered neo-completion". It provides an extensible and asynchronous completion framework for neovim/Vim8.

### [completor](https://github.com/maralla/completor.vim)
Completor is an asynchronous code completion framework for vim8. New features of vim8 are used to implement the fast completion engine with low overhead. Require `python3`

### [ncm2](https://github.com/ncm2/ncm2)
NCM2, formerly known as nvim-completion-manager, is a slim, fast and hackable completion framework for neovim. Require `python3`

### [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim)
Provide async autocompletion for vim8 and neovim with timers. This repository is fork of https://github.com/roxma/nvim-complete-manager in pure vim script with python dependency removed.
But if you want `python` support, you should `pip3 install python-language-server`

### [neocomplete](https://github.com/Shougo/neocomplete.vim)
neocomplete is the abbreviation of "neo-completion with cache". It provides keyword completion system by maintaining a cache of keywords in the current buffer.

### [neocomplcache](https://github.com/Shougo/neocomplcache.vim)

neocomplcache is the abbreviation of "neo-completion with cache". It provides keyword completion system by maintaining a cache of keywords in the current buffer. neocomplcache could be customized easily and has a lot more features than the Vim's standard completion feature.
It is the last complete engine the config choose


## [nerdtree](https://github.com/scrooloose/nerdtree)
Togglekey:`<Leader>nn`, and key `<Leader>nt`

## [tagbar](https://github.com/majutsushi/tagbar) and [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
need `has("ctags")`. Togglekey:`<Leader>tt`

## [VOoM](https://github.com/vim-voom/VOoM)
VOoM (Vim Outliner of Markups) is a plugin for Vim that emulates a two-pane text outliner.
<Leader>vt :VoomToggle

##[undotree](https://github.com/mbbill/undotree)
Togglekey:`<Leader>u`

### [airline](https://github.com/vim-airline-themes) and [lightline](https://github.com/itchyny/lightline.vim)
`airline` show more context than other statusline plugins, and more pleasing to eye. But it needs more computer resource, so if **not** add `"airline"` in `g:plug_groups`, `lightline` will work.

## [ywvim中文输入法](https://github.com/leoatchina/ywvim)
这个介绍我用中文写因为老外用不到。`ywvim`中文输入法,在`insert`模式下通过`CTRL+@`或`CTRL+\`开启,`CTRL+^`进行配置。快捷键:`;`临时英文输入法;注意,默认只输入**英文状态**的标点;`z`临时拼音;`,.-=`上下翻页;要在 `~/.vimrc.local`里的`g:plug_groups`加入`"wubi"`或者`"pinyin"`

## [fugitive](https://github.com/tpope/vim-fugitive)
Git plugin

## [scrooloose/nerdcommenter](https://github.com/scrooloose/nerdcommenter)
  * `[count]<Leader>cc` **|NERDComComment|**
    Comment out the current line or text selected in visual mode.
  * `[count]<Leader>cn` **|NERDComNestedComment|**
    Same as <Leader>cc but forces nesting.
  * `[count]<Leader>c<Space>` **|NERDComToggleComment|**
    Toggles the comment state of the selected line(s). If the topmost selected line is commented, all selected lines are uncommented and vice versa.
  * `[count]<Leader>cm` **|NERDComMinimalComment|**
    Comments the given lines using only one set of multipart delimiters.
  * `[count]<Leader>ci` **|NERDComInvertComment|**
    Toggles the comment state of the selected line(s) individually.
  * `[count]<Leader>cs` **|NERDComSexyComment|**
    Comments out the selected lines with a pretty block formatted layout.
  * `[count]<Leader>cy` **|NERDComYankComment|**
    Same as <Leader>cc except that the commented line(s) are yanked first.
  * `<Leader>cA` **|NERDComAppendComment|**
    Adds comment delimiters to the end of line and goes into insert mode between them.
  * **|NERDComInsertComment|**
    Adds comment delimiters at the current cursor position and inserts between. Disabled by default.
  * `<Leader>ca` **|NERDComAltDelim|**
    Switches to the alternative set of delimiters.
  * `[count]<Leader>cl`
    `[count]<Leader>cb` **|NERDComAlignedComment|**
    Same as **|NERDComComment|** except that the delimiters are aligned down the left side (`<Leader>cl`) or both sides (`<Leader>cb`).
  * `[count]<Leader>cu` **|NERDComUncommentLine|**
    Uncomments the selected line(s).

## Browser tools
### [fzf.vim](https://github.com/junegunn/fzf.vim)

### [LeaderF](https://github.com/Yggdroot/LeaderF)
在高级模式的情况下会选用这个插件

### [denite](https://github.com/Shougo/denite.nvim)

### [ctrlp](https://github.com/ctrlpvim/ctrlp.vim)

`ctrl+p`启动插件,`<Leader>fu`启动funksky函数查询功能,在启动后,用`Ctrl+f`,`Ctrl+b`在不同模式中切换.
在文件列表中,`Ctrl+k/j`或者方向键向上/下选择文件,`t`在新标签里打开文件.其他快捷键见[ctrlp中文介绍](http://blog.codepiano.com/pages/ctrlp-cn.light.html)

## [Pymode](https://github.com/python-mode/python-mode)
`python`用的插件,具有语法检查,调试等功能.`<Leader>R`:运行脚本;`<LocalLeader>p`:track_point toggle

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
*command list*
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
    Insert mode "不建议使用,特别是ctrl-s会引起屏幕halt的情况下
    -----------
    <CTRL-s> - in insert mode, add a surrounding
    <CTRL-s><CTRL-s> - in insert mode, add a new line + surrounding + indent
    <CTRL-g>s - same as <CTRL-s>
    <CTRL-g>S - same as <CTRL-s><CTRL-s>
```
[repeat]

[vim-easy-align](https://github.com/junegunn/vim-easy-align)


[EasyMotion](https://github.com/easymotion/vim-easymotion)
 又一个杀手级别的插件

 1. 跳转到当前光标前后,快捷键`<Leader><Leader>w`和`<Leader><Leader>b`
 2. 搜索跳转,`<Leader><Leader>s`,然后输入要搜索的字母
 3. 行间/行内级别跳转,`<Leader><Leader>`再`hjkl`不解释
 4. 重复上一次的动作,`<Leader><Leader>.`
 5. 还可以`<Leader><Leader>f`和`<Leader><Leader>t`,不过不建议使用
