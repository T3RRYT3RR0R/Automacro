@Echo off & CLS

  Setlocal EnableDelayedExpansion

  REM example of calling Automaco with args to define macro/s.

  Call "%~dp0automacro.bat" @vertprint

  %@vertPrint% !time!
  %@vertPrint:$vert=$% !date!
  Echo(!$vertPrint!!\e![1;3H!$print!!\e![15;1H

  %HELP% @vertprint
Pause
Endlocal & exit /b