@Echo off & setlocal EnableDelayedExpansion
cls

REM demo script - a simple animation simulating nightfall

Call "%~dp0automacro.bat" @interleave
Set "$[a]=goodbye         goodbye"
Set "$[b]=goodbye goodbye"
%@interleave% $[a] $[b] $[return] /R
Set $[

Pause
Endlocal & goto:eof