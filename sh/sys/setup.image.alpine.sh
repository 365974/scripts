#!/bin/sh
# setup.image.alpine.sh

# Установка необходимых пакетов
apk update
apk add wget gzip xorriso busybox

# Загрузка ISO-образа Debian
wget -O debian-12.8.0-amd64-netinst.iso https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso

# Извлечение содержимого ISO-образа
mkdir isofiles
xorriso -osirrox on -indev debian-12.8.0-amd64-netinst.iso -extract / isofiles

chmod +w -R isofiles/install.amd/
mkdir -p /tmp/initrd
cd /tmp/initrd

# Распаковка initrd.gz
cp /root/dir/isofiles/install.amd/initrd.gz /tmp/initrd/initrd.gz
gunzip initrd.gz
busybox cpio -idmv < initrd

# Добавление preseed.cfg
cp /root/dir/preseed.cfg /tmp/initrd/

# Упаковка обратно
find . | busybox cpio -o -H newc > /tmp/initrd/new_initrd
gzip -c /tmp/initrd/new_initrd > /root/dir/isofiles/install.amd/initrd.gz

cd -
rm -rf /tmp/initrd

# Добавляем автоматический выбор загрузки в isolinux.cfg
cat <<EOL > isofiles/isolinux/isolinux.cfg
# D-I config version 2.0
path
prompt 0
timeout 0
include menu.cfg
default auto
EOL

# Добавляем пункт меню auto в txt.cfg для автоматической установки
cat <<EOL >> isofiles/isolinux/txt.cfg
label auto
  menu label ^Automated install
  kernel /install.amd/vmlinuz
  append auto=true priority=critical vga=788 initrd=/install.amd/initrd.gz --- quiet
EOL

# Восстановление прав на initrd
chmod -w -R isofiles/install.amd/

# Создание нового ISO-образа с помощью xorriso
xorriso -as mkisofs \
  -r -J \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -o preseed-debian-12.8.0-amd64-netinst.iso \
  isofiles

# Очистка
#rm -rf isofiles
#rm debian-12.8.0-amd64-netinst.iso
#rm preseed.cfg
#rm setup.image.alpine.sh
