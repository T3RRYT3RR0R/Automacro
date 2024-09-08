@echo off & Setlocal EnableDelayedExpansion
  CLS

  Call "%~dp0automacro.bat" @replaceSecond

  Set "string=this that this the other"
  Set "search=this"
  Set "replace=and"

  Set string
  %@replaceSecond% string search replace
  Set string

Pause
Endlocal & goto:Eof


