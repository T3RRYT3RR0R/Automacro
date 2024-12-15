:AutoMacro <macroname> [macroname]
:AutoMacro <macroname> /? [/centre] [/right]
:AutoMacro <macroname> /? [macroname]
@echo off
REM Designed for use with Codepage 850 with UTF-8 bom-less encoding. Untested for other codepages / encodings.

(More <"%~f0:firstRun.dat") 2> nul 1> nul || (
  REM apply read only attribute to automacro.bat and it's helpfile.
  Echo(true 1>"%~f0:firstRun.dat"
  attrib +R "%~f0"
  attrib +R "%~dp0readme.txt"
) 
REM calling / opening this script without args will display it's helpfile.

REM :: Author T3RRY
REM :: Concept Contributors: Einstein1969 Grub4K
REM :: Script purpose: facilitate definition of complex macros in a simple manner
REM    that aids readability and verbose descriptions without negatively
REM    impacting environment size. Can be utitlized as a library system to
REM    enhance batch scripts.
REM :: inspired by https://ss64.org/viewtopic.php?t=65
REM :: https://discord.gg/batch
REM :: https://discord.com/channels/288498150145261568/1264550373126049813

REM first line in this script matching regex vINT.INT.INT is used as the Build vesion [Major.Minor.Patch]
REM Version history:
REM :: v3.0.1 08/12/2024
REM ::   Added interactive help menu.
REM :: v3.0.0 25/11/2024
REM ::   Added Switch for specifying Automacro version requirement during macro definition.
REM ::   } @macroname [/Ver:<major>.<minor>.<patch>]
REM ::   This versioning feature supported from build 3.0.0 onwards.
REM ::   Added alternate syntax for specifying macro usage:
REM ::   Rather than specifying usage using:
REM ::    @macroname usage: -your usage info-
REM ::   Usage information can now be included using:
REM ::   /?: -your usage info-
REM ::   Note: trailing whitespace in "/?: " is mandatory, and "/?: " is now a
REM ::   reserved keyword in Automacros Syntax. [potentially breaking change]
REM :: v2.2.5 21/08/2024
REM ::   Added help call to simplify access to macro's help info
REM :: v2.2.4 18/08/2024
REM ::   Added support for Inline comments using :: // or rem 
REM ::   previous behaviour was to undefine all lines containing:       " :: ", " // " or " rem "
REM ::   new behaviour is to truncate the line from the first instance of " :: ", " // " or " rem "
REM :: v2.2.3 16/08/2024
REM ::   Macro parsing reworked to improve performance and consolidate parse state management
REM ::   opening and closing tags: "macroname {" + "} macroname" may now be indented.
REM :: v2.2.2 09/08/2024
REM ::   macro pathfinding expanded to create a degree of resilience to folder relocation
REM ::   as long as automacro.bat is in the same folder as the calling script, and that folder
REM ::   is within a parent directory of the folder/s containing Macro's, automacro.bat
REM ::   will still locate the macro file.
REM :: https://semver.org/
Set "Automacro.Build.Major="
For /f "tokens=2,3,4 Delims=v:. " %%1 in ('%SystemRoot%\System32\Findstr.exe /R "[vV][0123456789]*\.[0123456789]*\.[0123456789]*" "%~f0"')Do (
  if not defined Automacro.Build.Major Set /a "Automacro.Build.Major=%%1","Automacro.Build.Minor=%%2","Automacro.Build.Patch=%%3"
)

If "%~1"=="" (
  mode 130,70

  (
    Echo Automacro Usage: CALL "%~f0" macroname [macroname] [/debug]
    Type "%~dp0readme.txt" 2> nul || Echo Helpfile not found
  ) | more
  Pause
  Exit /b 1
)

:Recurse
Set "AutoMacros= %*"

