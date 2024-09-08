@echo off & Setlocal EnableDelayedExpansion
CHCP 65001 > nul
CLS
Call "%~dp0automacro.bat" @push @next

Set "$part="
Set "$data="


%@push% $data "{   }"
%@push% $data " \o/ "
%@push% $data "(/^^^!\)"
%@push% $data " (o) "
%@push% $data "  :  "

Set /a y=2,x=1
Set "screen="

(

  For /l %%i in (1 1 36)Do (
    %@Next% $data $part `
    Set "screen=!screen!!\E![!y!;!x!H!$part!"
    If !y! equ 7 Set /a x+=11
    set /a y=y %% 7 + 1
    Set "y=!y:1=2!"
  )
  Echo(!\E![Hstart: %time% // end: !time! !screen!!\E![8;1H
)

choice /n /c:01yn /d 0 /t 2 > nul

%@push% $data " ~ ~ "
cls
Set /a y=2,x=10
  Set delta=30000
  For /l %%i in (1 1 31)Do (
    Set /a y+=1,x+=1
    %@Next% $data $part[1] `
    %@Next% $data $part[2] `
    %@Next% $data $part[3] `
    %@Next% $data $part[4] `
    %@Next% $data $part[5] `

    Echo(!\E![1;1H!\E![2J!$data!!\E![!y!;!x!H!$part[1]!!\E![B!\E![!x!G!$part[2]!!\E![B!\E![!x!G!$part[3]!!\E![B!\E![!x!G!$part[4]!!\E![B!\E![!x!G!$part[5]!!\E![B
    For /l %%i in (1 1 !delta!)do rem delay
    Set /a delta=delta %% 75000 + 15000
  )
  Echo(!\E![8;1H

Pause > nul

Endlocal
Goto:eof
