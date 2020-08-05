@echo off
title Remove duplicate frames using ffmpeg

if not exist "%~1" goto :NoInput

set "input=%~f1"
set "output=%~dpn1_without_duplicate_frames.mp4"

echo:Input:  %input%
echo:Output: %output%
echo:
echo What framerate do you want the output to be? [number]
set /p "framerate=> "
echo:

echo Starting ffmpeg . . .
echo:ffmpeg -r "%framerate%" -i "%input%" -c:v libx264 -preset ultrafast -crf 0 -pix_fmt yuvj420p -vf select='gte(scene,0)' "%output%"
echo:

ffmpeg -hide_banner -loglevel repeat+error -stats -r "%framerate%" -i "%input%" -c:v libx264 -preset ultrafast -crf 0 -pix_fmt yuvj420p -vf select='gte(scene,0)' "%output%"

echo:
if errorlevel 0 echo Done. The window will now close.
pause
goto :eof


:NoInput
echo Usage: Drag and drop your video onto the script.
echo No video input, closing.
echo:
pause
