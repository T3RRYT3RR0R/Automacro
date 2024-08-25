:AutoMacro <macroname> [macroname]
:AutoMacro <macroname> /?
@echo off
REM calling / opening this script without args will display it's helpfile.

REM :: Author T3RRY
REM :: Contributors: Einstein1969 Grub4K
REM :: Script purpose: facilitate definition of complex macros in a simple manner
REM    that aids readability and verbose descriptions without negatively
REM    impacting environment size. Can be utitlized as a library system to
REM    enhance batch scripts.
REM :: inspired by https://ss64.org/viewtopic.php?t=65
REM :: https://discord.gg/batch
REM :: https://discord.com/channels/288498150145261568/1264550373126049813

REM Version history:
REM :: v2.2.5 21/08/2024
REM :: added help call to simplify access to macro's help info
REM :: Version 2.2.4 18/08/2024
REM :: added support for Inline comments using :: // or rem 
REM ::   previous behaviour was to undefine all lines containing:       " :: ", " // " or " rem "
REM ::   new behaviour is to truncate the line from the first instance of " :: ", " // " or " rem "
REM :: v2.2.3 16/08/2024
REM :: Macro parsing reworked to improve performance and consolidate parse state management
REM :: opening and closing tags: "macroname {" + "} macroname" may now be indented.
REM :: v2.2.2 09/08/2024
REM :: macro pathfinding expanded to create a degree of resilience to folder relocation
REM :: as long as automacro.bat is in the same folder as the calling script, and that folder
REM :: is within a parent directory of the folder/s containing Macro's, automacro.bat
REM :: will still locate the macro file.

If "%~1"=="" (
  mode 130,70

  (
    Echo Automacro Usage: CALL "%~f0" macroname [macroname] [/debug]
    Type "%~dp0readme.txt" 2> nul || Echo Helpfile not found
  ) | more
  Pause
  Exit /b 1
)

Set "AutoMacros= %*"

Set AutoMacros | %systemroot%\system32\findstr.exe /li "\/\?" > nul && (
  Setlocal EnableDelayedExpansion
  Set "AutoMacro.help=true"
  Set "AutoMacros=!AutoMacros: /?=!"
)

