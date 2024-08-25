@echo off & Setlocal EnableDelayedExpansion
  CLS

  Call "%~dp0automacro.bat" @push @pop

  %@push% this "Hello world"
  Echo Push this=!this!
  %@push% this some more
  Echo Push this=!this!
  %@pop% this [1]
  Echo Pop this=!this!; return=![1]!
  %@pop% this [2]
  Echo Pop this=!this!; return=![2]!
  %@pop% this [3]
  Echo Pop this=!this!; return=![3]!

Pause
Endlocal & goto:eof