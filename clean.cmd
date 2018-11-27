@if not exist "%HOME%" @set HOME=%USERPROFILE%
call del "%HOME%/.vimswap/*"
call del "%HOME%/.vimviews/*"