Set AutoMacros | %systemroot%\system32\findstr.exe /li "\/\? \-\?" > nul && (
  mode 130,70
  Setlocal EnableDelayedExpansion
  Set "AutoMacro.help=true"
  If defined AutoMacros Set "AutoMacros=!AutoMacros: /?=!"
  If defined AutoMacros Set "AutoMacros=!AutoMacros: -?=!"

  %= automacro /? styling for available macros. Supported - left centre right =%
  Set "alignmentStyle=left"
  For %%G in (left centre right) Do If defined AutoMacros (
    If not "!AutoMacros: /%%G=!" == "!AutoMacros!" (
      Set "alignmentStyle=%%G"
      Set "AutoMacros=!AutoMacros: /%%G=!"
    )
  )
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
If not "!PATH:;%~dp0=!" == "!PATH!" Set "PATH=%Path%;%~dp0"
If not "!PATH:;%automacroRoot%=!" == "!PATH!" Set "PATH=%Path%;%automacroRoot%"
If /i not "!PATHEXT:.mac=!" == "!PATHEXT!" Set "PATHEXT=!PATHEXT!;.mac"

(Set \n=^^^

%= Above empty line required =%)

REM the below defines the escape character 0x1B to the variable \E
For /F %%a in ('Echo prompt $E^| %comspec%')Do Set \E=%%a

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

REM help feature requires adherence to .mac extension type for macro files.
If defined Automacro.help if not defined AutoMacros (
  Rem arg contains help switch only. display names of any .mac files in tree of Root
  CLS
  PUSHD "!automacroRoot!"
  Set "itemMax=0"
  Set "item.i=0"
  Echo !\E![33m%~n0 !\E![0m execute %~n0 without Args to see %~n0's help file.
  Echo !\E![33m%~n0 /? !\E![90mThis help output!\E![0m       - display available macros
  Echo !\E![33m%~n0 /?!\E![0m [!\E![36m/left!\E![90m^|!\E![36m/centre!\E![90m^|!\E![36m/right!\E![0m] - apply formatting to the displayed output
  Echo for macro specific help, use:
  Echo !\E![33m%~n0 macroname /?!\E![0m
  Echo !\E![B!\E![7mAvailable Macros:!\E![0m
  For /f "delims=" %%G in ('Dir /b /s @*.mac')Do (
    Set /a item.i+=1
    Set "item[!item.i!]=%%~nG"
    %strlen% item[!item.i!] itemWidth
    Set /a item[!item.i!].len=itemWidth
    If !itemWidth! GTR !itemMax! Set /a itemMax=itemWidth + 1
  )
  Set "currentWidth=1"
  Set "currentHeight=8"
  Set /a "newRow=130-itemMax"
  For /l %%i in (1 1 !item.i!)do (
    Set /a "alignLeft=currentWidth","alignRight=currentWidth + ( itemMax - item[%%i].len )","alignCentre=currentWidth + ((( itemMax - item[%%i].len )+1)/2)"
    Echo(!\E![!currentHeight!;!align%alignmentStyle%!H!item[%%i]!
    Set /a currentWidth+=itemMax
    If !currentWidth! GEQ !newRow! Set /a currentWidth=1,currentHeight+=1
  )
  
  POPD
  Echo(!\E![E!\E![33mEnter Interactive Help !\E![32mY!\E![90m/!\E![31mN!\E![0m?
  For /f "delims=" %%G in ('%Systemroot%\system32\choice.exe /N /C:YN')Do if /i "%%G" == "Y" Call:InteractiveHelp
  Endlocal & Exit /b 0
)

Set HELP=For %%. in (1 2)Do if %%. EQU 2 (For %%H in (^^^!helpfiles^^^!)Do If exist "%TEMP%\%%H.hlp" More ^< "%TEMP%\%%H.hlp"^)Else Set helpfiles=

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
      For /f "tokens=1,* Delims=:" %%U in ('%SystemRoot%\System32\findstr.exe /linc:"!AutoMacro! usage" /linc:"/?: " "!%%~1.path!"')Do (
        If not defined !AutoMacro!_usage Set "!AutoMacro!_usage=!AutoMacro! Usage:!LF!!LF!"
        Set "!AutoMacro!.start=%%U"
        rem trailing whitespace supports automated syntax highlighting.
        Set "Line=%%V "
        If defined Line Set "Line=!Line:/?:=%%~1 usage:!"%= new =%
        Rem apply syntax highlighting to primary usage info.
        If /i not "!Line: %%%%~1%% =!" == "!line!" (
          Set "line=!line:]] =] ] !"
          Set "line=!line: [[= [ [!"
          Set "line=!line: %%@=```<lightblue>```%%```<yellow>```@!"
          Set "line=!line:%% =```<lightblue>```%%```<yellow>``` !"
          Set "line=!line: <= ```<grey>```<```<yellow>```!"
          Set "line=!line:> =```<grey>```>```<yellow>``` !"
          Set "line=!line: [= ```<grey>```[```<yellow>```!"
          Set "line=!line:] =```<grey>```]```<yellow>``` !"
          Set "line=!line: | =```<grey>``` | ```<yellow>```!"
          Set "line=!line:```=!"
        )
        rem if line contains ' : ' seperator style yellow : white
        rem unless line is contionation / bullet point marked by ' - '
        If /i not "!Line: : =!" == "!line!" If "!Line: - =!" == "!line!" (
          Set "Line=!Line:usage:=usage:<yellow>!"
          Set "Line=<yellow>!Line: : = <default>: !"
        )
        Set "!AutoMacro!_usage=!%%~1_usage!!line:*usage:=!!\E![0m!LF!"
      )
      If defined !AutoMacro!_Usage (
        Set "!Automacro!_usage=!%%~1_usage:<red>=%\E%[31m!"
        Set "!Automacro!_usage=!%%~1_usage:<green>=%\E%[32m!"
        Set "!Automacro!_usage=!%%~1_usage:<yellow>=%\E%[33m!"
        Set "!Automacro!_usage=!%%~1_usage:<darkblue>=%\E%[34m!"
        Set "!Automacro!_usage=!%%~1_usage:<purple>=%\E%[35m!"
        Set "!Automacro!_usage=!%%~1_usage:<lightblue>=%\E%[36m!"
        Set "!Automacro!_usage=!%%~1_usage:<white>=%\E%[37m!"
        Set "!Automacro!_usage=!%%~1_usage:<grey>=%\E%[90m!"
        Set "!Automacro!_usage=!%%~1_usage:<flash>=%\E%[5m!"
        Set "!Automacro!_usage=!%%~1_usage:<default>=%\E%[0m!"
      )
    )

    If not "!%%~1_Dependencies!" == "" For %%D in (!%%~1_Dependencies!)Do (
      If defined Automacro.help (
        Set "AutoMacro.temp=%%D"
        Set ^"AutoMacro.temp=!AutoMacro.temp:"=!"
        For /f "tokens=1 delims= " %%C in ("!AutoMacro.temp!")Do Set "%%C.dependency=1"
        Set "Automacro.temp="
      )
      Call:Recurse %%D
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
      If defined !AutoMacro!.switches If not "!%%~1.Switches:/Ver:=!" == "!%%~1.Switches!" (
       For /f "Tokens=1,2,3 Delims=. " %%G in ("!%%~1.Switches:*/Ver:=!") Do (
          Set "compat="
          Set "Automacro.Major.req=%%G"
          Set "Automacro.Minor.req=%%H"
          Set "Automacro.Patch.req=%%I"
          If !Automacro.Build.Major! GTR !Automacro.Major.req! Set "compat=1"
          If !Automacro.Build.Major! GEQ !Automacro.Major.req! If !Automacro.Build.Minor! GTR !Automacro.Minor.req! Set "compat=1"
          If !Automacro.Build.Major! GEQ !Automacro.Major.req! If !Automacro.Build.Minor! GEQ !Automacro.Minor.req! If !Automacro.Build.Patch! GEQ !Automacro.Patch.req! Set "compat=1"
          If not defined compat (
            Echo(!Automacro! requires Automacro build [%%G.%%H.%%I] or newer.
            Echo(This version: [!Automacro.Build.Major!.!Automacro.Build.Minor!.!Automacro.Build.Patch!]
            Echo(Contact the Macro Author for a copy of the required bat.
            PAUSE
            EXIT
          )
        )
      )		
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
          If defined line if "!Line:*/?:=!" == "" Set "Line="%= handle empty help lines using this form =%
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
        Set "!AutoMacro!=!%%~1!) Else Set @.Args=[LF]"
      )
      If not "!%%~1.switches:/selfRef=!" == "!%%~1.switches!" Set "!AutoMacro!=!%%~1:@.=%%~1.!"
    )

    If defined AutoMacro.debug >>"!debug.file!" (
       Set "!AutoMacro!.clone=!%%~1:~0,-4!"
       Set ^"!AutoMacro!.clone=!%%~1.clone:[LF]=%%\n%%^%LF%%LF%!"
       Echo(======================================================================================
       Echo( traditional macro. requires escaping to be added.
       Echo(======================================================================================
       <nul set /p "=Set "& Set "!AutoMacro!.clone"
       Echo(======================================================================================
       Echo(
       Set "!AutoMacro!.clone="
    )

    Rem end stage macro parsing
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
          CLS
          Echo(!\E![0m!\E![K!\E![E!%%1_usage!!\E![0J
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

:InteractiveHelp
setlocal enableExtensions enableDelayedexpansion
Call:DefMacros

 REM record:field datastructure implementation
 rem          recordName=;FieldVar:"fieldSubVar=value" "fieldSubVar=value";FieldVar:"fieldSubVar=value" "fieldSubVar=value"

 rem example usage:
 For /f "delims=" %%G in ('Where Automacro.bat')do (
   set "AutoMacroRoot=%%G"
   set "AutoMacro.bat=%%G"
   set "AutoMacroRoot=!AutoMacroRoot:Examples\%%~nxG=!"
 )
 Set "Macros="
 Set "Directory="
 Set "RootMenu="

 For /f "delims=" %%G in ('Dir /b /s "!AutomacroRoot!*.mac"')Do (
   If not "!Directory!" == "%%~dpG" (
     Set "Directory=%%~dpG"
     Set "Record=!Directory:~0,-1!"
     For /f %%L in ("!Record!") Do (
       Set "RootMenu=!Rootmenu! %%~nL"
       Set "Record=%%~nL"
     )
   )
   For %%R in (!Record!) Do Set %%R=!%%~R!;%%~nG:"%%~G"
 )

:Menu Root
 CLS
 %menu:Return=endMenu% /R RootMenu /H: Select macro category:
 Set "RootSelected=!Menu{String}!"
:Tree
 CLS
 %menu:Return=Menu% /R !RootSelected! /H: Select macro:
 For /f "Delims=" %%G in ("!Menu{Field}!")Do (
   Call "%AutoMacro.bat%" -? %%~nG
   Set filepath="%%~G"
   Set "Branch.header=Choose an action for:!\E![E %%~nxG !filepath!"
 )
:Branch
 CLS
 %menu:Return=Tree% Back End Open Edit "Select New" /H: !Branch.Header!
 If /i "!Menu{String}!" == "Open" (
   attrib +r !filepath!
   start /wait "" notepad.exe !filepath!
   attrib -r !filepath!
   goto:Tree
 )
 If /i "!Menu{String}!" == "Edit" (
   Notepad.exe !filepath!
   Goto:Branch
 )
 If /i "!Menu{String}!" == "Select New" goto:Menu
rem For %%G in (!RootMenu!)do Set %%G
PAUSE
:endMenu
CLS & Endlocal & Goto:Eof

:DefMacros
==================================================== REM = Menu macro Definition BEGIN
REM IMPORTANT - Menu macro is Escaped for definition in an EnableDelayedExpansion Environment.
REM IMPORTANT - RESERVED VARIABLES: Menu* @while $while $while.i \n

(Set \n=^^^

%= do not modify this \n defintion =%)

 Set @while=For %%z in (1 1 16)do if not defined $while
 Set "@while=Set $while=&Set /a $while.i=0 & !@while! !@while! !@while! !@while! Set /a $while.i+=1 &"

  REM ======                Menu macro by T3RRY.                ======
  rem menu usage/s:
:+ %Menu% <option> [option] ["doublequote option with whitespace"]
:+ %Menu% /R recordVarName [/Set]
  rem if /R is present as first option, menu uses the subsequent argument as a record to buid the option list from
  rem /Set : optional 3rd argument : Iterate selected field in the record to assign data
  rem        - requires the record to utilize the following data structure:
  rem          recordName=;FieldVar:"fieldSubVar=value" "fieldSubVar=value";FieldVar:"fieldSubVar=value" "fieldSubVar=value"
  rem        - Note: the number of FieldsubVars is not fixed.

  REM returns:
  REM Menu{String}    : the selected string
  REM Menu{Key}       : the key used to selectthe string
  REM Menu{Number}    : the position of the string in the options list
  REM /R returns:
  REM Menu{record}    : the name of the record supplied as the option list source
  REM Menu{field}     : the field data matching the selected reference option
  REM Menu{field}.var : the field variables present in the referenced field
  REM resources: 
  REM https://www.dostips.com/forum/viewtopic.php?t=9265#p60294
  REM https://www.dostips.com/forum/viewtopic.php?f=3&t=10983&sid=f6937e02068d93bc5a97ef63d4e5319e
  REM Macros with arguments learning resource:
  REM https://www.dostips.com/forum/viewtopic.php?f=3&t=1827

REM - use REM / remove REM on the below line to enable / disable menu dividing line
  REM Goto :NoDividingLine

  REM Get console width for dividing line. Requires cmd.exe conhost. incompatable with Windows Terminal.
    For /f "usebackq tokens=2* delims=: " %%W in (`mode con ^| %__APPDIR__%findstr.exe /LIC:"Columns"`) do Set /A "Console_Width=%%W"
    Set "Menu_Div=" & For /L %%i in (1 1 %Console_Width%)Do Set "Menu_Div=!Menu_Div!-"

:NoDividingLine
  REM Menu internal variables
  REM keymap. translates literal keypress to the numeric position of the item in the menu list
    Set /a Menu@0=36,Menu@1=1,Menu@2=2,Menu@3=3,Menu@4=4,Menu@5=5,Menu@6=6,Menu@7=7,Menu@8=8,Menu@9=9,Menu@a=10,Menu@b=11,Menu@c=12,Menu@d=13,Menu@e=14,Menu@f=15,Menu@g=16,Menu@h=17,Menu@i=18,Menu@j=19,Menu@k=20,Menu@l=21,Menu@m=22,Menu@n=23,Menu@o=24,Menu@p=25,Menu@q=26,Menu@r=27,Menu@s=28,Menu@t=29,Menu@u=30,Menu@v=31,Menu@w=32,Menu@x=33,Menu@y=34,Menu@z=35
  REM Valid choice characters
    Set "Menu.Keys=123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"

Set Menu=For %%n in (1 2)Do if %%n==2 (%\n%
  If defined Menu{Args} (%\n%
    %= Output Dividing Line                     =% If Defined Menu_Div Echo(^!Menu_Div^!%\n%
    %= Case{ /H - Apply header }                =% If not "^!Menu{Args}: /H:=^!" == "^!Menu{Args}^!" (%\n%
                                                     Set "Menu.header=^!Menu{Args}:*/H:=^!"%\n%
                                                     For /f "delims=" %%G in ("^!Menu.Header^!")Do (%\n%
                                                       Set "Menu{Args}=^!Menu{Args}:/H: %%G=^!"%\n%
                                                       Set "Menu{Args}=^!Menu{Args}:/H:%%G=^!"%\n%
                                                       Echo(^^^!menu.header^^^!%\n%
                                                       Echo(^!Menu_Div^!%\n%
                                                   ) )%\n%
    %= Reset Menu.# index for Menu.Item[#]      =% Set "Menu.#=0"%\n%
    %= Undefine choice command key list         =% Set "Menu.Chars="%\n%
    %= Test args for /R mode                    =% For /f "tokens=1,2,3" %%1 in ("^!Menu{Args}^!")Do (%\n%
    %= Case{ /R - build Menu Record Variable }  =%   If /i "%%1" == "/R" (%\n%
    %= Clear prior menu record data             =%     Set "menu{record}="%\n%
                                                       Set "menu.set="%\n%
    %= Case{ /Set - setFlag fieldSubVars }      =%     If /i "%%3" == "/Set" Set "menu.set=1"%\n%
    %= Reset Args; build options via recordVar  =%     Set "Menu{Args}=Back "%\n%
    %= Clone Record [ destructive parsing ]     =%     Set "menu.rec=^!%%2^!"%\n%
    %= Enforce Record Initiator                 =%     If "^!%%2:~0,1^!" == ";" Set "menu.rec=^!%%2:~1^!"%\n%
    %= Enforce Record terminator                =%     If not "^!%%2:~-1^!" == ";" Set "menu.rec=^!menu.rec^!;"%\n%
    %= Case{ Record defined - Parse While }     =%     If defined menu.rec !@while! (%\n%
    %= Split FeildID from FieldValue via Delims =%       If defined menu.rec For /f "EOL=^| tokens=1,2 Delims=;:" %%i in ("^!menu.rec^!") do (%\n%
    %= Append to options menu list              =%         Set "Menu{Args}=^!Menu{Args}^! %%i"%\n%
    %= Case{ FieldIDs.count EQU 36 - EndWhile } =%         If "^!$while.i^!" == "36" Set "$while=stop"%\n%
    %= remove current fieldID fieldValues pair  =%         Set "menu.rec=^!menu.rec:*;=^!"%\n%
    %= Case{ Record undefined - EndWhile }      =%       )Else Set "$while=stop"%\n%
                                                       )%\n%
    %= Return record name                       =%     Set "menu{record}=%%2"%\n%
                                                   ) )%\n%
    %= For Each in list;                        =% If defined Menu{Args} For %%G in (^^^!Menu{Args}^^^!)Do (%\n%
    %= For Menu.Item Index value                =%   For %%i in (^^^!Menu.#^^^!)Do If not %%i GTR 35 (%\n%
    %= Build the Choice key list                =%     Set "Menu.Chars=^!Menu.Chars^!^!Menu.Keys:~%%i,1^!"%\n%
    %= Define Menu.Item array                   =%     Set "Menu.Item[^!Menu.Keys:~%%i,1^!]=%%~G"%\n%
    %= Assign String for safe output            =%     Set "Menu.Output=%%~G"%\n%
    %= Display as [key] Option String           =%     Echo([^^^!Menu.Keys:~%%i,1^^^!] ^^^!Menu.Output^^^!%\n%
    %= Increment Menu.# Index var               =%     Set /A "Menu.#+=1"%\n%
    %= Close Menu.# expansion loop              =%   )%\n%
    %= Close Menu{Args} String loop             =% )%\n%
    %= Output Dividing Line                     =% If Defined Menu_Div Echo(^^^!Menu_Div^^^!%\n%
    %= Select option by character index         =% For /f "delims=" %%o in ('%__APPDIR__%Choice.exe /N /C:^^^!Menu.Chars^^^!')Do For /f "tokens=1,2 delims=;" %%V in ("^!Menu.Item[%%o]^!;^!Menu@%%o^!")Do (%\n%
    %= exit [sub]script w/out modifying option  =%   If /I "%%V" == "Exit" Exit /B 2%\n%
    %= goto tartget w/out modifying option      =%   If /I "%%V" == "Back" Goto:Return%\n%
    %= Assign 'Menu{String}' w/literal string   =%   Set "Menu{String}=%%V"%\n%
    %= Assign 'Menu{key}' with key pressed      =%   Set "Menu{Key}=%%o"%\n%
    %= Assign 'Menu{Number} with list position  =%   Set "Menu{Number}=%%~W"%\n%
    %= Case{ /R - extract field from record }   =%   If defined menu{record} (%\n%
                                                       Set "menu{field}="%\n%
                                                       For /f "tokens=1,2,*" %%U in ("^!menu{record}^! menu{field} ^!Menu{String}^!")Do (%\n%
                                                         Set "%%~V="%\n%
                                                         If /i not "^!%%~U:;%%~W:=^!" == "^!%%~U^!" (%\n%
                                                           Set "Menu.lookup=^!%%U:*;%%~W:=^!"%\n%
                                                           For /f "EOL= tokens=1 Delims=;" %%R in ("^!Menu.lookup^!; ")Do (%\n%
                                                             If not defined %%~V (%\n%
                                                               Set "%%~V=%%R"%\n%
                                                             ) else (%\n%
                                                               If "^!%%~V^!"=="^!%%~V:%%R=^!" Set "%%~V=^!%%~V^!,%%R"%\n%
                                                       ) ) ) )%\n%
    %= Case{ fieldSubVar assignment flagged }   =%     if defined menu.set if defined menu{field} (%\n%
                                                         Set "menu{field}.var="%\n%
    %= For each FieldValue in Field             =%       For %%G in (^^^!menu{field}^^^!)Do (%\n%
                                                           For /f "tokens=1 delims=,:;= " %%1 in ("%%~G")do Set "menu{field}.var=^!menu{field}.var^! %%1"%\n%
    %= Return fieldSubVars                      =%         Set "%%~G"%\n%
                                                     ) ) )%\n%
    %= Reset Menu Argument variable             =%   Set "Menu{Args}="%\n%
    %= Close Menu macro processing loops        =% )%\n%
  )%\n%
%= Capture Macro input - Options List       =%)Else Set Menu{Args}=
  Set "@while="
========================================== REM = Menu Macro Definition END
Goto:Eof