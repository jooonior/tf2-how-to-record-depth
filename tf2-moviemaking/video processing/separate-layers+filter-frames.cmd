@echo off
title ffmpeg
echo This script separates the world and depth layers, and removes all duplicate frames using ffmpeg.
echo.

IF "%~1"=="" goto :NoInput

echo What framerate should the output be?
echo Enter a number representing the framerate (no spaces).
set /p "fps=> "
echo.

set "input=%~1"
set "world=%~dnp1-world.avi"
set "depth=%~dpn1-depth.avi"

echo Input:	%input%
echo World: %world%
echo Depth: %depth%
echo.

echo -- start of ffmepg output --
echo.
ffmpeg.exe -hide_banner -loglevel repeat+warning -stats -r "%fps%" -i "%~1" -filter_complex "[0]select='gte(scene,0)', split[in_world][in_depth]; [in_world]crop=iw/2:ih/2:0:0[out_world]; [in_depth]crop=iw/2:ih/2:iw/2:0[out_depth]" -c:v utvideo -map [out_world] "%world%" -c:v utvideo -map [out_depth] "%depth%"
echo.
echo -- end of ffmepg output --
echo.

IF %ERRORLEVEL% EQU 0 (
	echo Done. The window will now close.
	goto :Done
)

echo An error ocurred.
goto :Done

:NoInput
echo Usage: Drag and drop your video onto the script.
echo No input, closing.
echo.

:Done
pause