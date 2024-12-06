@echo off
chcp 65001
setlocal enabledelayedexpansion

REM Задаем путь к файлу настроек
set "config_file=scripts\config.txt"
set "temp_file=%config_file%.tmp"

REM Создаем временный файл для записи изменений
> "%temp_file%" (
    for /f "usebackq tokens=*" %%A in ("%config_file%") do (
        set "line=%%A"

        REM Проверка на строку заголовка, чтобы её не изменять
        if "!line!"=="::config.txt" (
            echo !line!
        
        REM Если строка закомментирована (начинается с ::), убираем ::
        ) else if "!line:~0,2!"=="::" (
            echo !line:~2!
        
        REM Если строка не закомментирована, добавляем ::
        ) else (
            echo ::!line!
        )
    )
)

REM Перемещаем временный файл на место исходного
move /y "%temp_file%" "%config_file%"

echo Переключение завершено.
pause
