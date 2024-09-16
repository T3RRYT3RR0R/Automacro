@Echo off & setlocal EnableDelayedExpansion
cls

REM demo script - a simple animation simulating nightfall

Call "%~dp0automacro.bat" @frame @while @fillRect
mode 80,40

Set /a hue=150	,red=1
Set start=%time%
%@while% (
  %@frame: args = timer[color] 24 % Set /a red+=1
  %@frame: args = timer[rect] 4 % (
    If !timer[rect].elapsed! GEQ 304 (
      %@endWhile%
      echo !\E!8Dusk has fallen.!\E!7
    ) else (
      Set /a hue-=2
      %@fillRect% $rect 4 80 !hue!
      %@fillRect% $rect2 10 80
      For /f "tokens=1,2 eol=`" %%G in ("!hue! !red!")Do echo !\E![H!\E![2J!$rect:;5;=;2;%%H;0;!!\E!7!\E![48;2;!red!;!hue!;0m!$rect2!!\E!7!\E![0m
    )
  )
)
<nul set /p "=!\E!8!\E![E"
Pause > nul
Endlocal & goto:eof