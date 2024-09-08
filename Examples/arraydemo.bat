@Echo off & Setlocal EnableDelayedExpansion & CLS

  Call "%~dp0automacro.bat" @randomizeArray @searchArray @while

  %@randomizeArray% $demo 1 3 7 13 17 21 23 27 127 1317232721

  Set /a searchvalue=!random! %% $demo[i] + 1
  For /f "tokens=1" %%1 in ("!$demo[%searchvalue%]!")Do  Set "searchvalue=%%1"
  Set /a exact.i=1,any.i=2
  Set /a $stop[1]=$stop[2]=0

(
  %@searchArray% $demo $return.exact searchvalue /E
  %@searchArray% $demo $return.any searchvalue
  Echo(seeking !searchvalue!:
  %@while% if not "!$stop[1]!!$stop[2]!" == "11" (
    For %%T in ( exact any )Do (
      If defined $return.%%T (
        %@pop% $return.%%T %%T
        For /f "tokens=1,* Delims=:" %%1 in ("!%%T!")Do (
          Set "%%T=!%%T:*:=!"
          if not defined $demo[%%1].exact Echo %\E%[0m%%T match:	[%%1]:%\E%[90m!%%T:%searchValue%=%\E%[32m%searchValue%%\E%[90m!%\E%[0m
          If /i "%%T" == "exact" Set "$demo[%%1].exact=1"
        )
      )Else (
        Set "$stop[!%%T.i!]=1"
      )
    )
  )Else %@endWhile%
  Echo(start %time% // end !time!
)


Pause
Endlocal & goto:eof


