@echo off & Setlocal enableDelayedExpansion

  Call "%~dp0automacro.bat" @lookup @formatDate
  CLS
  %@formatDate% $date / DD MM YYYY

rem the below .lookup variables are initialised with the @lookup macro
REM Set "weekday.lookup=:mon:Monday:tue:Tuesday:wed:Wednesday:thu:Thursday:fri:Friday:sat:Saturday:sun:Sunday:"
REM Set "month.lookup=:01:January:02:February:03:March:04:April:05:May:06:June:07:July:08:August:09:September:10:October:11:November:12:December:"
REM Set "daynumber.lookup=:01:1st:02:2nd:03:3rd:04:4th:05:5th:06:6th:07:7th:08:8th:09:9th:10:10th:11:11th:12:12th:13:13th:14:14th:15:15th:16:16th:17:17th:18:18th:19:19th:20:20th:21:21st:22:22nd:23:23rd:24:24th:25:25th:26:26th:27:27th:28:28th:29:29th:30:30th:31:31st:"

Set "integerToggle.table=:1:one:1:2:two:02:2:"
Set /a $toggle[1]=1,$toggle[2]=2
Set $toggle[
(
  Echo(example of toggling [1]/ cycling [2] through a set of values via lookup:
  For %%v in (1 2)do For /l %%i in (0 1 5)Do (
    %@lookup% !$toggle[%%v]! integerToggle.table $toggle[%%v]
    Echo($toggle[%%v]=!$toggle[%%v]!
  )
  Echo(
  Echo(example value conversion via lookup:

  %@lookup% !date:~0,3! weekday.lookup $weekday
  %@lookup% !$date:~0,2! daynumber.lookup $daynumber
  %@lookup% !$date:~3,2! month.lookup $month

  Echo(!date!
  Echo(!$weekday! the !$daynumber! of !$month! !$date:~-4!
  Echo(
  Echo({example runtime} start: %time% ^| end: !time!
  Echo(

)
Echo(
If /i "%~1" == "/set" Echo(@lookup=!@lookup!
Pause

Endlocal & goto:eof


