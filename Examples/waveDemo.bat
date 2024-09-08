@echo off & setlocal enableDelayedExpansion &CLS

Call "%~dp0automacro.bat" @waveprint

Set output=%username% %computername% %date% %time%

%@waveprint% output 1 10 9 38;2;;;250
echo(!$waveprint!!\E![!y.lBound!d!\E![0m!\E![E
