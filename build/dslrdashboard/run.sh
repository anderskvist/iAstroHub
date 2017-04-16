#!/bin/bash

source build/common.sh

apt-get -y install \
  build-essential \
  git \
  libusb-1.0-0-dev \
  pkg-config

git clone https://github.com/hubaiz/DslrDashboardServer.git /home/pi/DslrDashboardServer
cd /home/pi/DslrDashboardServer
g++ -Wall src/main.cpp src/communicator.cpp `pkg-config --libs --cflags libusb-1.0` -lpthread -lrt -lstdc++ -o ddserver
chmod +x ./ddserver
cp ./ddserver /home/pi/www/
