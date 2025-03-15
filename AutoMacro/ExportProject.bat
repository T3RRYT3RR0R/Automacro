@Echo off &CLS
rem Automacro companion Utility for exporting projects and their dependencies.
rem This file MUST be placed in a Directory that is a Grandparent of all Dependencies
Set "$rootFolder=%~dp0"
:GetProject <projectName> <outDirectory>
rem supports drag / drop of a batch project, with a request for user input for the desired output folder.
rem retains directory information of dependencies.
rem TBA : refactor.

Set "$project="
If "%~1" == "" (
  Set /p "$project=Project Name: " || Goto:GetProject
)Else Set "$project=%~nx1"

Setlocal EnableDelayedexpansion
:GetPath
Set "$outFolder=%~2"
If "%~2" == "" Set /p "$outFolder=Target Directory: " || Goto:GetPath 

For %%G in ("!$project!")do (
  Set "$project=%%~nxG"
  Set "$projectPath=%%~dpG"
  Set "$outPath=%%~fG"
  CD /D "%%~dpG"
  CD ..
)
:tail
If not "!$outPath:\=!" == "!$outPath!" if not "!$outPath:*\=!" == "!$project!" (
  if not "!$outPath:*\=!" == "!$project!" Set "$outPath=!$outPath:*\=!"
  Goto:tail
)

Set "$outPath=!$outPath:%$project%=!"

Set "$pushed="
If not "%~1" == "" (
  If not "!$outPath!" == "" (
    rem If not exist "..\!$outPath!" MD "..\!$outPath!"
    For %%F in ("automacro.bat" "readme.txt" "!$project!")do for /f "delims=" %%G in ('Dir /b /S "!$projectPATH!*%%~F"')do (
      If "!$pushed!" == "" (
        Set $pushed=!$pushed! "%%~fG"
      )else If "!$pushed:%%~fG=!" == "!$pushed!" Set $pushed=!$pushed! "%%~fG"
    )
  )

  For /f "delims=" %%G in ('Dir /b /s "%~1"')Do (
    For /f "tokens=1,* Delims=@" %%S in ('findstr /RIC:"Call .*automacro\.[bc][am][td]" "%%~fG"')Do (
      Set  "$args=@%%T"
      Set ^"$args=!$args:"=!"
      For %%M in (!$args!)do (
        Set "$item=%%~M"
        If not "!$item:@=!" == "!$item!" (
          For /f "delims=" %%G in ('dir /b /s %%~M.mac 2^> nul') do (
            If "!$pushed!" == "" (
              Set $pushed=!$pushed! "%%~fG"
            )else If "!$pushed:%%~fG=!" == "!$pushed!" Set $pushed=!$pushed! "%%~fG"
            For /f "tokens=2* delims=:" %%E in ('findstr /li "dependencies:" "%%~fG"') do Call:GetDependencies %%E
        ) )
      )
    )
  )
)

  For %%G in (!$pushed!)Do (
    If "!$outPath!" == "" (
      echo(%%G
    )Else (
      Set "$outTree=%%~G"
      Set "$outTree=!$outTree:*%$outPath%=!"
      if defined $outTree Set "$outTree=!$outTree:*%$rootFolder%=!"
      rem echo "%%~G" "!$outFolder!\!$outTree!"
      XCOPY "%%~G" "%$outfolder%\!$outTree!" /-I
    )
  )
PAUSE
Endlocal & Goto:eof


:GetDependencies
  For %%1 in (%*) Do (
    For /f "delims=" %%G in ('dir /b /s "%%~1.mac" 2^> nul') do (
      If "!$pushed:%%~nxG=!" == "!$pushed!" Set $pushed=!$pushed! "%%~fG"
      For /f "tokens=2* delims=:" %%_ in ('findstr /li "dependencies:" "%%~fG"') do Call:GetDependencies %%_
    )
  )
Goto:eof