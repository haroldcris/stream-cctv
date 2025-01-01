@REM 
@REM taken from https://medium.com/@tom.humph/saving-rtsp-camera-streams-with-ffmpeg-baab7e80d767
@REM 

@echo off
@echo off
setlocal enabledelayedexpansion

:: Define the path to the .env file
set ENV_FILE=.env

:: Read the .env file line by line
for /f "usebackq tokens=* delims=" %%A in ("%ENV_FILE%") do (
    set line=%%A
    :: Skip empty lines and comments
    if not "!line!"=="" if not "!line:~0,1!"=="#" (
        :: Split the line into key and value
        for /f "tokens=1,2 delims==" %%B in ("!line!") do (
            set %%B=%%C
        )
    )
)


:: Check if param1 (IP address) is provided
if "%~1"=="" (
    echo Usage: stream.cmd [IP_ADDRESS] [DEVICE] [FOLDER]
    exit /b
)

if "%~2"=="" (
    echo Usage: stream.cmd [IP_ADDRESS] [DEVICE] [FOLDER]
    exit /b
)

if "%~3"=="" (
    echo Usage: stream.cmd [IP_ADDRESS] [DEVICE] [FOLDER]
    exit /b
)

:: Assign param1 to the IP variable
set IP=%~1
SET DEVICE=%~2
set FOLDER=%~3

:: Run the ffmpeg command with the specified IP address
echo 'Recording from %IP% of %DEVICE% to %FOLDER%...'
c:\ffmpeg\bin\ffmpeg -hide_banner -y -loglevel error -rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://admin:%DEVICE_PASSWORD%@%IP%:554/stream1 -vcodec copy -acodec copy -f segment -reset_timestamps 1 -segment_time 300 -segment_format mkv -segment_atclocktime 1 -strftime 1 -strftime_mkdir 1 "%FOLDER%\\%DEVICE%\\%%Y-%%m-%%d\\%DEVICE%_%%Y-%%m-%%d_%%H.%%M.mkv"
::c:\ffmpeg\bin\ffmpeg -hide_banner -y -loglevel error -rtsp_transport tcp -use_wallclock_as_timestamps 1 -i rtsp://admin:%DEVICE_PASSWORD%@%IP%:554/stream1 -vcodec copy -acodec copy -f hls -reset_timestamps 1 -hls_time 300 -segment_format mkv -segment_atclocktime 1 -atomic_writing 1 -strftime 1 -strftime_mkdir 1 -hls_segment_filename "%FOLDER%\\%DEVICE%\\%%Y-%%m-%%d\\%DEVICE%_%%Y-%%m-%%d_%%H.%%M.mkv" "%FOLDER%\\%DEVICE%\\%%Y-%%m-%%d\\%%Y-%%m-%%d_Playlist.m3u8"

endlocal
