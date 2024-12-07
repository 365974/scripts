#!/bin/sh
touch /etc/fail2ban/jail.local
echo "# Fail2Ban LOCAL configuration file." >> /etc/fail2ban/jail.local
echo "[DEFAULT]" >> /etc/fail2ban/jail.local
echo "bantime  = 3h" >> /etc/fail2ban/jail.local
echo "findtime = 10m" >> /etc/fail2ban/jail.local
echo "maxretry = 5" >> /etc/fail2ban/jail.local
echo "ignoreip = 127.0.0.1" >> /etc/fail2ban/jail.local
echo "# JAILS" >> /etc/fail2ban/jail.local
echo "[sshd]" >> /etc/fail2ban/jail.local
echo "enabled = true" >> /etc/fail2ban/jail.local
echo "[recidive]" >> /etc/fail2ban/jail.local
echo "enabled   = true" >> /etc/fail2ban/jail.local
echo "bantime   = 9w" >> /etc/fail2ban/jail.local
echo "findtime  = 3d" >> /etc/fail2ban/jail.local
systemctl reload fail2ban