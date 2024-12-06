#!/bin/bash

#setup clear python3 for debian
apt purge python3 -y
apt autoremove -y
apt install python3 --no-install-recommends -y

#package
apt install python3.11-venv --no-install-recommends -y
apt install python3-pip --no-install-recommends -y

#create virtual environment
python3 -m venv myvenv



