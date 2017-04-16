#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/openskyimager/patches/$1.patch $1
}

apt-get -y install \
  cmake \
  fxload \
  imagemagick \
  libcfitsio3-dev \
  libglib2.0-0 \
  libglib2.0-dev \
  libgtk2.0-0 \
  libgtk2.0-dev \
  libudev-dev

# The following is only needed if lin_guider has not already been installed
# with atik libraries.
#if [ "$CPU" == "arm" ] ; then
#  wget http://download.cloudmakers.eu/atikccd-1.22-armhf.deb
#  dpkg -i --force-all atikccd-1.22-armhf.deb
#  wget http://download.cloudmakers.eu/atikccdsdk-1.22-armhf.deb
#  dpkg -i --force-all atikccdsdk-1.22-armhf.deb
#elif [ "$CPU" == "x86_64" ] ; then
#  wget http://download.cloudmakers.eu/atikccd-1.22-amd64.deb
#  dpkg -i --force-all atikccd-1.22-amd64.deb
#  wget http://download.cloudmakers.eu/atikccdsdk-1.22-amd64.deb
#  dpkg -i --force-all atikccdsdk-1.22-amd64.deb
#else
#  echo "Invalid CPU: $CPU"
#  exit 1
#fi

mkdir -p /home/pi
git clone --depth 1 http://github.com/OpenSkyProject/OpenSkyImager.git /home/pi/OpenSkyImager
patch_file /home/pi/OpenSkyImager/gtk/imgPixbuf.c
patch_file /home/pi/OpenSkyImager/gtk/imgWFuncs.c
patch_file /home/pi/OpenSkyImager/sbig/install_sbig.bash
mkdir /home/pi/OpenSkyImager/build
cd /home/pi/OpenSkyImager/build
cmake -D FORCE_GTK2=on -D FORCE_QHY_ONLY=off ..
make install
