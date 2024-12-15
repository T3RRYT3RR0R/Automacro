@echo off

set "whitelist=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 =+*-/\_.,'$[]{}@#$^:;?^""
Set "string=!One! <two> & three =four %%~* ) five = ^ true /?""	

  Setlocal enabledelayedexpansion
  Call %~dp0automacro.bat @sanitize

  (
    %@sanitize% string whitelist $return /cull
    Echo start %time% // end !time!
  )

  Echo(string=!string!
  Set $return

Pause
Endlocal & goto:eof