if not defined AutoMacro.help If not "!!"=="" (
  1>&2 Echo(AutoMacro requires DelayedExpansion to be enabled
  Pause
  Exit /b 1
)

Set "AutoMacroScripting="

If defined AutoMacros If not "!AutoMacros: /debug=!" == "!AutoMacros!" (
  Set "AutoMacro.debug=true"
  Set "AutoMacros=!AutoMacros: /debug=!"
)

REM :: if above variable is defined, macro lines will be outputted to .\debug\_macroname_.dbug debugging,
REM    in the following format, where # is the actual line number:
REM      raw.#: the raw text of the line
REM      exp.#: the line after expansions occur
REM      =====
REM      macroName=defined lines
REM      =====

If not exist "%~dp0debug" MD "%~dp0debug"

Set "AutomacroRoot=%~dp0_END_"
Set AutomacroRoot="!AutomacroRoot:\=" "!"
For %%G in (!AutomacroRoot!)Do if not "%%~G" == "_END_" Set "last=%%~G"
Set "AutomacroRoot=%~dp0"
Set "AutomacroRoot=!AutomacroRoot:\%last%=!"
Set "PATH=%Path%;%~dp0;!automacroRoot!"
Set "PathExt=!PathExt!;.mac"
(Set \n=^^^

%= Above empty line required =%)

If defined Automacro.help if not defined AutoMacros (
  Rem arg contains help switch only. display names of any .mac files in tree of Root
  CLS
  PUSHD "!automacroRoot!"
  @(For /f "delims=" %%G in ('Dir /b /s @*.mac')Do @Echo(%%~nG) | @more
  POPD
  Pause
  Endlocal & Exit /b 0
)

Set StrLen=For %%n in (1 2)Do if %%n==2 (%\n%
  For /f "tokens=1,2 delims= " %%s in ("^!args^!")Do (%\n%
    Set "$temp=^!%%s^!"%\n%
    If defined $temp (%\n%
      Set "%%t=1"%\n%
      For %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1)Do If not "^!$temp:~%%P,1^!" == "" (%\n%
        Set /a "%%t+=%%P"%\n%
        Set "$temp=^!$temp:~%%P^!"%\n%
      )%\n%
    )Else set "%%t=0"%\n%
  )%\n%
)Else set args=

Set HELP=For %%. in (1 2)Do if %%. EQU 2 (For %%H in (^^^!helpfiles^^^!)Do If exist "%TEMP%\%%H.hlp" More ^< "%TEMP%\%%H.hlp"^)Else Set helpfiles=

REM the below defines the escape character 0x1B to the variable \E
REM providing the FULL path to cmd ensures the definition doesn't fail if the CD command is used prior to
REM its definition. [ windows 11 issue ]
For /F %%a in ('Echo prompt $E^| %systemroot%\system32\cmd.exe')Do Set \E=%%a
(Set LF=^


%= above empty lines required =%)

For /f "tokens=2 delims=+" %%^" in ("+"+"+")Do (
  For %%1 in (!AutoMacros!)Do For /f "tokens=1,*" %%1 in ("%%~1")Do If "!%%~1!" == "" (
    Set "AutoMacro=%%~1"
    Set "!AutoMacro!.init=%%2"
    Set "setup.args=%%2" %= var redundant - retained for backward compatability =%
    Set "!AutoMacro!.path="
    For /f "delims=" %%G in ('%systemroot%\system32\Where.exe /R !AutoMacroRoot! %%1.* 2^> nul')Do Set "!AutoMacro!.path=%%~fG"
    If "!%%~1.path!" == "" (
      1>&2 Echo(Macro: !Automacro! not found within subdirectories of:!LF!"!AutoMacroRoot!"!LF!
      Exit /b 1
    )
    If not exist "!%%~1.path!" (
      1>&2 Echo( Macro: "%%~f1" not found.
      Pause
      Exit
    )
    Set "debug.file=%~dp0debug\_!AutoMacro!_.dbug"
    Set "!AutoMacro!="
    For /f "tokens=1,* Delims=:" %%I in ('%SystemRoot%\System32\findstr.exe /linc:"!AutoMacro! {" "!%%~1.path!"')Do (
      Set "!AutoMacro!.start=%%I"
      Set "!AutoMacro!_Dependencies=%%J"
      REM forgive syntax error - failure to seperate Dependencies list with Semicolon
      If defined !AutoMacro!_Dependencies Set "!AutoMacro!_Dependencies=!%%~1_Dependencies:Dependencies =Dependencies: !"
      If defined !AutoMacro!_Dependencies Set "!AutoMacro!_Dependencies=!%%~1_Dependencies:*Dependencies:=!"
      If /i not "!%%~1_Dependencies!" == "" (
        If not defined AutoMacro.Parent Set "AutoMacro.Parent=%%~1"
        Set "!AutoMacro!_Dependencies=!%%~1_Dependencies:*{=!"
      )Else Set "!AutoMacro!_Dependencies="
      For /f "tokens=1,* Delims=:" %%U in ('%SystemRoot%\System32\findstr.exe /linc:"!AutoMacro! usage" "!%%~1.path!"')Do (
        If not defined !AutoMacro!_usage Set "!AutoMacro!_usage=!AutoMacro! Usage:!LF!!LF!"
        Set "!AutoMacro!.start=%%U"
        Set "Line=%%V"
        Set "!AutoMacro!_usage=!%%~1_usage!!line:*usage:=!!LF!"
      )
    )

    If not "!%%~1_Dependencies!" == "" For %%D in (!%%~1_Dependencies!)Do (
      If defined Automacro.help (
        Set "AutoMacro.temp=%%D"
        Set ^"AutoMacro.temp=!AutoMacro.temp:"=!"
        For /f "tokens=1 delims= " %%C in ("!AutoMacro.temp!")Do Set "%%C.dependency=1"
        Set "Automacro.temp="
      )
      Call:AutoMacro %%D
      If "!Errorlevel!" == "1" Exit /b 1
      Set "AutoMacro=%%~1"
      Set "debug.file=%~dp0debug\_!AutoMacro!_.dbug"
    )
    Set "!AutoMacro!.end="
    For /f "tokens=1,* Delims=:" %%I in ('%SystemRoot%\System32\findstr.exe /NIRC:"}\ !AutoMacro!\^>" "!%%~1.path!"')Do (
      Set "!AutoMacro!.end=%%I"
      Set "!AutoMacro!.switches=%%~J"
      If defined AutoMacro.debug Echo Defining: !Automacro!%\E%[K
      If not "!%%~1.switches:/=!" == "!%%~1.switches!" (Set "!AutoMacro!.switches=!%%~1.switches:*}=!")Else Set "!AutoMacro!.switches="
    )
    If defined !AutoMacro!_usage If not "!%%~1_switches:/?=!" == "!%%~1_switches!" (
      >"%TEMP%\!AutoMacro!.hlp" Echo(!%%~1_usage!
    )
    <"!%%~1.path!" (
      If defined AutoMacro.debug break >"!debug.file!"
      For /l %%i in (1 1 !%%~1.end!)Do (
        Set "line="
        Set /p "line="
        Rem reject parsing of lines outside macro bounds
        If %%i LEQ !%%~1.start! Set "line="
        If %%i GEQ !%%~1.end! Set "line="
        REM handle scripting / remarking tokens
        If defined line For /f "tokens=1,2 delims= " %%g in ("!line:;=```!")Do (
          Set "AutomacroToken[1]=%%g"
          Set "AutomacroToken[2]=%%h"
          If /i "!AutomacroToken[1]!" == "<```" (
            Set "AutoMacroRemarking=active"
            Set "line="
          )
          If /i "!AutomacroToken[1]!" == "```>" (
            Set "AutoMacroRemarking="
            Set "line="
          )
          If /i "!AutomacroToken[1]!" == "::" Set "line="
          If /i "!AutomacroToken[1]!" == "//" Set "line="
          If /i "!AutomacroToken[1]!" == "Rem" Set "line="
          If /i "!AutomacroToken[1]!" == "<$" (
            Set "line="
            Set "AutoMacroScripting=active"
            >"%temp%\automacro_init.cmd" (
              Echo(@echo off
            )
          )
          If "!AutomacroToken[1]!" == "$>" (
            Set "AutoMacroScripting="
            Set "line="
            >>"%temp%\automacro_init.cmd" (
              Echo(Goto:Eof
            )
            Call "%temp%\automacro_init.cmd"
            Del "%temp%\automacro_init.cmd"
          )
          If defined AutoMacroRemarking Set "line="
          If defined AutoMacroScripting If defined line (
            If defined !AutoMacro!.switches If not "!%%~1.switches:/selfRef=!" == "!%%~1.switches!" (
              Set "line=!line:@.=%%~1.!"
            )
            >>"%temp%\automacro_init.cmd" Echo(%%~"!line:CHCP=1^>^&2 Echo ** Automacro Disallowed ** CHCP!
            Set "line="
          )
          if defined line (
            If not "!line: // =!" == "!line!" (
              Set "AutoMacroTruncate=!Line:* // =!"
              %StrLen% AutoMacroTruncate $len
              For %%L in (!$len!)Do set "line=!line:~0,-%%L!"
            )Else if not "!line: :: =!" == "!line!" (
              Set "AutoMacroTruncate=!Line:* :: =!"
              %StrLen% AutoMacroTruncate $len
              For %%L in (!$len!)Do set "line=!line:~0,-%%L!"
            )Else if not "!line: rem =!" == "!line!" (
              Set "AutoMacroTruncate=!Line:* rem =!"
              %StrLen% AutoMacroTruncate $len
              For %%L in (!$len!)Do set "line=!line:~0,-%%L!"
            )
          )
        )

        If defined line If %%i GTR !%%~1.start! If %%i LSS !%%~1.end! (
          If /i "!AutomacroToken[1]!" == "%%~1" 1>&2 Echo syntax error line: %%i!LF!!line!!LF!
          If /i "!AutomacroToken[2]!" == "usage" 1>&2 Echo syntax error line: %%i!LF!!line!!LF!
          If /i "!AutomacroToken[2]!" == "usage:" 1>&2 Echo syntax error line: %%i!LF!!line!!LF!

          Rem enact single line Set statements marked for execution by $ prefix
          If defined line If not "!line:$set =!" == "!line!" (
            If not "!%%~1.switches:/selfRef=!" == "!%%~1.switches!" Set "line=!line:@.=%%~1.!"
            Set "line=!line:*$set =!"
            For /f "Delims=" %%G in ("!line!")Do (
              set "%%~G" || (
                1>&2 Echo(invalid variable assignment in macro "!automacro!"
                1>&2 Echo(line:%%i : !line! 
              )
            )
            Set "line="
          )

          Rem enact single line for loops marked for execution by $ prefix
          If defined line If not "!line:$for =!" == "!line!" (
            >"%temp%\automacro_initLine.cmd" (
              Echo(@echo off
              Echo(%%~"!line:$For =For !%%~"
              Echo(Exit /b %%errorlevel%%
            )
            Call "%temp%\automacro_initLine.cmd"
            Del "%temp%\automacro_initLine.cmd"
            Set "line="
          )

          If defined line (
            If defined AutoMacro.Debug >>"!debug.file!" Echo(%%~"raw.%%i: !line!%%~"
            If defined AutoMacro.Debug For /f "delims=" %%G in ("!line!")Do (
              Set "AutoMacro.out=%%G"
              >>"!debug.file!" Echo(%%~"exp.%%i: !AutoMacro.out!!LF!%%~"
            )
            REM trim leading whitespace; expand dependencies
            For /f "tokens=1,* delims= " %%G in (". !line!")Do Set "Line=%%H"
            Set "!AutoMacro!=!%%~1!!line![LF]"
            If defined AutoMacro.debug (
              Set /a "loading.i=loading.i %% 50 + 1","loading.c=loading.c %% 60 + 1"
              <nul Set /p "=!\E![0m!\E![K!\E![48;2;0;60;90m!\E![!loading.i!X!\E![0m"
            )
          )
        )	
      )
    )

    Rem enact macro switch handling for generative macro content
    If not "!%%~1.switches!" == "" (
      If not "!%%~1.switches:/flush=!" == "!%%~1.switches!" (
        Set "!AutoMacro!=!%%~1!For /f "tokens=1 Delims==" %%V in ('Set @.')Do Set "%%V="[LF]"
      )
      If not "!%%~1.switches:/argRequired=!" == "!%%~1.switches!" (
        Set "!AutoMacro!=If defined @.Args ([LF]!%%~1!"
        Set "!AutoMacro!=!%%~1!)[LF]"
      )
      If not "!%%~1.switches:/help=!" == "!%%~1.switches!" If "!%%~1.switches:/argRequired=!" == "!%%~1.switches!" (
        Set "!AutoMacro!=If not "^^^!@.Args^^^!"=="" ([LF]!%%~1!"
        Set "!AutoMacro!=!%%~1!)Else Echo(^!%%~1_usage^![LF]"
      )
      If not "!%%~1.switches:/args=!" == "!%%~1.switches!" (
        Set "!AutoMacro!=For %%. in (1 2)Do if %%.==2 ([LF]!%%~1!"
        Set "!AutoMacro!=!%%~1!)Else Set @.Args=[LF]"
      )
      If not "!%%~1.switches:/selfRef=!" == "!%%~1.switches!" Set "!AutoMacro!=!%%~1:@.=%%~1.!"
    )

    Rem end stage macro parseing
    Set "!AutoMacro!=!%%~1:%%%%=%%!"
    Set "!AutoMacro!=!%%~1:~0,-4!"

    REM collapse parentheses indentation to conserve environment space
    Set "!AutoMacro!=!%%~1:([LF]=(!"
    Set "!AutoMacro!=!%%~1:[LF])=)!"
    Set "!AutoMacro!=!%%~1:)   )=))!"
    Set "!AutoMacro!=!%%~1:)  )=))!"
    Set "!AutoMacro!=!%%~1:) )=))!"
    Set "!AutoMacro!=!%%~1:)[LF])[LF]=))[LF]!"
    Set "!AutoMacro!=!%%~1:)[LF])[LF])[LF]=)))[LF]!"
    Set "!AutoMacro!=!%%~1:))[LF])[LF]=)))[LF]!"
    Set "!AutoMacro!=!%%~1:))[LF]) Else =))) Else !"
    Set "!AutoMacro!=!%%~1:))[LF])Else =)))Else !"
    Set "!AutoMacro!=!%%~1:))[LF]))[LF]=))))[LF]!"
    Set "!AutoMacro!=!%%~1:)))[LF])))[LF]=))))))[LF]!"
    Set "!AutoMacro!=!%%~1:[LF][LF]=[LF]!"
    Set ^"!AutoMacro!=!%%~1:[LF]=^%LF%%LF%!"
    If defined AutoMacro.debug >>"!debug.file!" (
       Echo(
       Echo(======================================================================================
       Set "!AutoMacro!"
       Echo(======================================================================================
       Echo(

    )
    If defined AutoMacro.help (
      If not defined !AutoMacro!.dependency (
        If defined !Automacro!_usage (
          Echo(!%%1_usage!
        )Else Echo(!AutoMacro! contains no usage information.
      )
    )
    If defined AutoMacroScripting (
      1>&2 Echo(Error. Unterminated scripting block in !automacro!
      1>&2 Echo(       If a multiline remark begins within a scripting block,
      1>&2 Echo(       it must be terminated before the scripting block is terminated.
      1>&2 Pause
      Exit /b 1
    )
    If defined AutoMacroRemarking (
      1>&2 Echo(Error. Unterminated multiline remarking block in !automacro!
      1>&2 Pause
      Exit /b 1
    )
    Rem undefine control flow variables
    Set "AutoMacroToken[1]="
    Set "AutoMacroToken[2]="
    Set "AutoMacroTruncate="
    Set "AutoMacroRemarking="
    Set "AutoMacroScripting="
    Set "!AutoMacro!.i="
    Set "!AutoMacro!.start="
    Set "!AutoMacro!.end="
    Set "!AutoMacro!.switches="
    Set "!AutoMacro!_Dependencies="
    Set "!AutoMacro!.path="
    If defined AutoMacro.help (
      If not defined !AutoMacro!.dependency Pause
      Set "!AutoMacro!.dependency="
      Set "!AutoMacro!="
    )
  )
)
If defined AutoMacro.help Endlocal
Exit /b 0