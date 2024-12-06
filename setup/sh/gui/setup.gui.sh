#!/bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install -y  xorg xterm openbox feh tint2 wget mousepad pcmanfm xrdp fail2ban
wget https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Clouds_over_the_Atlantic_Ocean.jpg/1280px-Clouds_over_the_Atlantic_Ocean.jpg -O /root/Ocean.jpg 
mkdir -p /root/.config/openbox 
touch /root/.config/openbox/autostart.sh
echo "setxkbmap -layout us,ru -variant -option grp:ctrl_shift_toggle,grp_led:scroll" >> /root/.config/openbox/autostart.sh
echo "tint2 &" >> /root/.config/openbox/autostart.sh
echo "feh --bg-scale /root/Ocean.jpg &" >> /root/.config/openbox/autostart.sh

