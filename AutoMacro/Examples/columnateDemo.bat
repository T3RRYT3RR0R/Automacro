  @Echo off & CLS
  Setlocal EnableDelayedExpansion

  Call "%~dp0automacro.bat" @columnate
  CHCP 65001 > nul

(
  Set "demo[1]=▒ %date% ▒"
  Set "demo[2]=▒  %time%   ▒"
  %@columnate% demo[1] 1 5 13 /D
  %@columnate% demo[2] 1 7 15 1 /D
  Echo(!demo[1].c!!demo[2].c!!
  Echo(!\E![4E !$reset.size!start: %time% end: !time!
)
Pause > nul
Endlocal & goto:eof