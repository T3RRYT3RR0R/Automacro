@echo off & setlocal enableDelayedExpansion
Call "%~dp0automacro.bat" @getKey @while
CLS
:loop
Set $pressed=
rem %= @getKey =% $pressed
%@getKey% $pressed
if defined $pressed (
  Echo(pressed: '!$pressed!'
) else <nul set /p "=."
If /i "!$pressed!" == "escape" (
  Call:alphanumerical string 4 "enter a 4 charcter alphanumerical string"
  Echo(!\E![E!string!
  endlocal & goto:eof
)Else goto:loop

:AlphaNumerical <returnVar> <length> [prompt]
Echo(!\E![1;1H!\E![2J%~3
  Set "%~1="
  Set "total=0"
  %@while:$=#% (
    %@getkey% $pressed
    Set "valid=1"
    if not "!$pressed:~1,1!" == "" if /i not "!$pressed!" == "backspace" Set "valid=0"
    if not !valid! equ 0 For /f "delims=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSATUVWXYZ" %%V in ("!$pressed!") Do Set "valid=0"
    if !valid! equ 1 (
       If /i not "!$pressed!" == "backspace" (
         Set /a total+=1
         If !total! GEQ %~2 %@endwhile:$=#%
         Set ^"%~1=!%~1!!$pressed!"
         <nul Set /p "=*"
       )Else (
         if defined %~1 (
           Set /a total-=1
           Set ^"%~1=!%~1:~0,-1!"
           <nul Set /p "=!\E![D !\E![D"
         )
       )

    ) 
  )
