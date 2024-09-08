@echo off & Setlocal EnableDelayedExpansion
  CLS

  Call "%~dp0automacro.bat" @pushUnique @popUnique

  %@pushUnique% this "Hello world"
  Echo Push this=!this!
  %@pushUnique% this "some more"
  Echo Push this=!this!
  %@pushUnique% this "some more"
  Echo Push this=!this!
  %@pushUnique% this "final"
  Echo Push this=!this!
  %@popUnique% this [] /prepend ,
  Echo Pop this=!this!; return=![]!
  %@popUnique% this [] /append ,
  Echo Pop this=!this!; return=![]!
  %@popUnique% this [] /prepend ,
  Echo Pop this=!this!; return=![]!

Pause
Endlocal & goto:eof