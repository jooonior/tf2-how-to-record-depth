@echo off
title ffplay
echo This script plays a video in ffplay.
echo.

IF "%~1"=="" goto :NoInput

ffplay -fs -i %1
IF %ERRORLEVEL% NEQ 0 goto :Done

goto :eof

:NoInput
echo Usage: Drag and drop your video onto the script.
echo No input, closing.
echo.

:Done
pause