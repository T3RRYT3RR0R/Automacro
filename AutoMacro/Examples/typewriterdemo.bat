@echo off & setlocal enabledelayedexpansion
cls
Call "%~dp0automacro.bat" @typewriter @windowframe
rem @getkey is a dependency of @typewriter
%@getkey% /prompt !\E![K\n controls:\n - Hold tab to speed up output\n - Press escape to quit\n  /p /cls
Set "$key="
MODE 50,20
CHCP 65001 > nul

Set "target=joke789"

  set "endparse=1"
  For /f "tokens=1 delims=:" %%i in ('%systemroot%\system32\findstr.exe /blinc:"{end} !target!" "%~f0"')do set "endparse=%%i"
  <"%~f0" (
    Set "{start}="
    For /l %%p in (1 1 !endparse!)do if not defined @typewriter.end (
      Set "line="
      Set /p "line="
      If defined {start} If not defined line (
        %@wait% "!random! %% 15 + 8"
        echo(
      )
      for /f "tokens=1,* delims= " %%1 in ("!line!")do (
        If /i "%%1" == "{command}" (
          For /f "tokens=2,*" %%A in ("!line!") Do (
            If defined %%A (
              set "@command=!%%A! %%B"
            )else set "@command=%%A %%B"
            Call:ExpandMacro
          )
          Set "line="
        )
        If /i "%%1" == "{end}" If /i "%%~2" == "!target!" (
          set "line="
          set "{start}="
        )
        If /i "%%1" == "{start}" If /i "%%~2" == "!target!" (
          set "line="
          set "{start}=1"
        )
        If defined {start} If defined line (
          %@typewriter% line 0;0;90 116;116;116
          %@wait% "!random! %% 15 + 8"
        )
 ) ) )
%@getkey% /cls
Endlocal & goto:eof

:Expandmacro
  %@command%
exit /b 0

=====================================================================
Exit                                                %= script data =%
=====================================================================

{start} joke789
{command} <nul set /p "=!\E![1;20r!\E![8;20;50t"
{command} !@windowframe! 50 20 17 8  •
{command} <nul set /p "=!\E![1;1H!$windowframe!!\E![3;3H"
Why was 8 afraid of 7?
{command} @Getkey
{command} <nul set /p "=!\E![5;3H"
Because
{command} !@wait! 20
{command} <nul set /p "=!\E![5;11H"
7
{command} <nul set /p "=!\E![6;11H"
8
{command} <nul set /p "=!\E![7;11H"
9
{command} <nul set /p "=!\E![8;11H"
!
{end} joke789