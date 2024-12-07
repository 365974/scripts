apt-get install apt-transport-https -y
touch /etc/apt/sources.list.d/tor.list
echo "deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org amd64 main" >> /etc/apt/sources.list.d/tor.list
echo "deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org amd64 main" >> /etc/apt/sources.list.d/tor.list
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
apt update
apt-get install tor deb.torproject.org-keyring -y

