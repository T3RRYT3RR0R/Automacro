@echo off & setlocal EnableDelayedExpansion &cls

Call "%~dp0automacro.bat" @formatDate

%= @formatDate =%

  %@formatDate% $date - YYYY MM DD
  Echo( YYYY-MM-DD = !$date!

  %@formatDate% $date / DD MM YYYY
  Echo( DD/MM/YYYY = !$date!

  %@formatDate% $date _ MM DD YY
  Echo( MM_DD_YY   = !$date!

  %@formatDate% $date ^| DD MM
  Echo( DD^|MM      = !$date!


  Echo(!\E![E
Endlocal