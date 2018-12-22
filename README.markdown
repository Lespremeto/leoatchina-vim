<!-- vim-markdown-toc GitLab -->

* [中文介绍](#中文介绍)
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Install](#install)
  * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx)
  * [windows](#windows)
* [Update](#update)
  * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-1)
  * [windows](#windows-1)
* [Upgrade plugins](#upgrade-plugins)
  * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-2)
  * [windows](#windows-2)
* [Delete](#delete)
  * [Linux, \*nix, Mac OSX](#linux-nix-mac-osx-3)
  * [Windows](#windows-3)
* [How it works](#how-it-works)
* [Main changes from spf13](#main-changes-from-spf13)
* [Some features](#some-features)
* [Main shortcuts](#main-shortcuts)
* [Plugins and their shortcuts](#plugins-and-their-shortcuts)
* [.local file](#local-file)
  * [vim-plug](#vim-plug)
  * [ywvim中文输入法](#ywvim中文输入法)
  * [Markdown](#markdown)
  * [Themes Collentions](#themes-collentions)
  * [vim-easy-align](#vim-easy-align)
  * [auto-pairs](#auto-pairs)
  * [Complete Engines](#complete-engines)
    * [Smart Engines Selection](#smart-engines-selection)
    * [YouCompleteMe](#youcompleteme)
    * [coc](#coc)
    * [ncm2](#ncm2)
    * [deoplete](#deoplete)
    * [asyncomplete](#asyncomplete)
    * [neocomplete](#neocomplete)
    * [neocomplcache](#neocomplcache)
  * [Complete Snippets, vim 7.4+ is also required](#complete-snippets-vim-74-is-also-required)
    * [ultisnips](#ultisnips)
    * [neosnippet](#neosnippet)
  * [Syntax Check](#syntax-check)
    * [ale](#ale)
    * [syntastic](#syntastic)
  * [Search/Replace tools](#searchreplace-tools)
    * [FlyGrep](#flygrep)
    * [Ctrlsf](#ctrlsf)
    * [vim-multiple-cursors](#vim-multiple-cursors)
  * [RunTools](#runtools)
    * [vim-quickrun](#vim-quickrun)
    * [asyncrun](#asyncrun)
  * [language support](#language-support)
    * [java: vim-eclim](#java-vim-eclim)
    * [perl](#perl)
    * [php](#php)
    * [html](#html)
    * [javascript](#javascript)
    * [rust](#rust)
    * [julia](#julia)
    * [erlang](#erlang)
  * [nerdtree](#nerdtree)
  * [tagbar and vim-gutentags](#tagbar-and-vim-gutentags)
  * [undotree](#undotree)
  * [lightline](#lightline)
  * [fugitive](#fugitive)
  * [bioSyntax-vim](#biosyntax-vim)
  * [nerdcommenter](#nerdcommenter)
  * [fuzzy finder](#fuzzy-finder)
    * [fzf.vim](#fzfvim)
    * [LeaderF](#leaderf)
    * [ctrlp](#ctrlp)
  * [surround](#surround)
  * [repeat](#repeat)
  * [vim-easy-align](#vim-easy-align-1)
  * [EasyMotion](#easymotion)

<!-- vim-markdown-toc -->

# 中文介绍
这里是我本人的vim配置，从spf13的[spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim) fork面来，作为几年前的作品，原配置已经不大适合这个vim8/neovim当道的时代。因此在近两年的使用时间里, 我不断调整，从其他人的配置中吸取经验，对参数进行微调，以适应在不同的系统环境条件下达到较好的使用体验。在`OSX` `windows` `linx`下都可以安装使用

长期以来，这个README一直处于远远落后于配置改变的进度，细碎调整特别是快捷键的改动，实在是提不劲来修改。近日来随着最后几个补全插件的加入和配置调整，这个配置文件已经比较完整，因此可以好好坐下来，对使用方法和注意点作一介绍。(其实,在这写这个文档的时候还在不停地改快捷键)

**PLEASE FORGIVE ME FOR MY POOR ENGLISH!!**

# Introduction
This is **leoatchina** vim config forked from [spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim). I sincerely thank him for great job. But in order to meet my furthers needs,I have changed lots of settings. And now it is suitable for vim/gvim/nvim for linux/mac/windows

You can find spf13's origin config at http://vim.spf13.com or https://github.com/spf13/spf13-vim.

Hereafter is spf13's introduction to his vim config
> spf13-vim is a distribution of vim plugins and resources for Vim, Gvim and MacVim.It is a good starting point for anyone intending to use VIM for development running equally well on Windows, Linux, \*nix and Mac.

# Requirements
`Git 1.7` and `Vim7.0` with any of `+job`,`+python`,`+python3`,`+lua` is at least required， `Vim8` or `neovim` and `Git 2.0+` is prefered for advanced features

And I wish you have a basic understanding of vim, know how to read the config files to find what I have not mentioned here.

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
  cd leoatchina-vim
  git pull
  open vim, do :PlugRe
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

# Main changes from spf13
* use `vim-plug` instead of `vundle`, faster and smarter, two ex cmd `PlugRe` for uninstal/install plugins, `PlugNew` for uninstall/update plugins simutanously.
* totally simplified, delete `fork`,`before` files ,delete lots of variables for feature settings
* just as I have mentioned before, the link is from the cloned folder
* not support **XP** any more

# Some features
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
* `<Leader><cr>`: source `~/.vimrc`. It is for config develop & debug
* `<Cr>` for bracket jump
* `c-a` to the head of a line, `c-e` to end in visual/insert mode, compatible with linux.
* `c-f`, `c-b`, `c-h`, `c-l`, `g` work like `Leader` key in normal mode
* `c-f` to right and `c-b` to left in insert mode
* `gf` to end of sentence, `gb` to the beginning in normal/visual mode
* `c-e` to end of sentence, `c-a` to the beginning in insert/command mode
* `c-k j` invoke browser tools `fzf` or `LeaderF` or `Ctrlp`
* `gc` for gcommit, `gs` for git diff,  `g+Cr` for `:Git `
* `~` instead of `Q`, and `Q` for quit current buffer at once
* `.` for exit visual mode
* `!` for `:!`
* `/` sent visual select part to command line
* `;` sent visual select part aftter `%s/` to command line
* `<leader>TT`: tab help
* `<leader>tw`: toggle wrap
* `<leader>tf`: toggle folder
* `<leader>tn`: number type toggle
* `<M-R>`:      run script (with plugin [vim-quickrun](https: //github.com/thinca/vim-quickrun))
* `<M-Q>`:      toggle quickrun windows
* `<leader>th`: toggle search results highlight
* `<leader>tr`: show register strings
* `<leader>tp`: pastetoggle
* `<leader>tn`: toggle number/relativenumber
* `tab/buffer control`
    - set tabpagemax=10
    - cmap Tabe tabe
    - nnoremap `<silent><Tab>`:            tabnext<CR>
    - nnoremap `<silent><S-Tab>`:          tabprevious<CR>
    - nnoremap `<silent>-`:                tabprevious<CR>
    - nnoremap `<Leader><Tab>`:            tabm +1<CR>
    - nnoremap `<Leader><S-Tab>`:          tabm -1<CR>
    - nnoremap `<Leader>-`:                tabm -1<CR>
    - nnoremap `<Leader>te`:               tabe<Space>
    - nnoremap `<Leader>ts`:               tab split<CR>
    - nnoremap `<Leader>tw`:               tabs<CR>
    - nnoremap `<Leader>tm`:               tabm<Space>
    - nnoremap `<LocalLeader><Backspace>`: buffers<CR>
    - nnoremap `<LocalLeader>]`:           bn<CR>
    - nnoremap `<LocalLeader>[`:           bp<CR>
    - nnoremap gq:                         tabclose<CR>
    - and alt/cmd + 1,2,3,4.....0 for tabquickswitch
* `copy & paste`
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
* `Some other shortcuts`
    - nnoremap <C-f>w [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    - nnoremap <Leader>fd :set nofoldenable! nofoldenable?<CR>
    - nnoremap <Leader>fw :set nowrap! nowrap?<CR>
    - nnoremap <Leader>w :w<CR>
    - nnoremap <Leader>W :wq!<CR>
    - nnoremap <Leader>WQ :wa<CR>:q<CR>
    - nnoremap ~ Q
    - nnoremap Q :bd!<Cr>
    - nnoremap <Leader>q :q!
    - nnoremap <Leader>Q :qa!
    - nnoremap <Leader>\ :vsplit<Space>
    - nnoremap <Leader><Leader>\ :split<Space>
    - nnoremap <Leader>= <C-W>=
    - nnoremap <Leader><Down> :resize -3<CR>
    - nnoremap <Leader><Up>   :resize +3<CR>
    - nnoremap <Leader><Left> :vertical resize -3<CR>
    - nnoremap <Leader><Right>:vertical resize +3<CR>
    - vnoremap < <gv
    - vnoremap > >gv
* `Alt` key remap
    - according to [skywind3000](http://www.skywind.me/blog/archives/1846)
    - even mapped for macvim
    - you should `map your alt key to Esc` in you `xshell`,`securetcrt`,`mobaxterm`,`iterm2`,`terminal`, etc.
    - `Alt` is different from `Alt+Shift`,  not like `ctrl` and `ctrl+shift`


# Plugins and their shortcuts
Hereafter are the plugins that I collected, if you want details for them, click it.

At first I planned to detailly introduce every plugins, however, first it is easy for users to find the original repos of these plugins for details, second it is real a hard work to write work for each plugin.
So , I simplly write something about the plugins, sometime only list the shortcut.

# .local file
The `.vimrc` or `init.vim` sources `~/.vimrc.plug` for plugins definition, and `~/.vimrc.plug` sources `~/.vimrc.local` when the file exists.
This `local` file contains an import variable called `g:plug_groups` for the supported features for vim,  the plugins will change.
The default contents of `.vimrc.local` is:
> let g:plug_groups=['bio']

And you can also create `~/.gvimrc.local` for `gvim`, `~/.nvimrc.local` for `neovim` , `~/.mvimrc.local` for `macvim` to intall diffent plugins for gvim and nvim. If these two local file not exist, `.vimrc.local` works.

The typical variables that could be add to `g:plug_groups` are `go`, `youcompleteme`, `fzf`, `coc`, etc.

Here is a trick that I set diffent `PLUG_PATH` for `vim/gvim/neovim` , `~/.vim/plug` for `vim` , `~/.gvim/plug` for `gvim`, `~/.nvim/plug` for `neovim`.

`.vimrc.clean` it is an bash file which is set to delete `~/.vimswap` & `~/.vimviews` folders. Also be linked as `~/.vimrc.clean`
Just as I have mentioned, the `~/.vimrc.local` contains the fearutures that you need.For example, if you want syntax check, you can open it and add ``syntax`` in the list `g:plug_groups`, then rerun `install.sh` or `:PlugReinstall`, the plugins `ale` for `vim8`/`neovim` , or `syntastic` for `vim7.3+` will be installed.


## [vim-plug](https://github.com/junegunn/vim-plug)
A smart and parallel plug manage plugin, instead of [vundle](https://github.com/VundleVim/Vundle.vim) which spf13 use.
It willed installed to `~/.vim-plug` after installation.
You can check how it is installed via `install.sh` or `setup.cmd`.

## [ywvim中文输入法](https://github.com/leoatchina/ywvim)
这个介绍我用中文写因为老外用不到。`ywvim`中文输入法,在`insert`模式下通过`CTRL+\ `开启,`CTRL+^`进行配置。`;`临时英文输入法;注意,默认只输入**英文状态**的标点;`z`临时拼音;`,.-=`上下翻页。开启办法: 要在 `~/.vimrc.local`里的`g:plug_groups`加入`wubi`(五笔)或者`pinyin`(拼音).

## Markdown
Markdown syntastic hightlight by default, and if has gui with python support, [markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim) and relative plugins will be installed, then `C-z` for preview in browser, `C-s` for stop preview, `C-q` for `:Voom markdown`(with [voom](https://github.com/vim-voom/VOoM))

## [Themes Collentions](https://github.com/leoatchina/vim-colorschemes-collections)
Forked from [rafi's colorschemes collections](rafi/awesome-vim-colorschemes), keeped **8** themes I prefer.
- [wombat256](https://github.com/vim-scripts/wombat256.vim) for vim befor 8.0
- [gruvbox](https://github.com/morhetz/gruvbox) default vim8 theme
- [jellybeans](https://github.com/nanotech/jellybeans.vim) default neovim theme in *Unix
- [hybrid](https://github.com/w0ng/vim-hybrid) default neovim theme in windows
- [material](https://github.com/hzchirs/vim-material) default *Unix gvim theme
- [codedark](https://github.com/tomasiser/vim-code-dark) default windows gvim theme

## [vim-easy-align](https://github.com/junegunn/vim-easy-align)
```
    nmap <localleader><Cr> <Plug>(EasyAlign)
    vmap <Cr> <Plug>(EasyAlign)
```

## [auto-pairs](https://github.com/jiangmiao/auto-pairs)
```
    let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`'}
    let g:AutoPairsShortcutToggle     = "<C-l>o"
    let g:AutoPairsShortcutFastWrap   = "<C-l>f"
    let g:AutoPairsShortcutJump       = "<C-l>j"
    let g:AutoPairsShortcutBackInsert = "<C-l>i"
```

## Complete Engines
**7** code-completion engines:`ncm2`, `deoplete`, `coc`, `asyncomplete`, `neocomplete`, `neocomplcache` and `YouCompleteMe`.

### Smart Engines Selection
There is variable `"smartcomplete"` in `"g:plug_groups"` contained in `.vimrc.local`, it means .vimrc will choose the completion engine according to the vim enviroment if `vim8/neovim` or `old version`, `python2/3` or `no python`, `windows` or `linux` or `mac`.
I strongly advice you updete to vim8.0+ or neovim for advanced engine with better performance.

By default, with '+python3' support, `deoplete` will be installed,  otherwise `asyncomplete`.

These engines have their semantic complete fuction with the help from other plugins relatively, which will be also installed, and will change with `g:plug_groups`.

If you are install older vim7.4 (default installed by ubuntu , centos), `has("lua")` will yank `neocomplete`, and `not` will be `neocomplcache`. The two `neo` engines has barely semantic completion funtions, their finishments are completed with snippets support.

You can also force to install the completion engine in `g:plug_groups`, just replace `smartcomplete` with it, but if the vim feature and enviroment not support the plug you choose, the engine will fall to `neocomplcache` which is the one with the least requires.

`youcompleteme` is the only complete engine that you must sepecially write into `g:plug_groups`,  which not be installed with `smartcomplete`, and is the one with the best performance. Since it is hard to install, I advice you not to write it in `.vimrc.local` untill you have a deep understanding to you system.

It is such a complex to make all the completion shortcuts compatible, finally I used a series of unroute shortcuts when completion menu popup: `Tab` or `C-j` for trigger, if not triggered , switch to the next. `CR` for end completion(`C-e`, `C-y` still work). `C-p`/`C-n` or `Up`/`Down` for previous/next selection.

I have tried `completor`, `mucompletor`, `supertab` but not keep them for some different reasons.

### [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
Needs `neovim/vim` with `+python` or `+python3`, and `g++` installed

### [coc](https://github.com/neoclide/coc.nvim)
Needs `neovim/vim8` with `node` and `yarn` installed in system

### [ncm2](https://github.com/ncm2/ncm2)

### [deoplete](https://github.com/Shougo/deoplete.nvim)
Needs `vim8/neovim` with `+python3`
And, if you add `deoplete-tabnine` in g:plug_groups, [deoplete-tabnine](https://github.com/tbodt/deoplete-tabnine) will be installed, it is a small complete tools for vim, only 10m+, and it is saied as all complete tools.
If add `deoplete-lcn`,  deoplete will use  [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim), you should config `g:LanguageClient_serverCommands` in your .local file.

### [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim)
Needs `vim8/neovim`, no `python support` is needed

### [neocomplete](https://github.com/Shougo/neocomplete.vim)
Needs `vim/neovim` with `+lua`

### [neocomplcache](https://github.com/Shougo/neocomplcache.vim)
The last complete enginge

## Complete Snippets, vim 7.4+ is also required
If complete_engine is `neocomplete` or `neocomplcache`, snippets `ultisnips` or  `neosnippet` will be intalled automatically. Otherwise need `snippet` in `~/.vimrc.local`. `C-f` for snips jump forward in snippets, and only `ultisnips` use `c-b` for jump back

### [ultisnips](https://github.com/SirVer/ultisnips)
Works if with python support.

### [neosnippet](https://github.com/Shougo/neosnippet.vim)
Works if without python support.

## Syntax Check
### [ale](https://github.com/w0rp/ale.git)
```
    nnoremap <silent> <C-l><C-l> :ALELint<CR>
    nmap     <silent> <C-l><C-p> <Plug>(ale_previous_wrap)
    nmap     <silent> <C-l><C-n> <Plug>(ale_next_wrap)
    nnoremap <silent> gad        :ALEGoToDefinition<CR>
    nnoremap <silent> gat        :ALEGoToDefinitionInTab<CR>
    nnoremap <silent> gar        :ALEFindReferences<CR>
```

### [syntastic](https://github.com/vim-syntastic/syntastic.git)
Works is not fits the need of `ale`
```
    nnoremap <silent> <C-l><C-l> :call ToggleErrors()<cr>
    nnoremap <silent> <C-l><C-p> :lprevious<cr>
    nnoremap <silent> <C-l><C-n> :lnext<cr>
```

## Search/Replace tools
The main leader key is `C-f`

### [FlyGrep](https://github.com/wsdjeg/FlyGrep.vim)
`<C-f>g` to call the window

### [Ctrlsf](https://github.com/dyng/ctrlsf.vim)
Needs `ag` or `rg` or `ack` or
```
    nmap     <C-F>f <Plug>CtrlSFPrompt
    vmap     <C-F>f <Plug>CtrlSFVwordPath
    vmap     <C-F>F <Plug>CtrlSFVwordExec
    nmap     <C-F>n <Plug>CtrlSFCwordPath
    nmap     <C-F>N <Plug>CtrlSFCCwordPath
    nmap     <C-F>p <Plug>CtrlSFPwordPath
```

### [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)
```
    let g:multi_cursor_start_word_key      = '<C-n>'
    let g:multi_cursor_select_all_word_key = '<M-n>'
    let g:multi_cursor_start_key           = 'g<C-n>'
    let g:multi_cursor_select_all_key      = 'g<M-n>'
    let g:multi_cursor_next_key            = '<C-n>'
    let g:multi_cursor_prev_key            = '<C-_>'
    let g:multi_cursor_skip_key            = '<C-h>'
    let g:multi_cursor_quit_key            = '<ESC>'
```

## RunTools
### [vim-quickrun](https://github.com/thinca/vim-quickrun)
Use `F5` to run scripts. `S-F5` to toggle quickrun window

### [asyncrun](https://github.com/skywind3000/asyncrun.vim)
A async run plugin for vim8/nvim
```
    command! AsyncRunNow call s:ASYNC_RUN()
    nmap <C-b>a :AsyncRunNow<CR>
    nmap <C-b>s :AsyncStop<CR>
    nmap <C-b>g :AsyncRun
    au bufenter * if (winnr("$") == 1 && exists("AsyncRun!")) | q | endif
```

## language support

### java: [vim-eclim](https://github.com/dansomething/vim-eclim)
You have to install eclipse, and [eclim](https://github.com/ervandew/eclim) according to its instruction.
```
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
  end
```

### [perl](https://github.com/vim-perl/vim-perl)
perl snippets and syntax

### [php](https://github.com/shawncplus/phpcomplete.vim)
```
    let g:phpcomplete_mappings = {
       \ 'jump_to_def_split':  '<C-]>',
       \ 'jump_to_def_vsplit': '<C-\>',
       \ 'jump_to_def':        '<C-w><C-]>',
       \ 'jump_to_def_tabnew': '<C-w><C-\>',
       \}
```
### html
### javascript
### rust
### julia
### erlang

## [nerdtree](https://github.com/scrooloose/nerdtree)
Togglekey:`<Leader>nn`, and key `<Leader>nt`

## [tagbar](https://github.com/majutsushi/tagbar) and [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
need `has("ctags")`. Togglekey:`<Leader>tt`

## [undotree](https://github.com/mbbill/undotree)
Just as it name. Togglekey:`<Leader>u`

## [lightline](https://github.com/itchyny/lightline.vim)
Beautifull statusline for advanced information of workspace.

## [fugitive](https://github.com/tpope/vim-fugitive)
Git plugin. `gc` for `Gcommit`, and `+` for `:Git `

## [bioSyntax-vim](https://github.com/bioSyntax/bioSyntax-vim.git)
As a bionformtion worker, this plug is use in view bam/sam/vcf. need add `bio` in `~/.vimrc.local`

## [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
Hackable plugin, the most import key is ** `<Leader>c<Space>` **|NERDComToggleComment|**
You can get other shortcuts via the link.

## fuzzy finder
`C-k j` to invoke one of the following plugs, major keys are `<Leader>lf`, `<Leader>lm`, please see `.vimrc` for details
You can install only one of them , by write the plugins name in `~/.vimrc.local`. `CtrlP` is the default one.

### [fzf.vim](https://github.com/junegunn/fzf.vim)
fzf runs asynchronously and can be orders of magnitude faster than similar Vim plugins.
### [LeaderF](https://github.com/Yggdroot/LeaderF)
This plugin is mainly used for locating files, buffers, mrus, tags in large project.
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
```
    nmap <localleader><Cr> <Plug>(EasyAlign)
    vmap <Cr> <Plug>(EasyAlign)
```
## [EasyMotion](https://github.com/easymotion/vim-easymotion)
```
    nmap <C-j><C-j> <Plug>(easymotion-w)
    nmap <C-k><C-k> <Plug>(easymotion-b)
```
