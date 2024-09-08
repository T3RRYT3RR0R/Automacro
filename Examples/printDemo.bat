@Echo off & CLS

  Setlocal EnableDelayedExpansion

  Call "%~dp0automacro.bat" @print "@csvArray /len"

%@csvArray% $demo "Hello World, Goodbye World^^^!"
For /l %%i in (1 1 !$demo[i]!)Do (
  %@print% /y %%i /x 1 /f %%i /b 234 /s !$demo[%%i]! /y %%i /x 30 /f 240 /b 234 /s strLen=!$demo[%%i].len!
)

Pause
Endlocal & goto:eof