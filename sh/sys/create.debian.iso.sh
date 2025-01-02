#!/bin/bash
# setup.image.debian.xorriso.sh

# Установка необходимых пакетов
apt update
apt install -y wget gzip xorriso cpio isolinux

# Загрузка ISO-образа Debian
wget -O debian-12.8.0-amd64-netinst.iso https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso

# Извлечение содержимого ISO-образа
mkdir -p isofiles
xorriso -osirrox on -indev debian-12.8.0-amd64-netinst.iso -extract / isofiles

# Подготовка временной директории для работы с initrd.gz
chmod +w -R isofiles/install.amd/
mkdir -p /tmp/initrd
cp isofiles/install.amd/initrd.gz /tmp/initrd/
cd /tmp/initrd

# Распаковка initrd.gz
gunzip initrd.gz
cpio -idmv < initrd

# Добавление preseed.cfg в initrd
cp /root/dir/preseed.cfg .

# Упаковка initrd.gz обратно
find . | cpio -o -H newc | gzip > /root/isofiles/install.amd/initrd.gz

# Очистка временной директории
cd -
rm -rf /tmp/initrd

# Изменение конфигурации загрузчика
cat <<EOL > isofiles/isolinux/isolinux.cfg
# D-I config version 2.0
path
prompt 0
timeout 0
include menu.cfg
default auto
EOL

cat <<EOL >> isofiles/isolinux/txt.cfg
label auto
  menu label ^Automated install
  kernel /install.amd/vmlinuz
  append auto=true priority=critical vga=788 initrd=/install.amd/initrd.gz --- quiet
EOL

# Создание нового ISO-образа с помощью xorriso
xorriso -as mkisofs \
  -r -J \
  -V "Debian 12.8.0 amd64 n" \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  --efi-boot /boot/grub/efi.img \
  --grub2-boot-info \
  --protective-msdos-label \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -partition_offset 16 \
  -isohybrid-gpt-basdat \
  -isohybrid-apm-hfsplus \
  -o preseed-debian-12.8.0-amd64-netinst.iso \
  isofiles

dd if=preseed-debian-12.8.0-amd64-netinst.iso of=/dev/sdb bs=4M status=progress
sync
cmp preseed-debian-12.8.0-amd64-netinst.iso /dev/sdb
# Очистка временных файлов (по необходимости закомментируйте строки для диагностики)
# rm -rf isofiles
# rm debian-12.8.0-amd64-netinst.iso
# rm /root/dir/preseed.cfg
# rm setup.image.debian.xorriso.sh
