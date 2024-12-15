@echo off & cls

Set "Source=(a! complex /? ~ * <=> test string)"
Set "search=* <="

setlocal EnableDelayedexpansion

Call Automacro.bat @ifContains
%@ifContains% source search /e

Echo(Testing "!Source!" for "!search!"
Echo(bool	: index
Echo(!errorlevel!	; !@ifContains.true!
Pause

Endlocal & goto:eof


(Set \n=^^^

%= do not modify this \n definition =%)

Set @ifContains=For %%. in (1 2)Do if %%.==2 (%\n%
  For /f "tokens=1,2,3" %%1 in ("^!@ifContains.args^!") Do (%\n%
    For %%. in (1 2)Do if %%.==2 (For /f "tokens=1,2" %%i in ("^!@strlen.Args^!")Do (%\n%
      Set "@strlen.t=^!%%~i^!"%\n%
      If defined @strlen.t (%\n%
        Set "%%j=1"%\n%
        For %%P in ( 4096 2048 1024 512 256 128 64 32 16 8 4 2 1 )Do (%\n%
          If not "^!@strlen.t:~%%P,1^!" == "" (%\n%
            Set /a "%%~j+=%%P"%\n%
            Set "@strlen.t=^!@strlen.t:~%%P^!"%\n%
      ) ) ) Else set "%%~j=0"%\n%
  ) ) Else Set @strlen.Args= %%1 @ifContains.len[1]%\n%
    For %%. in (1 2)Do if %%.==2 (For /f "tokens=1,2" %%i in ("^!@strlen.Args^!")Do (%\n%
      Set "@strlen.t=^!%%~i^!"%\n%
      If defined @strlen.t (%\n%
        Set "%%j=1"%\n%
        For %%P in ( 4096 2048 1024 512 256 128 64 32 16 8 4 2 1 )Do (%\n%
          If not "^!@strlen.t:~%%P,1^!" == "" (%\n%
            Set /a "%%~j+=%%P"%\n%
            Set "@strlen.t=^!@strlen.t:~%%P^!"%\n%
      ) ) ) Else set "%%~j=0"%\n%
  ) ) Else Set @strlen.Args= %%2 @ifContains.len[2]%\n%
  Set "@ifContains.true="%\n%
  If ^^^!@ifContains.len[2]^^^! LEQ ^^^!@ifContains.len[2]^^^! (%\n%
    For /f "tokens=1,2" %%i in ("^!@ifContains.len[1]^! ^!@ifContains.len[2]^!") Do (%\n%
      For /l %%# in (0 1 %%i)do if "^!@ifContains.true^!" == "" (%\n%
        if "^!%%1:~%%#,%%j^!"=="^!%%2^!" (%\n%
          Set "@ifContains.true=%%#"%\n%
  ) ) ) )%\n%
  If /i "%%3" == "/e" If defined @ifContains.true ((call))else ((call )))%\n%
) Else Set @ifContains.Args=
