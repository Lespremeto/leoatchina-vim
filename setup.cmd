REM    Copyright 2014 Steve Francia
REM 
REM    Licensed under the Apache License, Version 2.0 (the "License");
REM    you may not use this file except in compliance with the License.
REM    You may obtain a copy of the License at
REM 
REM        http://www.apache.org/licenses/LICENSE-2.0
REM 
REM    Unless required by applicable law or agreed to in writing, software
REM    distributed under the License is distributed on an "AS IS" BASIS,
REM    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM    See the License for the specific language governing permissions and
REM    limitations under the License.


@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%~dp0
call del "%HOME%\.vimrc"
call del "%HOME%\_vimrc"
call del "%HOME%\.vimrc.plugs"
call del "%HOME%\.vimrc.md"

call mklink "%HOME%\.vimrc"       "%APP_PATH%\.vimrc"
call mklink "%HOME%\_vimrc"       "%APP_PATH%\.vimrc"
call mklink "%HOME%\.vimrc.plugs" "%APP_PATH%\.vimrc.plugs"
call mklink "%HOME%\.vimrc.md"    "%APP_PATH%\README.markdown"

IF NOT EXIST "%HOME%\.vimrc.local" (
    call cp  "%APP_PATH%\.vimrc.local"      "%HOME%\.vimrc.local"
)
IF NOT EXIST "%HOME%\.vim" (
    call mkdir -p "%HOME%\.vim"
)
IF NOT EXIST "%HOME%\.gvim" (
    call mkdir -p "%HOME%\.gvim"
)
IF NOT EXIST "%HOME%\.nvim" (
    call mkdir -p "%HOME%\.nvim"
)


IF NOT EXIST "%HOME%\AppData\Local\nvim" (
    call mkdir -p "%HOME%\AppData\Local\nvim"
)
call del "%HOME%\AppData\Local\nvim\init.vim"
call mklink "%HOME%\AppData\Local\nvim\init.vim"  "%APP_PATH%\.vimrc"                 

IF NOT EXIST "%HOME%\.vim\autoload" (
    call git clone https://github.com/junegunn/vim-plug.git "%HOME%\.vim\autoload"
) ELSE (
    call cd "%HOME%\.vim\autoload"
    call git pull
)

IF NOT EXIST "%HOME%\AppData\Local\nvim\autoload" (
    call git clone https://github.com/junegunn/vim-plug.git "%HOME%\AppData\Local\nvim\autoload"
) ELSE (
    call cd "%HOME%\AppData\Local\nvim\autoload"
    call git pull
)
call gvim +PlugClean +PlugInstall +qall 
