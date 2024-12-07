:: createvm.bat

:: настройка цвета
color 0A
chcp 65001

:: Имя виртуальной машины
set VM_NAME="debian"

:: Путь к файлам виртуальной машины
set VM_PATH="%USERPROFILE%/VirtualBox VMs/%VM_NAME%"

::Создать дерикторию
mkdir .\readyimage\

:: скачиваем виртуальную машину
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -o ".\software\wget\wget.exe" https://eternallybored.org/misc/wget/1.21.1/64/wget.exe
.\software\wget\wget.exe --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://download.virtualbox.org/virtualbox/7.1.4/VirtualBox-7.1.4-165100-Win.exe" -O ".\software\VirtualBox-7.1.4-165100-Win.exe"
.\software\wget\wget.exe --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --content-disposition "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-standard-3.20.3-x86_64.iso" -O ".\readyimage\alpine-standard-3.20.3-x86_64.iso"

::Установка
.\software\VirtualBox-7.1.4-165100-Win.exe --silent

:: Создание виртуальной машины
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name %VM_NAME% --ostype "Debian_64" --register --basefolder %VM_PATH%

:: Удаление установочного файла
del .\software\VirtualBox-7.1.4-165100-Win.exe

:: Настройка параметров виртуальной машины
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%VM_NAME%" --memory 2048 --vram 16 --cpus 1 --chipset piix3 --firmware bios ^
--pae off --longmode on --apic on --x2apic on --nested-hw-virt off --ioapic on --rtcuseutc on ^
--paravirtprovider default --cpu-profile host --hpet off --hwvirtex on --largepages on --vtxvpid on ^
--vtxux on --graphicscontroller vmsvga --audio-driver default --audiocontroller ac97 --audiocodec ad1980 ^
--usb on --usbehci on --usbohci on --usbxhci off --draganddrop disabled --clipboard disabled ^
--boot1 floppy --boot2 dvd --boot3 disk --boot4 none --bioslogofadein off --bioslogofadeout off

:: Создание и подключение жесткого диска
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename %VM_PATH%/cleardebian.vmdk --size 20000 --format VMDK --variant Fixed,Split2G
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl %VM_NAME% --name "SATA Controller" --add sata --controller IntelAhci
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach %VM_NAME% --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium %VM_PATH%/cleardebian.vmdk
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl %VM_NAME% --name "IDE Controller" --add ide --controller PIIX4
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach %VM_NAME% --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium emptydrive

:: Подключение диска
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach "%VM_NAME%" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "readyimage\alpine-standard-3.20.3-x86_64.iso"

:: Настройка сетевых адаптеров

:: Первый адаптер (NAT)
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --nic1 nat --nictype1 82540EM --cableconnected1 on
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --natpf1 "22,tcp,127.0.0.1,22,10.0.2.15,22"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --natpf1 "3389,tcp,127.0.0.1,3389,10.0.2.15,3389"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --natpf1 "80,tcp,127.0.0.1,80,10.0.2.15,80"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --natpf1 "443,tcp,127.0.0.1,443,10.0.2.15,443"

:: Настройка других опций
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm %VM_NAME% --uart1 off --uart2 off --uart3 off --uart4 off --lpt1 off --lpt2 off --vrde off --teleporter off

echo Готово! Виртуальная машина создана и настроена.
pause