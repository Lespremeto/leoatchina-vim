This is leoatchina's vim config forked from [spf13-vim:steve francia's vim distribution](https://github.com/spf13/spf13-vim). I sincerely thank him for great job. But meet my needs,I have changed lots of settings.
 You can find spf13's origin config at http://vim.spf13.com or https://github.com/spf13/spf13-vim
 Below is spf13's introduction to his vim config
> spf13-vim is a distribution of vim plugins and resources for Vim, Gvim and MacVim.
 It is a good starting point for anyone intending to use VIM for development running equally well on Windows, Linux, \*nix and Mac.
# Main files
* `.vimrc` main configuration file, shortcuts, settings, themes 
* `.vimrc.plug` plugins install file 
* `.vimrc.local` basic features, will be copied to %HOME%
* `.vimrc.clean` it is an bash file which is set to delete .vimswap & .vimviews folders
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
  ./install.sh ,chosse y|Y, the scipt will do git pull and do reinstall plugs 
```
## windows
```
  cd leoatchina-vim
  git pull
  open vim, do :PlugReinstall  
```

# Upgrade plugs
## Linux, \*nix, Mac OSX
```
  cd leoatchina-vim
  ./updata.sh
```
or
```
  ~/.vimrc.update
```
or
```
  open vim, do :PlugNew
```
## windows
```
  open vim, do :PlugNew
```

# Delete 
## Linux, \*nix, Mac OSX
```
  cd leoatchina-vim
  ./uninstall.sh
```
## Windows
```
  click delete.cmd with admin rights
```

# How it works
After the installation, a `.vimrc`symbol link in the `HOME` folder (for neovim, in its config file, such as `~/.config/nvim/init.vim` for Linux ) which links to the `.vimrc` file in the cloned folder. 

The `.vimrc`/`init.vim` sources `~/.vimrc.plug` for plugins, and `~/.vimrc.plug` sources `~/.vimrc.local` when the file exists, the `local` file contains some features for vim.

Here is a trick that I set diffent PLUG_INATLL_PATH for vim/gvim/neovim , `~/.vim/plug` for `vim` , `~/.gvim/plug` for `gvim`, `~/.nvim/plug` for `neovim`


# Main change from spf13
- Use `vim-plug` instead of `vundle`, more quick and more smart
- delete `fork`,`before` files , which are redundent for most users
- delete lots of variables for feature settings 
- just have mentioned before, the link is from the cloned folder 
- not support **XP** 

# Some features
* line number
* no backup file 
* In Visual, keep selection after indention change with `>`,`<`
* no backup
* no sound
* highlight search  
* smart indent
* no scroll line
* no menu, no tools when gui-runnin

# Main shortcuts
* `<Leader>` to `<Space>`, so the biggest key on keyboard is more usefull
* `<localLeader>` to `\`
* `<leader>.` for number + 1, `<leader>,` for number -1
* `<Leader><cr>`, source `~/.vimrc`
* `<localleader><localLeader` for bracket jump 
* `g`,`c-f`,`c-k`, `c-l` sometimes work like `leader` key in normal mode
* `c-a` to the head of a line, `c-e` to end in normal/visual/inesert mode, compatible with linux
* `c-f` to right `c-b` to left in insert mode
* `c-x` instead of 'c-e' for fullscreen jump, pairs with `c-y`
* `c-b` for plugins `ctrlp` or `fzf` or `leaderF` or `denite` in normal mode
* `~` instead of `Q`, and `Q` for quit current buffer at once
* `F1`: tab help 
* `F2`: toggle search results highlight
* `F3`: show register srings
* `F4`: toggle quickrun windows
* `F5`: run script (with plugin [vim-quickrun](https://github.com/thinca/vim-quickrun)) 
* `F11`: full screen toggle, but sometimes not work
* `F12`: paste toggle
* `.` for exit visual mode
* tab/buffer control
```
    set tabpagemax=10 " Only show 10 tabs
    cmap Tabe tabe
    " s-tab not work in Xshell
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

```
* copy & paste
```
    vnoremap <leader>y  "+y
    nnoremap <leader>y  "+y
    nnoremap <leader>yy "+yy
    nnoremap <leader>Y  "*y
    vnoremap <leader>Y  "*y
    nnoremap Y y$
    vnoremap Y *y$

    nnoremap <leader>p "+p
    nnoremap <leader>P "*P
    vnoremap <leader>p "+p
    vnoremap <leader>P "*P
```
* some other shortcuts 
```
    nmap <Leader>w :w<CR>
    nmap <Leader>W :wq!<CR>
    nmap <Leader>WQ :wa<CR>:q<CR>
    nmap <Leader>q :q!
    nmap <Leader>Q :qa!
    " split windows
    nmap <leader>\ :vsplit<Space>
    nmap <Leader><leader>\ :split<Space>
    nmap <leader>= <C-W>=
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
## [vim-plug](https://github.com/junegunn/vim-plug) 
A smart and parallel plug manage plugin, instead of [vundle](https://github.com/VundleVim/Vundle.vim) which spf13 use
- Easier to setup: Single file. No boilerplate code required.
- Easier to use: Concise, intuitive syntax
- Super-fast parallel installation/update (with any of +job, +python, +python3, +ruby, or Neovim)
- Creates shallow clones to minimize disk space usage and download time
- On-demand loading for faster startup time
- Can review and rollback updates
- Branch/tag/commit support
- Post-update hooks
- Support for externally managed plugins

## [themes ](https://github.com/leoatchina/vim-colorschemes-collections)
forked from [rafi's colorschemes collections](rafi/awesome-vim-colorschemes), keep some xterm-256 compatible themes which I prefer. `:colorschemes` followed by `<Tab>` will show all the themes.
  - `gruvbox` for vim 
  - `hybrid_material` for gvim
  - `wombatmod` for neovim
  - `onedark` for neovim with gui

## Completion



### 7.1.1. [YouComplteMe](https://github.com/Valloric/YouCompleteMe)
  ![](https://camo.githubusercontent.com/1f3f922431d5363224b20e99467ff28b04e810e2/687474703a2f2f692e696d6775722e636f6d2f304f50346f6f642e676966)
  - 需要安装一系列编译用软件
  - 具体可参考[Vim 自动补全插件 YouCompleteMe 安装与配置](http://howiefh.github.io/2015/05/22/vim-install-youcompleteme-plugin/).
  - 在安装好各种编译用的工具后
  ```
     cd ~/.vim/bundle/YouCompleteMe
     python install.py
  ```
#### 7.1.1.1. [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim)
在nvimcompletemangaer停止更新后，另一开发者fork后，直接利用了vim8内置的异步功能进行补全，不再需要python支持
这个提供了一个框架，补全功能要配合其他插件使用

#### 7.1.1.2. [deoplete](https://github.com/Shougo/deoplete.nvim)

#### 7.1.1.3. [completor](https://github.com/maralla/completor.vim)

#### 7.1.1.4. [neocomplete](https://github.com/Shougo/neocomplete.vim)

#### 7.1.1.5. [neocomplcache](https://github.com/Shougo/neocomplcache.vim)



### 7.1.3. [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)
在侧边显示当前目录，Toggle快捷键为`<Leader>nn`
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171011101641847.png)

### 7.1.4. [majutsushi/tagbar](https://github.com/majutsushi/tagbar) and [ludovicchabant/vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
显示文档结构，要求在系统里安装`ctags`
用`<Leader>tt`切换在测边显示文档结构.在bar窗口里按`F1`调出帮助窗口
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171011102150785.png)

### 7.1.5. [vim-voom/VOoM](https://github.com/vim-voom/VOoM)
另一个显示文档结构的插件，和`TagBar`逻辑不一样，`python`里肯定有用，其他语言我还没有测试出来。快捷键`<F10>`打开 ,用`_`在voom_buffer和代码窗口内切换。
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171012105213969.png)

### 7.1.6. [mbbill/undotree](https://github.com/mbbill/undotree)
undotree顾名思义,增强版的回退插件，快捷键`<Leader>u`

### 7.1.7. [airline](https://github.com/vim-airline-themes)
漂亮的状态栏,能够显示很多状态。
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171011105655369.png)

### 7.1.8. [ywvim中文输入法](https://github.com/leoatchina/ywvim)
`ywvim`中文输入法,直接在vim里内置,~~无意中发现要和[fcitx](https://github.com/fcitx/fcitx)配合使用否则会有bug~~,在`insert`模式下通过`CTRL+@`或`CTRL+\`开启,`CTRL+^`进行配置.`;`临时英文输入法;注意,默认只输入**英文状态**的标点,而且首选是`五笔`;`z`临时拼音;`,.-=`上下翻页;
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171011215538461.png)
![](http://oxa21co60.bkt.clouddn.com/markdown-img-paste-20171011212612850.png)
x

### 7.1.9. [fugitive](https://github.com/tpope/vim-fugitive)
对git的支持,具体可以看官方说明,设置了快捷键`<Leader>gi :Git<Space>`,操作体验接近终端下输入`git`命令.还有快捷键

### 7.1.10. [scrooloose/nerdcommenter](https://github.com/scrooloose/nerdcommenter)
注释插件,神器,直接上官方的快捷键,最常用的是`<Leader>c<Space>`
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

### 7.1.11. [LeaderF](https://github.com/Yggdroot/LeaderF)
在高级模式的情况下会选用这个插件


### 7.1.12. [ctrlp](https://github.com/ctrlpvim/ctrlp.vim)
杀手级插件，不过有点老，网上找来的图
![](http://zuyunfei.com/images/ctrlp-vim-demo.gif)

`ctrl+p`启动插件,`<Leader>fu`启动funksky函数查询功能,在启动后,用`Ctrl+f`,`Ctrl+b`在不同模式中切换.
在文件列表中,`Ctrl+k/j`或者方向键向上/下选择文件,`t`在新标签里打开文件.其他快捷键见[ctrlp中文介绍](http://blog.codepiano.com/pages/ctrlp-cn.light.html)

### 7.1.13. [Pymode](https://github.com/python-mode/python-mode)
`python`用的插件,具有语法检查,调试等功能.`<Leader>R`:运行脚本;`<LocalLeader>p`:track_point toggle

### 7.1.14. [surround](https://github.com/tpope/vim-surround)
给一段文字加上括号的插件，下面说明文字引用自[vim中的杀手级别的插件：surround](http://zuyunfei.com/2013/04/17/killer-plugin-of-vim-surround/)
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
如上面代码块所示，添加替换时使用后半括号)]}，添加的括号和内容间就没有空格（如第2个示例），反之会在内容前后添加一个空格（如第4个实例）。第6个示例中的t代表一对HTML或者xml tag。其他表示范围的符号：w代表word, W代表WORD(被空格分开的连续的字符窜），p代表paragraph。

*命令列表*
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
### 7.1.15. [vim-easy-align](https://github.com/junegunn/vim-easy-align)


### 7.1.16. [EasyMotion](https://github.com/easymotion/vim-easymotion)
 又一个杀手级别的插件
 ![](http://www.wklken.me/imgs/vim/easy_motion_search.gif)
 1. 跳转到当前光标前后,快捷键`<Leader><Leader>w`和`<Leader><Leader>b`
 2. 搜索跳转,`<Leader><Leader>s`,然后输入要搜索的字母
 3. 行间/行内级别跳转,`<Leader><Leader>`再`hjkl`不解释
 4. 重复上一次的动作,`<Leader><Leader>.`
 5. 还可以`<Leader><Leader>f`和`<Leader><Leader>t`,不过不建议使用
