#!/bin/bash

source build/common.sh

patch_file() {
  patch -b -i /build/audio/patches/$1.patch $1
}

apt-get -y install \
  alsa-utils \
  festival

cd /home/pi/
mkdir hts_tmp
cd hts_tmp/
wget -c http://hts.sp.nitech.ac.jp/archives/2.1/festvox_nitech_us_bdl_arctic_hts-2.1.tar.bz2
tar xvf festvox_nitech_us_bdl_arctic_hts-2.1.tar.bz2

mkdir -p /usr/share/festival/voices/us
mv lib/voices/us/* /usr/share/festival/voices/us/
mv lib/hts.scm /usr/share/festival/hts.scm

patch_file /usr/share/festival/voices/us/nitech_us_bdl_arctic_hts/festvox/nitech_us_bdl_arctic_hts.scm
