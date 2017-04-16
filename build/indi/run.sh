#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/indi/patches/$1.patch $1
}

apt-get -y install \
  build-essential \
  cmake \
  dcraw \
  git \
  libboost-regex-dev \
  libcfitsio3-dev \
  libcurl4-gnutls-dev \
  libgps-dev \
  libgsl0-dev \
  libjpeg-dev \
  libnova-dev \
  libraw-dev \
  libusb-1.0-0-dev \
  zlib1g-dev

mkdir -p /home/pi
git clone --depth 1 https://github.com/indilib/indi.git /home/pi/indi
patch_file /home/pi/indi/libindi/drivers/agent/agent_imager.cpp
patch_file /home/pi/indi/3rdparty/indi-qsi/qsi_ccd.cpp
mkdir -p /home/pi/indi/build/libindi
cd /home/pi/indi/build/libindi
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../libindi
make
make install

cp /home/pi/indi/3rdparty/libsbig/sbigudrv.h /usr/include/

mkdir -p /home/pi/indi/build/3rdparty
cd /home/pi/indi/build/3rdparty
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

cd /home/pi/indi/3rdparty/indi-mi
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

if [ "$CPU" == "arm" ] ; then
  wget http://download.cloudmakers.eu/atikccd-1.22-armhf.deb
  dpkg -i --force-all atikccd-1.22-armhf.deb
  wget http://download.cloudmakers.eu/atikccdsdk-1.22-armhf.deb
  dpkg -i --force-all atikccdsdk-1.22-armhf.deb
elif [ "$CPU" == "x86_64" ] ; then
  wget http://download.cloudmakers.eu/atikccd-1.22-amd64.deb
  dpkg -i --force-all atikccd-1.22-amd64.deb
  wget http://download.cloudmakers.eu/atikccdsdk-1.22-amd64.deb
  dpkg -i --force-all atikccdsdk-1.22-amd64.deb
else
  exit 1
fi

cd /home/pi/indi/3rdparty/libqhy
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install

cd /home/pi/indi/3rdparty/indi-qhy
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
make
make install
