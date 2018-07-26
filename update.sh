program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }
    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}
if program_exists "vim"; then
    vim +PlugClean +PlugUpdate +qall
fi
if program_exists "nvim"; then
    nvim +PlugClean +PlugUpdate +qall
fi
if program_exists "gvim"; then
    gvim +PlugClean +PlugUpdate +qall
fi
