@echo off
title Scale video using ffmpeg

if not exist "%~1" goto :NoInput

set "input=%~f1"
set "output=%~dpn1_resized.mp4"

echo:Input:  %input%
echo:Output: %output%
echo:
echo What resolution do you want the output to be? [width]x[height]
echo Example: 1920x1080
set /p "resolution=> "
echo:

echo Starting ffmpeg . . .
echo:ffmpeg -i "%input%" -c:v libx264 -preset ultrafast -crf 0 -pix_fmt yuvj420p -vf scale=%resolution%:flags=lanczos "%output%"
echo:

ffmpeg -hide_banner -loglevel repeat+error -stats -i "%input%" -c:v libx264 -preset ultrafast -crf 0 -pix_fmt yuvj420p -vf scale=%resolution%:flags=lanczos "%output%"

echo:
if errorlevel 0 echo Done. The window will now close.
pause
goto :eof


:NoInput
echo Usage: Drag and drop your video onto the script.
echo No video input, closing.
echo:
pause
