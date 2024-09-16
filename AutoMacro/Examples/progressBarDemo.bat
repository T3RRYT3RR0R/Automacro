@Echo off & setlocal enableDelayedExpansion
CLS
Call "%~dp0automacro.bat" @progressBar @wait @getkey
Set /a "$end=170,$barlen=100"
mode %$barlen%,30

%@getkey% /prompt Demo 1: %%@progressBar%% %%i $end $barlen /p /cls

For /l %%i in (1 1 %$end%) do (
  %@progressBar% %%i $end $barlen
  %@wait% 1 ; simulate a delay of ~1 centisecond
)

%@getkey% /prompt Demo 2: %%@progressBar%% %%i $end $barlen 2;20;20;^^^!$blue^^^! /p /cls

Set /A $end=77,$barlen=50
REM the $blue color assignment will exceed the maximum valid value of 255 at 100%
REM resulting in the macro reverting to the default color gradient - outputting as green at 100%
For /l %%i in (1 1 %$end%) do (
  set /a "$blue=($percent*255/100)+10"
  %@progressBar% %%i $end $barlen 2;20;20;!$blue!
  %@wait% 2 ; simulate a delay of ~2 centiseconds
)

%@getkey% /prompt

endlocal & goto:eof