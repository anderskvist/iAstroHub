#!/bin/bash

source build/common.sh

apt-get -y install \
  ser2net \
  socat

echo "3300:raw:0:/dev/ttyUSB0:9600 NONE 1STOPBIT 8DATABITS" >> /etc/ser2net.conf
echo "3301:raw:0:/dev/ttyUSB0:19200 EVEN 1STOPBIT 8DATABITS" >> /etc/ser2net.conf
