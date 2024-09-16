@echo off & setlocal enableDelayedExpansion
Call "%~dp0automacro.bat" @getKey @while
CLS
Echo press any key. press escape to proceed to the next demo
:loop

  %@getKey%
  if defined $key (
    Echo(pressed: '!$key!'
  )Else <nul set /p "=."
  If /i "!$key!" == "escape" (
    Call:alphanumerical input 4 "enter a 4 charcter alphanumerical string" /hide
    Echo(!\E![E!input!
    Pause
    Call:alphanumerical input string "enter an alphanumerical string"
    Echo(!\E![EErrorlevel: !errorlevel!
    Echo(input = "!input!"
    Pause
    endlocal & goto:eof
  )Else goto:loop

============================================================
:AlphaNumerical <returnVar> <length|string> [/hide] [prompt]
============================================================
rem This function examples the level of utility that can be achieved with @getinput courtesy of BG.exe
rem example usages:
rem Call:alphanumerical myVar 6 /hide "enter a 6 digit password: "
rem ^^ returns a 6 digit response containing only alphanumerical characters. masks input as it's recieved.
rem Call:alphanumerical myVar string "description of input type: "
rem ^^ returns a string of any length GTR 0 that may contain alphanumerical characters + whitespace
rem     - permits input ammendment using backspace.
rem     - Prevents duplicate whitespaces and trims leading and trailing whitespace prior to return.
rem     - Allows exit without input via Escape key.
rem     - Errorlevel Returns: 0 = input provided. 1 = input aborted.

Set "$prompt=%~3 %~4"
Echo(!\E![1;1H!\E![2J!$prompt:/hide=!!\E!7
  Set "%~1="
  Set "total=0"
  %@while:$while=alphanumerical% (
    %@getkey% $pressed
    Set "valid=1"
    if /i "%~2" == "string" (
      Set "$pressed=!$pressed:space= !"
      Set "$pressed=!$pressed:back =backspace!"
      if /i "!$pressed!" == "escape" (
        %@endWhile:$while=alphanumerical%
        If not defined %~1 (exit /b 1)Else exit /b 0
      )
      if /i "!$pressed!" == "enter" if defined %~1 (
        Set "valid=0"
        If "!%~1:~0,1!" == " " Set "%~1=!%~1:~1!"
        If "!%~1:~-1!" == " " Set "%~1=!%~1:~0,-1!"
        %@endWhile:$while=alphanumerical%
        exit /b 0
      )
    )
    if not "!$pressed:~1,1!" == "" if /i not "!$pressed!" == "backspace" Set "valid=0"
    If /i not "%~2" == "string" if not !valid! equ 0 For /f "delims=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSATUVWXYZ" %%V in ("!$pressed!") Do Set "valid=0"
    If /i "%~2" == "string" if not !valid! equ 0 For /f "delims=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSATUVWXYZ " %%V in ("!$pressed!") Do Set "valid=0"
    if !valid! equ 1 (
      If /i not "!$pressed!" == "backspace" (
        Set /a total+=1
        If !total! GEQ %~2 %@endwhile:$while=alphanumerical%
        Set ^"%~1=!%~1!!$pressed!"
        If /i "!$prompt:/hide=!" == "!$prompt!" (
          <nul Set /p "=!\E!8!\E![B!\E![1G!\E![0J!%~1!"
        ) Else <nul Set /p "=*"
        If defined %~1 (
          If not "!%~1:  = !" == "!%~1!" (
            If !total! GTR 0 Set /a total-=1
            Set ^"%~1=!%~1:  = !"
            <nul Set /p "=!\E![D !\E![D"
          )
        )
      ) Else (
        if defined %~1 (
          If !total! GTR 0 Set /a total-=1
          Set ^"%~1=!%~1:~0,-1!"
          <nul Set /p "=!\E![D !\E![D"
        )
      )
    ) 
  )
Goto:eof
