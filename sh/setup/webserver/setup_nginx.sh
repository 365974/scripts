#!/bin/bash
apt-get update && apt-get upgrade
apt-get install nginx
systemctl start nginx
systemctl enable nginx