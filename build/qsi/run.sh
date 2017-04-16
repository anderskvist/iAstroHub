#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/qsi/patches/$1.patch $1
}

apt-get -y install dos2unix

mkdir -p /home/pi
cd /home/pi
if [ "$CPU" == "arm" ] ; then
  wget http://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-arm-v7-hf-1.3.6.tgz
  tar xvf libftd2xx-arm-v7-hf-1.3.6.tgz
elif [ "$CPU" == "x86_64" ] ; then
  wget http://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-x86_64-1.3.6.tgz
  tar xvf libftd2xx-x86_64-1.3.6.tgz
else
  echo "Invalid CPU: $CPU"
  exit 1
fi

cd /home/pi/release/build/
cp libftd2xx.* /usr/lib
chmod 755 /usr/lib/libftd2xx.so.1.3.6
ln -fs /usr/lib/libftd2xx.so.1.3.6 /usr/lib/libftd2xx.so

cd /home/pi
wget http://www.qsimaging.com/downloads/qsiapi-7.2.0.tar.gz
tar xvf qsiapi-7.2.0.tar.gz
cd /home/pi/qsiapi-7.2.0/
dos2unix /home/pi/qsiapi-7.2.0/lib/CCDCamera.cpp
patch_file /home/pi/qsiapi-7.2.0/lib/CCDCamera.cpp
./configure --enable-libftd2xx --prefix=/usr./configure --enable-libftd2xx --prefix=/usr
make all
make install
ldconfig /usr/lib

echo '# 500-series' > /etc/udev/rules.d/99-qsi.rules
echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="eb48", MODE="0666"' >> /etc/udev/rules.d/99-qsi.rules
echo '# 600-series' >> /etc/udev/rules.d/99-qsi.rules
echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="eb49", MODE="0666"' >> /etc/udev/rules.d/99-qsi.rules
