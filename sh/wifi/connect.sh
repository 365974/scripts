#!/bin/sh
wpa_supplicant -B -i wlp3s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
iw wlp3s0 link
dhclient wlp3s0