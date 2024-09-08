  @Echo off & CLS
  Setlocal EnableDelayedExpansion

  Call "%~dp0automacro.bat" @while @randomizeArray @last @first

  %@while% (
    if !$while! GEQ 2000 (
      %@endWhile%
      cls
      Echo whileEnd: !$while! start:%time% // end:!time!
    )Else <nul Set /p "=[H[K[48;2;0;90;120m[%%~~X[E[0m!$while!"
  )

Echo(
  Set "test=<> & /? one two, three^! four"
  Echo("!test!" split by "," then by "^!"
(
  %@last% test ","
  %@first% test ","
  %@first:$first=$first[2]% test "^!"
  %@last:$last=$last[2]% test "^!"
  Echo @first*2 + @last*2 %time% // !time!
  Echo(
)
  Echo(first "!$first!"
  Echo(last  "!$last!" w/out whitespace: "!$last: =!"
  Echo(first "!$first[2]!"
  Echo(last  "!$last[2]!" w/out whitespace: "!$last[2]: =!"
  Echo(

(
  %@randomizeArray% $this 1 2 3 5 8 13 21 34 55 89 144 233
  Echo @randomizeArray %time% // !time!
)
Set $this
Pause
Endlocal & goto:eof