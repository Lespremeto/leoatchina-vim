if program_exists "vim"; then
  vim +PlugClean +PlugInstall +PlugUpdate
fi
if program_exists "nvim"; then
  nvim +PlugClean +PlugInstall +PlugUpdate
fi
if program_exists "gvim"; then
  gvim +PlugClean +PlugInstall +PlugUpdate
fi
