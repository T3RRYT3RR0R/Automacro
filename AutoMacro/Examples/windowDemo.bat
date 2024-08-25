@Echo off & CLS

Setlocal EnableDelayedExpansion

REM example of calling Automaco with args to define macro/s.

 Call "%~dp0automacro.bat" @window @windowFrame

 mode 80,30
 CHCP 65001 > nul

 %@Window% 80 20 52 234

 %@windowFrame% 40 20 3 2 ┼✠
 Echo(%\E%[1;1H%\E%[2J%$window%%\E%[5;20H%$windowFrame%%\E%[25;1H

Pause
exit /b