##07/11/2023 COPY_FORMAT_INFO

@echo off
title COPY_FORMAT_INFO
color 70
mode con cols=75
mode con lines=35

set currentuserpath=%HOMEDRIVE%%HOMEPATH%
set username=%USERNAME%
set usernamebkp=%username%_BKP
set userpath=%~dp0
set userpath=%userpath%%usernamebkp%
set indx=0

:start
IF exist %usernamebkp% (echo *) ELSE (md %userpath% && echo %usernamebkp% created)
CHOICE /c CDBE /m "CopyDatta, OnlyDrivers, Both, Exit"
set day=%date:~5,2%
set month=%date:~8,2%
set year=%date:~11,4%
IF %ERRORLEVEL% EQU 1 goto startdatta
IF %ERRORLEVEL% EQU 2 goto startdrivers
IF %ERRORLEVEL% EQU 3 goto both
IF %ERRORLEVEL% EQU 4 goto end

:both
set indx=1
goto startdrivers

:startdrivers
echo ------------------------------------------------
echo 		     DRIVERS
echo ------------------------------------------------
CHOICE /c ACRIE /m "CopyAll, Copy/MSI, Restore/MSI, DriversInfo, Exit"
IF %ERRORLEVEL% EQU 1 goto dir
IF %ERRORLEVEL% EQU 2 goto dir
IF %ERRORLEVEL% EQU 3 goto dir
IF %ERRORLEVEL% EQU 4 goto info
IF %ERRORLEVEL% EQU 5 goto end

:dir
set namefolder=DRIVERS_BKP_%username%_%day%_%month%_%year%
set namefolder=%userpath%\%namefolder%
IF %ERRORLEVEL% EQU 3 goto restoreMSI
echo The copy will be made in the directory: drivers %namefolder%
PAUSE
md %namefolder%
IF %ERRORLEVEL% EQU 1 goto copyall
IF %ERRORLEVEL% EQU 2 goto copyMSI

:copyall
set syspath=%systemroot%\system32\DriverStore\FileRepository
echo ------------------------------------------------
echo COPYING ALL DRIVERS
echo ------------------------------------------------
Xcopy %syspath% %namefolder% /O /X /E /H /K /J /Y
IF %ERRORLEVEL% GTR 6 goto error
echo ------------------------------------------------
echo SUCCESSFUL COPY
echo ------------------------------------------------
IF %indx% EQU 1 ( goto startdatta ) ELSE ( goto startdrivers )

:copyMSI
echo ------------------------------------------------
echo COPYING ONLY MSI DRIVERS
echo ------------------------------------------------
dism /online /export-driver /destination:%namefolder%
IF %ERRORLEVEL% GTR 6 goto error
echo ------------------------------------------------
echo SUCCESSFUL COPY
echo ------------------------------------------------
IF %indx% EQU 1 ( goto startdatta ) ELSE ( goto startdrivers )

:restoreMSI
echo ------------------------------------------------
echo RESTORING ONLY MSI DRIVERS
echo ------------------------------------------------
Dism /online /Add-Driver /Driver:%namefolder% /Recurse
IF %ERRORLEVEL% GTR 6 goto error
echo ------------------------------------------------
echo SUCCESSFUL RESTORATION
echo ------------------------------------------------
PAUSE
exit

:info
echo ------------------------------------------------
echo DRIVERS INFO
echo ------------------------------------------------
Driverquery 
echo ------------------------------------------------
echo END REPORT
echo ------------------------------------------------
PAUSE
goto startdrivers

:error
echo ------------------------------------------------
echo **********************ERROR*********************
echo ------------------------------------------------
PAUSE
goto startd

:startdatta
echo ------------------------------------------------
echo 		     DATTA
echo ------------------------------------------------
set namefolder1=DATTA_BKP_%username%_%day%_%month%_%year%
set namefolder=%userpath%\%namefolder1%
echo The copy will be made in the directory: drivers %namefolder%
PAUSE

set currentuserpathx=%currentuserpath%\Downloads
echo %currentuserpathx%
set namefolder=%userpath%\%namefolder1%\Downloads
md %namefolder%
echo %namefolder%
Xcopy %currentuserpathx% %namefolder% /O /X /E /H /K /j /Y

set currentuserpathx=%currentuserpath%\Desktop
echo %currentuserpathx%
set namefolder=%userpath%\%namefolder1%\Desktop
md %namefolder%
echo %namefolder%
Xcopy %currentuserpathx% %namefolder% /O /X /E /H /K /j /Y

set currentuserpathx=%currentuserpath%\Documents
echo %currentuserpathx%
set namefolder=%userpath%\%namefolder1%\Documents
md %namefolder%
echo %namefolder%
Xcopy %currentuserpathx% %namefolder% /O /X /E /H /K /j /Y

set currentuserpathx=%currentuserpath%\Pictures
echo %currentuserpathx%
set namefolder=%userpath%\%namefolder1%\Pictures
md %namefolder%
echo %namefolder%
Xcopy %currentuserpathx% %namefolder% /O /X /E /H /K /j /Y

set currentuserpathx=%currentuserpath%\Videos
echo %currentuserpathx%
set namefolder=%userpath%\%namefolder1%\Videos
md %namefolder%
echo %namefolder%
Xcopy %currentuserpathx% %namefolder% /O /X /E /H /K /j /Y
PAUSE
exit

:end
PAUSE
exit
