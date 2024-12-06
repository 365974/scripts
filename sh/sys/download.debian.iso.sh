#!/bin/sh
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.6.0-amd64-netinst.iso
dd if=debian-11.6.0-amd64-netinst.iso of=/dev/sdd