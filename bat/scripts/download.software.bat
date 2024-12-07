:: download.software.bat

:: настройка цвета
color 0A

:: Создаём папки
mkdir .\software
mkdir .\software\wget
mkdir .\software\putty
mkdir .\software\7z
mkdir .\software\7z\7za
mkdir .\dir

:: Скачать образ и утилиты
:: Скачиваем портативные версии
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -o ".\software\wget\wget.exe" https://eternallybored.org/misc/wget/1.21.1/64/wget.exe
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://www.7-zip.org/a/7zr.exe" -O ".\software\7z\7zr.exe"
@timeout /t 3 /nobreak
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://the.earth.li/~sgtatham/putty/latest/w64/pscp.exe" -O ".\software\putty\pscp.exe"
timeout /t 3 /nobreak
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe" -O ".\software\putty\plink.exe"
timeout /t 3 /nobreak
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe" -O ".\software\putty\putty.exe"
timeout /t 3 /nobreak
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://www.7-zip.org/a/7z2408-extra.7z" -O ".\dir\7z2408-extra.7z"
timeout /t 3 /nobreak 
.\software\wget\wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://the.earth.li/~sgtatham/putty/latest/w64/puttygen.exe" -O ".\software\putty\puttygen.exe"
timeout /t 3 /nobreak 


:: Распаковка архивов
.\software\7z\7zr x .\dir\7z2408-extra.7z -o.\dir\7z\
move ".\dir\7z\x64\*" ".\software\7z\"

:: Удаляем распакованные папки
rmdir /S /Q .\dir\7z
del .\dir\7z2408-extra.7z
del .\software\7z\7zr.exe