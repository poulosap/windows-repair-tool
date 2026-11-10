@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows Repair Tool - Compatibility Edition 1.1
rem No downloads, PowerShell, automatic restart, or forced dismount.
rem Runtime validation on Windows is still required.
if not "%OS%"=="Windows_NT" goto unsupported
set "TOOLS=%SystemRoot%\System32"
if exist "%SystemRoot%\Sysnative\cmd.exe" set "TOOLS=%SystemRoot%\Sysnative"
set "SFC=%TOOLS%\sfc.exe"
set "DISM=%TOOLS%\dism.exe"
set "CHKDSK=%TOOLS%\chkdsk.exe"
set "FINDSTR=%TOOLS%\findstr.exe"
set "HAS_DISM_HEALTH=0"
if not exist "%FINDSTR%" goto startup
if not exist "%DISM%" goto startup
rem Help probe only: failure disables DISM rather than guessing support.
"%DISM%" /Online /Cleanup-Image /? 2>nul | "%FINDSTR%" /i /l /c:"/RestoreHealth" >nul
if not errorlevel 1 set "HAS_DISM_HEALTH=1"
:startup
cls
echo Windows Repair Tool - Compatibility Edition 1.1
echo.
ver
echo.
echo Run from an Administrator Command Prompt.
echo Back up important data and use reliable power before repairs.
echo Repair operations can take hours. No automatic timeout is applied.
echo This tool does not restart your computer or download other tools.
echo DISM may obtain Windows repair content from Windows Update.
echo Legacy Windows may require original installation media.
echo.
echo IMPORTANT: This version is static-reviewed, not Windows-tested.
echo Windows 2000 is a design target, NOT verified compatibility.
echo Read README.txt before using this tool.
echo.
pause
:menu
cls
echo ============================================================
echo Windows Repair Tool - Compatibility Edition 1.1
echo ============================================================
echo 1. System-file repair - DISM when detected, then SFC
echo 2. Disk status check - no repair switches
echo 3. Disk filesystem repair - CHKDSK /f
echo 4. Disk repair and sector recovery - CHKDSK /r
echo 5. Show environment and available tools
echo 6. Exit
echo.
set "MENU="
set /p "MENU=Enter a number from 1 to 6: "
rem Delayed expansion keeps entered metacharacters out of command parsing.
if "!MENU!"=="1" goto systemrepair
if "!MENU!"=="2" goto diskcheck
if "!MENU!"=="3" goto diskfix
if "!MENU!"=="4" goto diskrecover
if "!MENU!"=="5" goto information
if "!MENU!"=="6" goto finish
echo Invalid selection.
pause
goto menu
:systemrepair
cls
echo System-file repair changes protected Windows system files.
echo A matching repair source or installation media may be needed.
echo If Windows requests a restart, finish that before further repair.
echo.
set "CONFIRM="
set /p "CONFIRM=Type REPAIR to continue, or Enter to cancel: "
if not "!CONFIRM!"=="REPAIR" goto menu
if "!HAS_DISM_HEALTH!"=="1" goto dismrepair
echo DISM RestoreHealth was not detected. Skipping it.
goto sfcrepair
:dismrepair
echo Running DISM. Native output follows.
"%DISM%" /Online /Cleanup-Image /RestoreHealth
set "RESULT=!errorlevel!"
echo DISM exit code: !RESULT!
if "!RESULT!"=="0" goto sfcrepair
echo DISM did not return ordinary success. Read its output first.
echo A restart, matching source, or manual troubleshooting may be needed.
set "CONFIRM="
set /p "CONFIRM=Type SFC to attempt SFC anyway, or Enter for menu: "
if not "!CONFIRM!"=="SFC" goto menu
:sfcrepair
if not exist "%SFC%" goto nosfc
echo Running System File Checker. Native output follows.
"%SFC%" /scannow
set "RESULT=!errorlevel!"
echo.
echo SFC exit code: !RESULT!
echo Read its native result. Exit code alone is not a diagnosis.
echo This tool does not claim that Windows is fully repaired.
pause
goto menu
:nosfc
echo SFC was not found at the expected system path.
pause
goto menu
:diskcheck
set "DISK_ARGS="
set "DISK_DESCRIPTION=Disk status check without repair switches"
goto selectdrive
:diskfix
set "DISK_ARGS=/f"
set "DISK_DESCRIPTION=Filesystem repair"
goto selectdrive
:diskrecover
set "DISK_ARGS=/r"
set "DISK_DESCRIPTION=Filesystem repair and sector recovery"
goto selectdrive
:selectdrive
cls
if not exist "%CHKDSK%" goto nochkdsk
echo !DISK_DESCRIPTION!
echo Enter exactly one LOCAL drive letter, such as C. Enter cancels.
set "DRIVE="
set /p "DRIVE=Drive letter: "
if not defined DRIVE goto menu
rem Only a fixed allowlisted letter can reach CHKDSK.
set "VALID_DRIVE=0"
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if /i "!DRIVE!"=="%%L" (
        set "VALID_DRIVE=1"
        set "DRIVE=%%L"
    )
)
if not "!VALID_DRIVE!"=="1" goto invaliddrive
echo.
echo Requested command: CHKDSK !DRIVE!: !DISK_ARGS!
echo CHKDSK does not support network drives or every filesystem.
echo Close applications using this volume.
if not defined DISK_ARGS goto diskconfirm
echo.
echo WARNING: This operation can change the filesystem.
echo Back up data first. For suspected hardware failure, prioritize recovery.
echo Sector recovery can take many hours; it cannot repair failed hardware.
echo Read native prompts carefully. No scheduling or dismount is auto-approved.
echo Answering a dismount prompt can interrupt applications using the disk.
:diskconfirm
set "CONFIRM="
set /p "CONFIRM=Type RUN to continue, or Enter to cancel: "
if not "!CONFIRM!"=="RUN" goto menu
"%CHKDSK%" !DRIVE!: !DISK_ARGS!
set "RESULT=!errorlevel!"
echo.
echo CHKDSK exit code: !RESULT!
if "!RESULT!"=="0" echo Documented meaning: no errors found.
if "!RESULT!"=="1" echo Documented meaning: errors found and fixed.
if "!RESULT!"=="2" echo Documented meaning: cleanup performed or not performed without /f.
if "!RESULT!"=="3" echo Documented meaning: check failed, or errors could not be or were not fixed.
echo Read the native output, especially any scheduling or access messages.
echo This tool does not independently verify boot-time scheduling.
pause
goto menu
:invaliddrive
echo Invalid input. Enter exactly one letter A through Z, without a colon.
pause
goto menu
:nochkdsk
echo CHKDSK was not found at the expected system path.
pause
goto menu
:information
cls
ver
echo Windows directory: !SystemRoot!
echo System drive: !SystemDrive!
echo Tool directory: !TOOLS!
if exist "%SFC%" (echo SFC: found) else (echo SFC: not found)
if exist "%CHKDSK%" (echo CHKDSK: found) else (echo CHKDSK: not found)
if "!HAS_DISM_HEALTH!"=="1" (
    echo DISM RestoreHealth: advertised by installed help
) else (
    echo DISM RestoreHealth: not detected; disabled
)
echo Tool presence does not prove permission or successful repair.
echo A failed help probe may mean lack of elevation, not lack of support.
echo No pending-reboot status is inferred.
pause
goto menu
:unsupported
echo This implementation requires NT-based Windows and cmd.exe.
echo Windows 3.x, 95, 98 and Me are outside its scope.
pause
:finish
endlocal
exit /b
