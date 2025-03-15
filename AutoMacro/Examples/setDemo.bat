@echo off & setlocal enableDelayedExpansion
Call "%~dp0automacro.bat" @set

Set control=true
%@set% "a[1]=one" "a[2]=two" "control="

Set a[
Set control 2> nul	l

Pause
Endlocal & goto:eof