#!/bin/bash
#setup.image.sh

apt install -y genisoimage wget xorriso
wget -O debian-12.7.0-amd64-netinst.iso https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso
mkdir isofiles
xorriso -osirrox on -indev debian-12.7.0-amd64-netinst.iso -extract / isofiles
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz
echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
gzip isofiles/install.amd/initrd

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

chmod -w -R isofiles/install.amd/
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o preseed-debian-12.7.0-amd64-netinst.iso isofiles
rm -rf isofiles
rm debian-12.7.0-amd64-netinst.iso
rm preseed.cfg
rm setup.image.sh