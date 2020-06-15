@ECHO off
echo =====================================
echo ~~ BuildSmart Report Cache Utility ~~
echo ~~                                 ~~
echo ~~  Clears reporting cache for BS  ~~
echo ~~                                 ~~
echo ~~           Designed  by          ~~
echo ~~             J. Brink            ~~
echo ~~               For               ~~
echo ~~ Construction Computer Software  ~~
echo ~~                                 ~~
echo ~~         Rev: 20200615.03        ~~
echo =====================================
echo.

goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...
	echo.

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo [SUCCESS] Administrative permissions confirmed.
		echo.
		echo Continuing to BuildSmart Report Caching Utility.
		echo.
		goto start_proc
    ) else (
        echo *** [ERROR] Current permissions inadequate. Please Re-Run this Tool as an Administrator.
		PAUSE
		exit
    )

    pause >nul

:start_proc

	ECHO Clearing BuildSmart Cached Reports...


	REM Check if Internet Explorer is open, and close it to release dir handles
	tasklist /FI "IMAGENAME eq iexplore.exe" 2>NUL | find /I /N "iexplore.exe">NUL && (
		echo Internet Explorer is Running. The utility will close it to continue running.
		taskkill -f -im iexplore.exe
		echo.
		echo # Internet Explorer: Closed. Continuing...) || (
		echo # Internet Explorer: Closed. Continuing...
	)

	ECHO.
	SET bsvdir=%LOCALAPPDATA%\VirtualStore\Program Files\BuildSmart
	SET bspfdir=%ProgramFiles%\BuildSmart
	IF NOT EXIST "%bsvdir%" (
		ECHO * No Virtual Directory, moving to Physical Directory...
		GOTO NOVDIR
	) ELSE (
		ECHO * Virtual Directory Exists, starting VStore Procedure...
		GOTO VDIR
	)

:VDIR
	REM CD's into Program Files\BuildSmart and does cache checks, deletes cache folders
	ECHO.
	ECHO ================
	ECHO VStore Procedure
	ECHO ================


	CD %bsvdir%
	ECHO.
	ECHO Now in path %CD%
	ECHO.

	REM Check if ACC Reports exists in VStore and Delete Directory
	ECHO * Checking if accReports exists...
	IF EXIST "accReports" (
		ECHO # accReports: YES - Clearing Cached Files...
		RMDIR /S /Q accReports
	) ELSE (
		ECHO # accReports: NO - Skipping
	)

	REM Check if POS Reports exists in VStore and Delete Directory

	ECHO.
	ECHO * Checking if posReports exists...
	IF EXIST "posReports" (
		ECHO # posReports: YES - Clearing Cached Files...
		RMDIR /S /Q posReports
	) ELSE (
		ECHO # posReports: NO - Skipping
	)

	REM Check if POS Reports exists in VStore and Delete Directory

	ECHO.
	ECHO * Checking if wgsReports exists...
	IF EXIST "wgsReports" (
		ECHO # wgsReports: YES - Clearing Cached Files...
		RMDIR /S /Q wgsReports
	) ELSE (
		ECHO # wgsReports: NO - Skipping
	)

	ECHO.
	ECHO # [COMPLETE] VirtualStore Checking!
	
	GOTO PDIR

:PDIR
	REM Checks if Program Files\BuildSmart exists
	ECHO.
	ECHO ============================
	ECHO Physical Directory Procedure
	ECHO ============================

	ECHO.
	IF NOT EXIST "%bspfdir%" (
		ECHO * No Physical Directory, creating directory...
		GOTO NOPDIR
	) ELSE (
		ECHO * Physical Directory Exists, starting Physical Utility Procedure...
		GOTO PDIRUTIL
	)


:PDIRUTIL
	REM CD's into Program Files\BuildSmart and does cache checks, deletes cache folders
	CD %bspfdir%
	ECHO.
	ECHO *** Now in path %CD% ***
	ECHO.

	REM Check if ACC Reports exists in PFDir and Delete Directory
	ECHO * Checking if accReports exists...
	IF EXIST "accReports" (
		ECHO # accReports: YES - Clearing Cached Files...
		RMDIR /S /Q accReports
	
	) ELSE (
		ECHO # accReports: NO - Skipping
	)

	REM Check if POS Reports exists in PFDir and Delete Directory

	ECHO.
	ECHO * Checking if posReports exists...
	IF EXIST "posReports" (
		ECHO # posReports: YES - Clearing Cached Files...
		RMDIR /S /Q posReports
	) ELSE (
		ECHO # posReports: NO - Skipping
	)

	REM Check if POS Reports exists in PFDir and Delete Directory

	ECHO.
	ECHO * Checking if wgsReports exists...
	IF EXIST "wgsReports" (
		ECHO # wgsReports: YES - Clearing Cached Files...
		RMDIR /S /Q wgsReports
	) ELSE (
		ECHO # wgsReports: NO - Skipping
	)
	
	ECHO.
	ECHO * Setting correct folder permissions for Physical Directory...
	cd ..
	icacls "BuildSmart" /grant Everyone:(OI)(CI)(M)
	ECHO.
	ECHO # Permissions: DONE!


	ECHO.
	ECHO # [COMPLETE] Physical Directory Checking!
	
	GOTO EOU


:NOPDIR 
	REM Creates the BuildSmart Report Cache Directory in Program Files
	CD %ProgramFiles%
	ECHO.
	ECHO *** Now in path %CD% ***
	ECHO.
	ECHO * Creating BuildSmart Cache Folder in current directory
	mkdir BuildSmart
	icacls "BuildSmart" /grant Everyone:(OI)(CI)(M)
	ECHO.
	ECHO # Permissions: DONE!
	ECHO # [COMPLETE] Directory Creation and Permission Assignment
	GOTO EOU
	


:EOU
	REM End of Utility
	ECHO.
	ECHO [NOTE TO USER] Utility has compeleted the required tasks. Please restart Internet Explorer and run any reports.
	TIMEOUT /T 5 /NOBREAK