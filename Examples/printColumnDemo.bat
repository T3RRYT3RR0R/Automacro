@Echo off & CLS

  Setlocal EnableDelayedExpansion

  REM example of calling Automaco with args to define macro/s. to supress Automacro STDOUT, prefix with 1> nul

  Call "%~dp0automacro.bat" @printColumn

(
  %@printColumn% 2 2 20 38;2;0;180;120 Hello World. This is a test string. edge case testing Supercalifragelisticexpealidocous
  %@printColumn% 10 2 20 48;2;120;0;60;38;2;40;0;40 Here's round two for good measure. Does it make sense?
  %@printColumn% 2 25 20 demo vtColor optional ```````````````````````````````````````````````````````
  Echo !\E![20;1Hstart: %time% end: !time!
)

  Pause
Endlocal & exit /b