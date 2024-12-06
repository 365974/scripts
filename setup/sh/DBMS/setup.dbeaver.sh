#!/bin/bash
sh -c 'echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list'
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
apt-get update
apt-get install dbeaver-ce
