@echo off & Setlocal EnableDelayedExpansion
cls

REM Call "%~dp0automacro.bat" @menu
REM Call "%~dp0automacro.bat" "@menu /basic"
  Call "%~dp0automacro.bat" "@menu 20;20;90 180;120;60 40;20;40"

%@menu:Header= Choose from the below options:% "pick me" "or Me" "no, me^^^!" some filler content Narnia the Lion Witch Wardrobe Exit

Echo(
Set menu{

Pause

Endlocal & goto:eof