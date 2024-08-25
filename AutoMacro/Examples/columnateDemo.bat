  @Echo off & CLS
  Setlocal EnableDelayedExpansion

  Call "%~dp0automacro.bat" @columnate
(
  Set "demo[1]=%date% %time%"
  Set "demo[2]=%time% %date%"
  %@columnate% demo[1] 1 5 13
  %@columnate% demo[2] 1 7 15 1
  Echo(!demo[1].c!!demo[2].c! start: %time% end: !time!
)
Pause > nul
Endlocal & goto:eof