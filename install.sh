#!/usr/bin/env bash
############################  SETUP PARAMETERS
app_name='leoatchina-vim'
[ -z "$APP_PATH" ] && APP_PATH="$PWD"
[ -z "$REPO_URL" ] && REPO_URL='https://github.com/leoatchina/leoatchina-vim.git'
debug_mode='0'
[ -z "$PLUG_URL" ] && PLUG_URL="https://github.com/junegunn/vim-plug.git"
############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}
success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }
    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}

program_must_exist() {
    program_exists $1
    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

lnif() {
    if [ -e "$1" ] ; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}
############################ SETUP FUNCTIONS
create_symlinks() {
    local source_path="$1"
    local target_path="$2"
    lnif "$source_path/.vimrc"          "$target_path/.vimrc"
    lnif "$source_path/.vimrc.plugs"    "$target_path/.vimrc.plugs"
    lnif "$source_path/update.sh"       "$target_path/.vimrc.update"
    lnif "$source_path/README.markdown" "$target_path/.vimrc.md"
    if program_exists "nvim"; then
        mkdir -p "$HOME/.config/nvim"
        lnif "$source_path/.vimrc"      "$HOME/.config/nvim/init.vim"
    fi
    ret="$?"
    success "Setted up vim symlinks."
    debug
}

setup_plug() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'
    echo
    msg "Starting update/install plugins for $1"
    "$1" +PlugRe +qall
    export SHELL="$system_shell"
    success "Successfully updated/installed plugins using vim-plug for $1"
    debug
}

install_vim_plug() {
    if [ -d "$2" ];then
        cd "$2"
        git pull
        cd "$3"
    else
        git clone --depth=1 "$1" "$2" 
    fi
    success "Successfully installed/updated vim-plug!"
    debug
}

############################ MAIN()
variable_set "$HOME"
program_must_exist "git"
mkdir -p "$HOME/.cache/session"
mkdir -p "$HOME/.cache/tags"
update_vim_plug='0'
ret='0'
if [ -f $HOME/.vimrc.md ];then
    read -p "Do you want to update leoathina's vim config  (Y/y for Yes , any other key for No)? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];then
        git pull
        success "Update to the latest version of leoatchina-vim"
        update_vim_plug='1'
        ret='0'
    fi
else
    update_vim_plug='1'
    debug
fi

if [ -f $HOME/.vimrc.local ];then
    success "$HOME/.vimrc.local exists. You can modify it."
else
    cp $APP_PATH/.vimrc.local $HOME/
    success "$HOME/.vimrc.local does not exist, copy  it."
fi

create_symlinks "$APP_PATH" "$HOME"
if [ "$update_vim_plug" -eq '1' ];then
    install_vim_plug "$PLUG_URL" "$HOME/.vim-plug/autoload" "$APP_PATH"
fi

if program_exists "vim"; then
    setup_plug "vim"
fi

if program_exists "nvim"; then
    setup_plug "nvim"
fi

if program_exists "gvim"; then
    setup_plug "gvim"
fi

msg "\nThanks for installing leoatchina's vim config forked from http://vim.spf13.com"
msg "© `date +%Y` https://github.com/leoatchina/leoatchina-vim"
