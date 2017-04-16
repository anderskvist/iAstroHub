#!/bin/bash

source build/common.sh

apt-get -y install \
  libcairo2-dev \
  libjpeg-dev \
  libnetpbm10-dev \
  libpng12-dev \
  netpbm \
  python-dev \
  python-pip \
  python-pyfits \
  python-numpy \
  wget \
  zlib1g-dev

if [ "$CPU" == "arm" ] ; then
  apt-get -y install gcc-4.4
fi

pip install pyephem

mkdir -p /home/pi
cd /home/pi
wget http://www.astrometry.net/downloads/astrometry.net-0.40.tar.bz2
tar xjf astrometry.net-0.40.tar.bz2
rm astrometry.net-0.40.tar.bz2
LOCATION=/home/pi/astrometry.net-0.40/blind/solve-field.c; patch -b -i /build/astrometry/patches/$LOCATION.patch $LOCATION
LOCATION=/home/pi/astrometry.net-0.40/util/starutil.c; patch -b -i /build/astrometry/patches/$LOCATION.patch $LOCATION
cd /home/pi/astrometry.net-0.40
if [ "$CPU" == "arm" ] ; then
  CC=gcc-4.4 make
elif [ "$CPU" == "x86_64" ] ; then
  make
else
  echo "Invalid CPU: $CPU"
  exit 1
fi
make install

cd /usr/local/astrometry/data/
wget http://broiler.astrometry.net/~dstn/4200/index-4207-00.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-01.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-02.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-03.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-04.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-05.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-06.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-07.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-08.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-09.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-10.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4207-11.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4208.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4209.fits
wget http://broiler.astrometry.net/~dstn/4200/index-4210.fits
