#!/bin/bash

source build/common.sh

apt-get -y install \
  espeak \
  libglu1-mesa \
  libgtk2.0-0 \
  libpango1.0-0 \
  xplanet

mkdir -p /skychart
cd /skychart
if [ "$CPU" == "arm" ] ; then
  wget http://sourceforge.net/projects/libpasastro/files/version%201.1/libpasastro_1.1-15_armhf.deb
  dpkg -i libpasastro_1.1-15_armhf.deb
  wget http://sourceforge.net/projects/skychart/files/1-software/version_4.0/skychart_4.0-3575b_armhf.deb
  dpkg -i skychart_4.0-3575b_armhf.deb
elif [ "$CPU" == "x86_64" ] ; then
  wget http://sourceforge.net/projects/libpasastro/files/version%201.1/libpasastro_1.1-14_amd64.deb
  dpkg -i libpasastro_1.1-14_amd64.deb
  wget http://sourceforge.net/projects/skychart/files/1-software/version_4.0/skychart_4.0-3575b_amd64.deb
  dpkg -i skychart_4.0-3575b_amd64.deb
else
  echo "Invalid CPU: $CPU"
  exit 1
fi

wget http://sourceforge.net/projects/skychart/files/2-catalogs/Nebulea/skychart-data-pictures_4.0-3421_all.deb
dpkg -i skychart-data-pictures_4.0-3421_all.deb
