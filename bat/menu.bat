@echo off

:: настройка цвета
color 0A
chcp 65001

:menu
cls
echo ====================================
echo         Главное меню
echo ====================================
echo 1. Download Software
echo 2. Download data vps
echo 3. Upload data vps
echo 4. putty
echo 5. rdp
echo 6. switch config 
echo 7. ssh proxy
echo 8. createvm
echo 9. Alpine deploy
echo 10. test
echo 0. Выход
echo ====================================
set /p choice="Выберите опцию (0-9): "

if "%choice%"=="1" goto script1
if "%choice%"=="2" goto script2
if "%choice%"=="3" goto script3
if "%choice%"=="4" goto script4
if "%choice%"=="5" goto script5
if "%choice%"=="6" goto script6
if "%choice%"=="7" goto script7
if "%choice%"=="8" goto script8
if "%choice%"=="9" goto script9
if "%choice%"=="10" goto script10
if "%choice%"=="0" goto exit

echo Неверный выбор. Попробуйте еще раз.
pause
goto menu

:script1
cls
echo Download Software...
call scripts\download.software.bat
pause
goto menu

:script2
cls
echo Download data vps...
call scripts\download.bat
pause
goto menu

:script3
cls
echo Upload data vps...
call scripts\upload.bat
pause
goto menu

:script4
cls
echo Putty...
call scripts\putty.bat
pause
goto menu

:script5
cls
echo rdp...
call scripts\rdp.bat
pause
goto menu

:script6
cls
echo switch config txt ...
call scripts\switch.config.txt.bat
pause
goto menu

:script7
cls
echo ssh proxy...
call scripts\ssh.proxy.bat
pause
goto menu

:script8
cls
echo  createvm...
call scripts\createvm.bat
pause
goto menu

:script9
cls
echo  Alpine deploy...
call scripts\Alpine.deploy.bat
pause
goto menu

:script10
cls
echo  test...
call scripts\test.bat
pause
goto menu

:exit
echo Выход из программы.
pause
exit
