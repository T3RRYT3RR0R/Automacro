@echo off & Setlocal enableDelayedExpansion
CLS
  Call "%~dp0automacro.bat" @lookup

Set "lib=:mon:Monday:tue:Tuesday:wed:Wednesday:thu:Thursday:fri:Friday:sat:Saturday:sun:Sunday:"

%@lookup% !date:~0,3! lib $today

Echo(!date!
Echo( - - - - - - - - -
Echo(!$today! !date:* =!

Pause

Endlocal & goto:eof


