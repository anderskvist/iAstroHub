#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/lin_guider/patches/$1.patch $1
}

apt-get -y install \
  fxload \
  libftdi-dev \
  libqt4-dev \
  libusb-1.0-0-dev

mkdir -p /home/pi
cd /home/pi
wget https://sourceforge.net/projects/cccd/files/firmware/firmware-ccd_1.3_all.deb
dpkg -i firmware-ccd_1.3_all.deb

if [ "$CPU" == "arm" ] ; then
  wget https://sourceforge.net/projects/linguider/files/asi_sdk/lg_4.0.0/libasicamera-0.3.0623-armhf.deb
  dpkg -i --force-all libasicamera-0.3.0623-armhf.deb
  wget https://sourceforge.net/projects/linguider/files/atik_sdk/lg_3.3.0-4.0.0/atikccdsdk-1.1-v7-armhf.deb
  dpkg -i --force-all atikccdsdk-1.1-v7-armhf.deb
elif [ "$CPU" == "x86_64" ] ; then
  wget https://sourceforge.net/projects/linguider/files/asi_sdk/lg_4.0.0/libasicamera-0.3.0623-amd64.deb
  dpkg -i --force-all libasicamera-0.3.0623-amd64.deb
  wget https://sourceforge.net/projects/linguider/files/atik_sdk/lg_3.3.0-4.0.0/atikccdsdk-1.1-amd64.deb
  dpkg -i --force-all atikccdsdk-1.1-amd64.deb
else
  echo "Invalid CPU: $CPU"
  exit 1
fi

wget https://sourceforge.net/projects/libnexstar/files/libnexstar-0.15.tar.gz
tar -xvf libnexstar-0.15.tar.gz
cd /home/pi/libnexstar-0.15/
./configure
make
make install

cd /home/pi
wget https://sourceforge.net/projects/linguider/files/3.3.0/lin_guider-3.3.0.tar.bz2
tar -xvf lin_guider-3.3.0.tar.bz2
patch_file /home/pi/lin_guider_pack/lin_guider/src/lin_guider.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/rcalibration.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/server.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/include/guider.h
patch_file /home/pi/lin_guider_pack/lin_guider/include/rcalibration.h
patch_file /home/pi/lin_guider_pack/lin_guider/include/server.h
patch_file /home/pi/lin_guider_pack/lin_guider/src/video_dev/video_asi.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/video_dev/video_atik.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/video_dev/video_qhy5ii.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/video_dev/video_qhy6.cpp
patch_file /home/pi/lin_guider_pack/lin_guider/src/video_dev/video_sx.cpp
cd /home/pi/lin_guider_pack/lin_guider
./configure
make
