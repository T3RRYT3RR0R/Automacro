@Echo off & setlocal enableDelayedExpansion

Call "%~dp0automacro.bat" @progressBar
Set /a "$end=170,$barlen=100"
mode %$barlen%,30

For /l %%i in (1 1 %$end%) do (
  %@progressBar% %%i $end $barlen
  for /l %%i in (1 1 12500)Do rem simulate delay
)
Pause
cls
REM the $blue color assignment will exceed the maximum valid value of 255 at 100%
REM resulting in the macro reverting to the default color gradient - outputting as green at 100%
For /l %%i in (0 2 %$end%) do (
  set /a "$blue=($percent*255/100)+10"
  %@progressBar% %%i $end $barlen 2;0;0;!$blue!
  for /l %%i in (1 1 12500)Do rem simulate delay
)
Pause

REM Echo(^!@progressbar:%\E%=^!
endlocal & goto:eof