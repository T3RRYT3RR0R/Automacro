@echo off & Setlocal enableDelayedExpansion
CLS
  Call "%~dp0automacro.bat" @windowFrame @alignCentre @alignright @lookup @while @vertprint
  CHCP 65001 > nul

  Set /A "columns=80","width=columns/2,Height=25,xOffset=width/2"
  mode !columns!,40

  Set "weekdays=:mon:Monday:tue:Tuesday:wed:Wednesday:thu:Thursday:fri:Friday:sat:Saturday:sun:Sunday:"

  Set "animation=◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ ◄ "

  %@windowFrame% !width! !height! 20 40 ░

  Set "CentreMe= Hello World "
  Set "RightMe=Foo bar boo Far"
  %@alignCentre% !xOffset! Width CentreMe $Centred "(Height/2)+1"
  %@alignRight% Width+xOffset RightMe $Righted[1] "(Height/2)+3"

  %@while% ( If !$while! GEQ 2000 %@endWhile%
    %@vertprint% !animation:~-%height%!
    Set /a "frame=$while %% 28"
    If !frame! == 0 Set "animation=!animation:~-1!!animation:~0,-1!"
    %@lookup% !date:~0,3! weekdays $today
    Set "$today=!$today! !date:* =!"
    %@alignRight% Width+xOffset $today $Righted[2] "(Height/2)+5"

    %@alignCentre% !xOffset! Width $while $i 3
    %@alignRight% Width+xOffset time $Righted[3] "(Height/2)+7"

    Echo(%\E%[1;!xOffset!H%\E%[2D!$vertprint!%\E%[!width!C%\E%[2C%\E%[1d!$vertprint:◄=►!%\E%[1;!xOffset!H!$windowFrame!!$windowFrame.invertedColor!!$i!!$centred!!$windowFrame.Color!!$righted[1]!!$righted[2]!!$righted[3]!%\E%[0m%\E%[!height!d%\E%[E
  )

Pause
Endlocal & goto:eof