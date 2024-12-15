@echo off & setlocal enabledelayedexpansion
CLS
Call "%~dp0automacro.bat" @rainbowText
Set "string=....................... Hello World^! ......................."
Set "stringB=\\\\\\\\\\\\\\\\\\\\\ ~ Hello World^! ~ /////////////////////"

%@rainbowText% string 50 2 2

For /l %%i in (1 1 50)do (
  %@rainbowText% string $returnA 2 2
  %@rainbowText% stringB $returnB 10 2
  Echo !$returnA!!$returnB!
  %@wait% 4
)

endlocal & goto:eof