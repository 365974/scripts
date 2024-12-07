#!/bin/sh
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso
dd if=debian-12.5.0-amd64-netinst.iso of=/dev/sdb1