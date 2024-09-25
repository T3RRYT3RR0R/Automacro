@Echo off & setlocal EnableDelayedExpansion
cls

REM demo script - a simple animation simulating nightfall
CHCP 65001 > nul 
Call "%~dp0automacro.bat" @interleave
Set "$[a]=goodbye         goodbye"
Set "$[b]=goodbye goodbye"
%@interleave% $[a] $[b] $return /R
Echo(!$return!

Set "$[a]=☻☺♦♦☻☺▬♪☼Ϩ/\►◄"
Set "$[b]=♦♦☻☺☺☻↕♀‼•\/◄►"
%@interleave% $[a] $[b] $return /fuse
Echo(!$return!

Set "$[a]=░░░░░░░░░░░░░░"
Set "$[b]=▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
%@interleave% $[a] $[b] $return[1] /fuse
Set "$[a]=▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
Set "$[b]=░░░░░░░░░░░░░░"
%@interleave% $[a] $[b] $return[2] /fuse
Set "$[a]=   Hello"
Set "$[b]=   Hello"
%@interleave% $[a] $[b] $return[3] /fuse
Echo(!$return[2]!%\E%[10E!$return[1]!%\E%7%\E%[5A%\E%[1G!$return[3]!%\E%8%\E%[E

Pause
Endlocal & goto:eof