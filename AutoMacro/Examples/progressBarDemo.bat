@Echo off & setlocal enableDelayedExpansion
CLS

Call "%~dp0automacro.bat" @progressBar @wait @getkey
CLS

%@getkey% /prompt Demo 1: %%@progressBar%% %%i $end $barlen /c /p /cls /notifyExit

Set /a "$end=170,$barlen=100"
mode %$barlen%,30
rem example of defining a start time for display.
set "$start=%time% ~ "
For /l %%i in (1 1 %$end%) do (
  %@progressBar% %%i $end $barlen /c
  %@Getkey% /nonblocking /escapeExit
  rem simulate a delay of ~1 centisecond
  %@wait% 1
)

%@getkey% /prompt Demo 2: %%@progressBar%% %%i $end $barlen 2;20;20;^^^!$blue^^^! /nb /p /cls /escapeExit

set "$start="
Set /A $end=77,$barlen=50
REM the $blue color assignment will exceed the maximum valid value of 255 at 100%
REM resulting in the macro reverting to the default color gradient - outputting as green at 100%
For /l %%i in (1 1 %$end%) do (
  2> nul set /a "$blue=($percent*255/100)+10"
  %@progressBar% %%i $end $barlen 2;20;20;!$blue! /nb
  %@Getkey% /nonblocking /escapeExit
  rem simulate a delay of ~2 centiseconds
  %@wait% 2
)

:wait
 %@getkey% /prompt %\E%7View Help y/n /escapeExit
 :enforce
 If /i !$key! == y (
   echo(%\E%8!@progressbar_usage!
   %@getkey% /prompt Demo complete. Press enter to quit. /escapeExit
   if /i not !$key! == enter (
     set $key=y
     goto:enforce
   )	
 )Else If /i not !$key! == n (
   <nul set /p ".=%\E%8"
   Goto:wait
 ) 

endlocal & goto:eof