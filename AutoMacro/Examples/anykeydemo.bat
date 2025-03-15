@echo off & setlocal EnableDelayedExpansion

Call "%~dp0automacro.bat" @anykey

rem holds execution until any key pressed. returns key pressed
%@anyKey% mykey

set myKey

Endlocal & goto:eof