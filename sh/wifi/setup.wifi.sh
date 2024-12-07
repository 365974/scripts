#!/bin/sh
wpa_passphrase "ssid" "password" >> /etc/wpa_supplicant/wpa_supplicant.conf
cat /etc/wpa_supplicant/wpa_supplicant.conf
