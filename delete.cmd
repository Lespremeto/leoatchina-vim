@if not exist "%HOME%" @set HOME=%USERPROFILE%
call del "%HOME%\.vimrc"
call del "%HOME%\_vimrc"
call del "%HOME%\.vimrc.plugs"
call del "%HOME%\.vimrc.md"
call del "%HOME%\AppData\Local\nvim\init.vim"
call rmdir /Q /S "%HOME%/.vim"
call rmdir /Q /S "%HOME%/.gvim"
call rmdir /Q /S "%HOME%/.nvim"
