#!/bin/sh
reso=1024x545
pass=password
server=8.8.8.8
port=3389
user=root
rdesktop -g $reso -u $user -p $pass $server:$port