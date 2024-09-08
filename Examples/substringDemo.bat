@echo off
Setlocal EnableDelayedExpansion

Call "%~dp0automacro.bat" @substring

REM The below is a demo of @substring Macro usages.
REM this demo is intended for use via conhost cmd.exe 
REM output will not match intention in windows terminal
If not defined \E For /F %%a in ('Echo prompt $E^| %systemroot%\system32\cmd.exe')Do Set \E=%%a

CLS

If 0==1 (
  %help% @substring
  Timeout /T 2 /Nobreak
  Pause
  CLS
)

%@Substring:$Return=HW% /L "Hello World " /I '['$_ ' /M "$_" /I '['$_ ' /M "$_" /I '['$_ ' /M "$_" /I '['$_ ' /M "$_"

Set /a HW[%HW.i%].Len+=1
Set "Redraw=!$_!"
For /l %%i in (0 1 !HW[%HW.i%].Len!) do (
  %@Substring% /A /I '%%i'%\E%[32;7m^^^<^^^>%\E%[0m' "%$_%"
  Echo(%\E%[1;1H%\E%[K!$Return[0]!
)

%@Substring:$Return=Original% /A /L "<Hello World>"
%@Substring:$Return=Step% /I '1'%\E%[33m?%\E%[0m' "%$_%" /I '2'%\E%[33m?%\E%[0m' "%$_%" /I '3'%\E%[33m?%\E%[0m' "%$_%" /I '4'%\E%[33m?%\E%[0m' "%$_%" /I '5'%\E%[33m?%\E%[0m' "%$_%" /I '6'%\E%[33m?%\E%[0m' "%$_%" /I '7'%\E%[33m?%\E%[0m' "%$_%" /I '8'%\E%[33m?%\E%[0m' "%$_%" /I '9'%\E%[33m?%\E%[0m' "%$_%" /I '10'%\E%[33m?%\E%[0m' "%$_%" /I '11'%\E%[33m?%\E%[0m' "%$_%" /I '12'%\E%[33m?%\E%[0m' "%$_%"
For /L %%i in (1 1 !Step.i!)Do (
  <nul Set /p "=%\E%[6;1H!Step[%%i]!"
  For /l %%z in (1 1 75000)Do If 1==0 REM delay
)

Echo(%\E%[1;1H%\E%7

Set "$_=%Redraw% "
For /f %%L in ("!HW[%HW.i%].Len!")DO For /l %%i in (0 1 !HW[%HW.i%].Len!) do (
  %@Substring% /A /I '%%i' ' "!$_:~0,%%L! "
  Echo(%\E%[1;1H!$Return[0]!
)
Set "$_=%Redraw%"
Echo(%\E%[1;1H!$_!

 For %%G in ( B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C C A A A C C C C B B B C C C A A A E B B B B C C C C C C C C C STOP )Do (
  IF not %%G==STOP (
   %@Substring% /A /O /R 'Hello World= * ' /I '['%\E%8%\E%[5X%\E%[?25l%\E%[%%~G%\E%7' "!Original[0]!"
  )Else %@Substring% /A /O /R '!Original[0]!= ' /I '['%\E%8%\E%[5X%\E%[?25l%\E%7' "!Original[0]!"
 )

Echo(%\E%[1;1H%\E%[?25h
Pause
Endlocal & Goto:Eof
