#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/goqat/patches/$1.patch $1
}

apt-get -y install \
  libgtk-3-0 \
  libgtk-3-dev \
  grace

mkdir -p /home/pi
cd /home/pi
wget https://launchpad.net/ubuntu/+archive/primary/+files/goocanvas-2.0_2.0.2.orig.tar.xz
tar xvf goocanvas-2.0_2.0.2.orig.tar.xz
cd /home/pi/goocanvas-2.0.2
./configure
make
make install
ldconfig

cd /home/pi
wget http://canburytech.net/GoQat/download/goqat-2.1.1.tar.gz
tar xvf goqat-2.1.1.tar.gz
patch_file /home/pi/goqat-2.1.1/src/qsi.c
patch_file /home/pi/goqat-2.1.1/src/interface.c
cd /home/pi/goqat-2.1.1
./configure
make
make install
