@echo off & setlocal enabledelayedexpansion
cls
Call "%~dp0automacro.bat" @typewriter

Set "string=Hello world^! <|> today is a fine day to make silly things."
%@typewriter% string 160;0;130 0;40;40

Pause
Endlocal & goto:eof
%@typewriter%