@echo off
setlocal enableextensions

:: set these values
::
::
:: JSON filepath
set exportFilePath=C:\exports
::
:: JSON filename
set exportFileName=stats.json
::
:: local backup drive letter
set driveLetter=J
::
::

set exportFullPath=%exportFilePath%\%exportFileName%

:: make export directory if it doesn't export
md %exportFilePath%
:: touch export file
copy /y nul %exportFullPath%

set updateCountKey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\UAS"
set updateCountValue=UpdateCount
set updateCount=

set lastInstallKey="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install"
set lastInstallValue=LastSuccessTime
set lastInstall=

:: get number of updates to be installed
for /f "usebackq skip=2 tokens=1-3" %%a in (`reg query %updateCountKey% /v %updateCountValue% 2^>nul`) do (
    set updateCount=%%c
)

:: get date of last successful update
for /f "usebackq skip=2 tokens=1-3" %%a in (`reg query %lastInstallKey% /v %lastInstallvalue% 2^>nul`) do (
    set lastInstall=%%c
)

:: get size and free space of backup volume
set freeSpace=
set size=

for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='%driveLetter%:'" get FreeSpace /format:value`) do set freeSpace=%%x
for /f "usebackq delims== tokens=2" %%x in (`wmic logicaldisk where "DeviceID='%driveLetter%:'" get Size /format:value`) do set size=%%x
set freeSpace=%freeSpace:~0,-6%
set size=%size:~0,-6%

:: write data as JSON to export file
@echo { updateCount: "%updateCount%", lastInstall: "%lastInstall%", volSize: "%size%", volFree: "%freeSpace%" } > %exportFullPath%
