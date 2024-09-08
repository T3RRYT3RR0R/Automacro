@echo off & setlocal Enabledelayedexpansion
CLS

rem this file in combination with @demo.mac can be used
rem to familiarise yourself with the syntax of automacro.bat

Call %~dp0automacro.bat @demo /debug
Echo=======================================================
Echo !\E![7m Expanded With args !\E![0m
%@demo% Hello World
Echo=======================================================
Echo !\E![7m Expanded Without args !\E![0m
%@demo%
Echo=======================================================
Echo !\E![7m %%Help%% call: !\E![0m
%Help% @demo
Echo=======================================================
Echo !\E![7m Definitions: !\E![0m
Set @demo
Echo=======================================================
Pause
endlocal
